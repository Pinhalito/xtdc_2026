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
# 2026_11_08_20_21_44

URLS=(
"https://www.youtube.com/watch?v=8UmvBVoObXI"
)

for URL in "${URLS[@]}"; do
    yt-dlp \
        -x \
        --audio-format mp3 \
        --audio-quality 0 \
        "$URL"
done
