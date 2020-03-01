#!/usr/bin/env sh
ffmpeg -i $1 -f ffmetadata -i .tmphash -c copy -map_metadata 1 -movflags use_metadata_tags signed.mkv

