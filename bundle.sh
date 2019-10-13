#!/usr/bin/env bash

set -e

cp /home/creikey/.config/godot/editor_settings-3.tres tmp.tres

rm -r exports/web
mkdir exports/web
godot-headless --path src --export web "$(readlink -f ./exports/web/index.html)"
butler push exports/web lajollagamesclub/space-defenders:web 

mv tmp.tres /home/creikey/.config/godot/editor_settings-3.tres
