module Sf2ToJs
  class Sf2ToJs

    require 'base64'
    require 'midilib'
    require 'fileutils'
    require 'colorize'
    require 'tempfile'
    include FileUtils

    MIDI_LOWEST_NOTE_INDEX = 21
    MIDI_HIGHTEST_NOTE_INDEX = 108
    NOTES = MIDI_LOWEST_NOTE_INDEX..MIDI_HIGHTEST_NOTE_INDEX
    JS_NOTE_DURATION = 2500 # ms
    JS_NOTE_VELOCITY = 85

    attr_accessor :instrument_ids, :sf2_path, :output_dir

    def initialize sf2_path=nil, instrument_ids = [], output_dir="./soundfonts/"
      check_deps
      @sf2_path = File.expand_path(sf2_path)
      @instrument_ids = instrument_ids
      @output_dir = File.expand_path(output_dir)
      mkdir_p @output_dir
    end

    def check_deps
      raise 'missing fluidsynth (brew install fluidsynth)' unless `which fluidsynth`
      raise 'missing oggenc (brew install fluidsynth)' unless `which oggenc`
    end

    def to_js
      raise 'no sf2_path!' unless File.exist? @sf2_path

      font_root_name = File.basename @sf2_path, '.*'
      path = "window.Midi.Soundfont.#{font_root_name}"

      instruments.each do |inst|
        inst_root_name = inst[:name].gsub(/\s*/, "")
        @js_file = File.open("#{@output_dir}/#{font_root_name}.#{inst_root_name}.sf2.js", "w")
        @js_file.puts define_js(path)

        @js_file.puts "#{path}[\"#{inst[:name]}\"] = ["
        NOTES.each do |note_index|
          ogg_64b = ogg_64b_note(inst[:bank], inst[:id], note_index)
          @js_file.print "  \"#{ogg_64b}\""
          @js_file.puts ", " unless (note_index == MIDI_HIGHTEST_NOTE_INDEX)
        end
        @js_file.puts
        @js_file.print "];"

        @js_file.close
      end
    end

    private

    def one_note_midi bank_id, instrument_id, note_index
      seq = MIDI::Sequence.new()
      track = MIDI::Track.new(seq)

      seq.tracks << track
      track.events << MIDI::ProgramChange.new(0, (bank_id*128) + instrument_id)
      track.events << MIDI::NoteOn.new(0, note_index, JS_NOTE_VELOCITY, 0) # channel, note, velocity, delta
      track.events << MIDI::NoteOff.new(0, note_index, JS_NOTE_VELOCITY, JS_NOTE_DURATION)

      f = Tempfile.new 'midifile'
      begin
        seq.write f
        f.close
        yield f.path
      ensure
        f.unlink
      end
    end

    def midi_to_ogg midi_path
      wav_file = Tempfile.new 'wavfile'
      ogg_file = Tempfile.new 'oggfile'
      begin
        sh "fluidsynth -C 1 -R 1 -g 0.5 -F #{wav_file.path} #{@sf2_path} #{midi_path}"
        sh "oggenc -m 32 -M 64 #{wav_file.path} -o #{ogg_file.path}"
        yield ogg_file.read
      ensure
        wav_file.unlink
        ogg_file.unlink
      end
    end

    def define_js object_path
      path = ""
      js = ""
      object_path.split(".").each do |section|
        path = path.length > 0 ? path + ".#{section}" : section
        js += "if (typeof(#{path}) == 'undefined') #{path} = {};\n"
      end
      js
    end

    def instruments
      @instruments = cmdfile 'inst 1' do |cmd_path|
        raw = sh("fluidsynth -i -f #{cmd_path} #{@sf2_path}")
        raw.scan(/^(\d\d\d)-(\d\d\d) *(.*)$/).map do |inst|
          {bank: inst[0].to_i, id: inst[1].to_i, name: inst[2]}
        end
      end

      @instruments.select! { |inst| @instrument_ids.member? inst[:id] } unless @instrument_ids.empty?
      @instruments
    end

    def ogg_64b_note bank_id, instrument_id, note_index
      encoded = nil
      one_note_midi bank_id, instrument_id, note_index do |midi_path|
        midi_to_ogg midi_path do |ogg|
          encoded = Base64.strict_encode64(ogg)
        end
      end
      "data:audio/ogg;base64,#{encoded}"
    end

    def cmdfile cmds
      f = Tempfile.new 'cmdfile'
      begin
        f.write cmds
        f.close
        yield f.path
      ensure
        f.unlink
      end
    end

    def sh cmd
      puts cmd.green
      result = `#{cmd}`
      unless $?.success?
        puts 'FAIL'.red
        exit 1
      end
      result
    end

  end
end
