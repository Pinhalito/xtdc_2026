#!/bin/bash
#
#######################
#    ^...^  `^...^´   #
#   /_o,o_\ /_O,O_\   #
#   |):::(| |):::(|   #
# ====" "=====" "==== #
#         TdC         #
#      1998-2026      #
#######################
#
# Toca das Corujas
# Códigos Binários,
# Funções de Onda e
# Teoria do Orbital Molecular Inc.
# Unidade Barão Geraldo CX
#
# 2026_11_08_20_18_40
URLS=(
"https://www.youtube.com/watch?v=53QVhqxI8mE"
"https://www.youtube.com/watch?v=DyjlxsJEknc"
"https://www.youtube.com/watch?v=sPnWixI-iaE"
"https://www.youtube.com/watch?v=sQljbpsXKUY"
"https://www.youtube.com/watch?v=Tdy9tdCF9WM"
)
for URL in "${URLS[@]}"; do
    yt-dlp \
            -f "bv*[height<=720][vcodec^=avc1][ext=mp4]+ba[acodec^=mp4a][ext=m4a]/b[height<=720][ext=mp4]" \
            --merge-output-format mp4 \
            --recode-video mp4 \
            --postprocessor-args "VideoConvertor:-c:v libx264 -preset veryfast -crf 25 -c:a aac -b:a 128k -pix_fmt yuv420p -movflags +faststart" \
            "$URL"
done
