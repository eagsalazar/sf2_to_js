Gem::Specification.new do |s|
  s.name        = 'sf2_to_js'
  s.version     = '0.0.2'
  s.date        = '2013-05-22'
  s.summary     = "Convert sf2 sound fonts to js"
  s.authors     = "Esteban Salazar"
  s.homepage    = "https://github.com/eagsalazar/sf2_to_js"
  s.description = "Output js files compatible with https://github.com/eagsalazar/midi.js"
  s.files       = ["lib/sf2_to_js.rb"]

  s.add_runtime_dependency 'midilib'
  s.add_runtime_dependency 'colorize'

  s.executables << 'sf2_to_js'
end
