#!/bin/bash

export DARTIUM_BIN="$DART_SDK/../chromium/Chromium.app/Contents/MacOS/Chromium"

echo ---------------
echo Pub install
echo ------------
pub install


echo ------------
echo Running Specs DartVM
echo ------------
./node_modules/karma/bin/karma start --single-run --browsers Dartium


echo -------------------
echo Karma-JS
echo -------------------
./node_modules/karma/bin/karma start --single-run --browsers PhantomJS


echo ------------
echo Cleanup
echo ------------
echo rm -rf build