#!/bin/bash
# $1 = union
# we're going to remove these icons, since they will be provided in separate extension
# This is to be able to use different icon for Slax Software Center, which is also handled by FireFox

rm -f $1/usr/lib*/firefox*/chrome/icons/default/*.png

# patch default search engine icon
GGG="$(find $1/usr/lib*/firefox*/searchplugins/google.xml)"
cat $GGG | while read -r LINE; do
   if echo "$LINE" | grep -q Image; then
      echo '<Image width="16" height="16">data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABMAAAATCAYAAAByUDbMAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAASFJREFUeNrM1D1PwlAUh3GKJIgbCSMwa7AwO+PAxstiDMapq7NvJA4YwofoRISdCQLszBqju7gRVgwL5TnJGaBDbYEYb/LLSS/hT3vuKYbjOKF9rXBoj+v/hkXcG5ZlxSh3qCKNCdpo2rY99woz1g+AoCPKCGf4wDuyOMYY516B7se816A6TL54Qc2gofsPQXp2pXfzRNBSNrTW8Kmf+w5L4o2AjeHT61ekgoRJs7P0znAdilzn8BUk7AWn0jMCwhp0QHnGiZ6q79FoIo9HVAiS/pl6mrKivkdjbc5udc6kh9/oII4bzHBJH4e/hnktfmhKSUBmrUzgYJfX6RoLyHB3CS9sHcad9Cgl/OAQrZ1edAL7lCLkkXtb9+xP/4JWAgwA1JVbfaZxn6EAAAAASUVORK5CYII=</Image>' >> aaa
   else
      echo "$LINE" >> aaa
   fi
done
mv aaa "$GGG"
