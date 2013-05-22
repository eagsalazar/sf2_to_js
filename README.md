sf2\_to\_js
=========

Gem and scripts to convert sf2 sound font files to js
consumable by https://github.com/eagsalazar/midi.js

- required gems: midilib, fileutils, colorize, base64
- required system (brew install): fluidsynth, oggenc

usage:
=========

```
gem install sf2_to_js
```

```ruby
require 'sf2_to_js'
sf = Sf2ToJs.new "./FluidR3_GM.sf2", [105], "~/soundfonts"
sf.to_js # -> ~/soundfonts/FluidR3_GM.Banjo.sf2.js
```

bin/sf2\_to\_js:
=========

Generate .sf2.js files from the command line.

First:
```
gem install thor
```

Then:
```
sf2_to_js # -> lists commands
```

```
sf2_to_js help to_js # -> options for to_js
```

```
sf2_to_js to_js ~/Downloads/MagiCs5StringBanjo.sf2 -o ~/sf2/
# -> ~/sf2/FluidR3\_GM.Banjo.sf2.js
```
