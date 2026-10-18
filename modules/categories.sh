#!/usr/bin/env bash

# Categories module

categories_init() {
    # Ensure it's available globally
    declare -g -A CATEGORY_MAP

    # Documents
    for ext in pdf doc docx txt odt rtf; do CATEGORY_MAP["$ext"]="Documents"; done
    # Images
    for ext in jpg jpeg png gif svg webp bmp tiff; do CATEGORY_MAP["$ext"]="Images"; done
    # Audio
    for ext in mp3 wav flac aac ogg m4a; do CATEGORY_MAP["$ext"]="Audio"; done
    # Video
    for ext in mp4 mkv avi mov webm; do CATEGORY_MAP["$ext"]="Video"; done
    # Archives
    for ext in zip tar gz bz2 xz 7z; do CATEGORY_MAP["$ext"]="Archives"; done
    # Spreadsheets
    for ext in xls xlsx csv ods; do CATEGORY_MAP["$ext"]="Spreadsheets"; done
    # Presentations
    for ext in ppt pptx odp; do CATEGORY_MAP["$ext"]="Presentations"; done
    # Code
    for ext in sh py js ts java c cpp html css; do CATEGORY_MAP["$ext"]="Code"; done
}

get_category_for_ext() {
    local ext="${1,,}" # convert to lowercase
    if [[ -v CATEGORY_MAP["$ext"] ]]; then
        echo "${CATEGORY_MAP[$ext]}"
    else
        echo "Other"
    fi
}
