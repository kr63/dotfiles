find . -name '*.mp4' | sed -e 's%^./%%g' | sort -n >> "${PWD##*/}".m3u
for dir in ./*/
do
    dir=${dir%*/}
    echo ${dir##*/}
    cd "${dir##*/}"
    find . -name '*.mp4' | sed -e 's%^./%%g' | sort -n >> playlist.m3u
    # for filename in ./*.mp4; do
    #     echo "${dir##*/}"/"${filename##*/}" >> "../${PWD##*/}".m3u
    # done
    cd ../
done

    
