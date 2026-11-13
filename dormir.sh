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
# 

set -e

# Quantos minutos suspender
#MIN=40
printf "Dormir quanto tempo? "
read -r MIN


# Tempo em segundos
SEC=$((MIN*60))

# Atualiza o horário do RTC para agora e agenda um wakeup após SEC
# (precisa do pacote util-linux, mas normalmente já vem no Ubuntu)
RTC_NOW=$(date +%s)

WAKEUP_EPOCH=$((RTC_NOW + SEC))

# Define o wakeup no RTC usando /sys/class/rtc/rtc0/wakealarm
# (o caminho pode variar; tentamos rtc0 primeiro)
RTC_DEV="/sys/class/rtc/rtc0"
WAKE_FILE="$RTC_DEV/wakealarm"

if [ ! -e "$WAKE_FILE" ]; then
  echo "Não achei $WAKE_FILE. Verifique se o seu sistema tem rtc0/wakealarm."
  exit 1
fi

# Desabilita alarm antigo, define novo, e habilita
echo 0 | sudo tee "$WAKE_FILE" >/dev/null 2>&1 || true
echo "$WAKEUP_EPOCH" | sudo tee "$WAKE_FILE" >/dev/null

# Confirma que o alarm foi gravado
echo "Dormindo por $MIN minutos até $(date -d "@$WAKEUP_EPOCH")"

# Suspende
systemctl suspend
