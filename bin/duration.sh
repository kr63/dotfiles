# find . -maxdepth 1 -iname '*.mp4' -exec ffprobe -v quiet -of csv=p=0 -show_entries format=duration {} \; | paste -sd+ -| bc
a1=$(find . -maxdepth 2 -iname '*.mp4' -exec ffprobe -v quiet -of csv=p=0 -show_entries format=duration {} \; | paste -sd+ -| bc)
int=${a1%.*}

printf '%02dH:%02dM:%02dS\n' $(($int/3600)) $(($int%3600/60)) $(($int%60))
