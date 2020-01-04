#! /bin/sh

a1=$(awk -F "://" '{print $2}' <<< $1)
rm a1.m3u
echo '#EXTM3U' >> a1.m3u
echo '#EXTINF:-1,Ani (Детские)' >> a1.m3u
echo "http://127.0.0.1:6878/ace/getstream?id=$a1&.mp4" >> a1.m3u
mpv a1.m3u
