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

printf "A que horas ligar hoje? (HH:MM): "
read -r HORA

# Valida o formato básico HH:MM
if [[ ! "$HORA" =~ ^([01][0-9]|2[0-3]):[0-5][0-9]$ ]]; then
    echo "Formato inválido. Use HH:MM, por exemplo: 12:22"
    exit 1
fi

# Converte o horário de hoje para timestamp Unix
WAKEUP_EPOCH=$(date -d "today $HORA" +%s)
AGORA=$(date +%s)

# Impede horários que já passaram
if (( WAKEUP_EPOCH <= AGORA )); then
    echo "Esse horário já passou hoje."
    exit 1
fi

RTC_DEV="/sys/class/rtc/rtc0"
WAKE_FILE="$RTC_DEV/wakealarm"

if [[ ! -e "$WAKE_FILE" ]]; then
    echo "Não achei $WAKE_FILE."
    echo "Verifique se o sistema possui um RTC compatível com wakealarm."
    exit 1
fi

# Cancela qualquer alarme anterior
echo 0 | sudo tee "$WAKE_FILE" >/dev/null

# Agenda o computador para ligar no horário informado
echo "$WAKEUP_EPOCH" | sudo tee "$WAKE_FILE" >/dev/null

echo "Alarme configurado para hoje às $(date -d "@$WAKEUP_EPOCH" '+%H:%M:%S')."
echo "O computador será suspenso agora."

# Suspende o computador
systemctl suspend
