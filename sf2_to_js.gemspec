# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.authors     = ["Esteban Salazar"]

  spec.name        = 'sf2_to_js'
  spec.version     = '0.0.3'

  spec.summary     = "Convert sf2 sound fonts to js"
  spec.homepage    = "https://github.com/eagsalazar/sf2_to_js"
  spec.description = "Output js files compatible with https://github.com/eagsalazar/midi.js"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'midilib'
  spec.add_runtime_dependency 'colorize'
  spec.add_runtime_dependency 'thor'
end

