sf2\_to\_js
=========

Gem and scripts to convert sf2 sound font files to js
consumable by https://github.com/eagsalazar/midi.js

- required gems: midilib, fileutils, colorize, base64
- required system (brew install): fluidsynth, oggenc

usage:
=========

```
gem install 
```

```ruby
require 'sf2_to_js'
sf = Sf2ToJs.new "./FluidR3_GM.sf2", [105], "~/soundfonts"
sf.to_js # -> ~/soundfonts/FluidR3_GM.Banjo.sf2.js
```

thor script:
=========

Generate sf2.js files from the command line.

```
thor list
```

```
thor help sf2:to_js
```

```
thor sf2:to_js ~/Downloads/MagiCs5StringBanjo.sf2 -o ~/sf2/
```
