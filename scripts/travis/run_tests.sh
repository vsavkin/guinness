#!/bin/bash

set -e

DART_DIST=dartsdk-linux-x64-release.zip
DARTIUM_DIST=dartium-linux-x64-release.zip


echo -------------------
echo Fetching dart sdk
echo -------------------

curl http://storage.googleapis.com/dart-archive/channels/stable/release/latest/sdk/$DART_DIST > $DART_DIST


echo -------------------
echo Fetching dartium
echo -------------------

curl http://storage.googleapis.com/dart-archive/channels/stable/raw/latest/dartium/$DARTIUM_DIST > $DARTIUM_DIST


unzip $DART_DIST > /dev/null
unzip $DARTIUM_DIST > /dev/null
rm $DART_DIST
rm $DARTIUM_DIST
mv dartium-* dartium;

export DART_SDK="$PWD/dart-sdk"
export PATH="$DART_SDK/bin:$PATH"
export DARTIUM_BIN="$PWD/dartium/chrome"


echo -------------------
echo Pub install
echo -------------------
pub install


echo -------------------
echo Dart analyzer
echo -------------------
dartanalyzer lib/guinness_html.dart | grep "No issues found"

if [ $? -ne 0 ]; then
  echo Dart analyzer failed
  dartanalyzer lib/guinness_html.dart
  exit 1
fi


echo -------------------
echo Karma
echo -------------------
sh -e /etc/init.d/xvfb start
./node_modules/karma/bin/karma start --single-run --browsers Dartium