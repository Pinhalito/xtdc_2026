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

DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

DORMIR="$DIR/dormir.sh"
ACORDAR="$DIR/acordar.sh"

if [[ ! -f "$DORMIR" || ! -f "$ACORDAR" ]]; then
    echo "Erro: não encontrei dormir.sh ou acordar.sh na mesma pasta."
    exit 1
fi

# Garante que os scripts possam ser executados
chmod +x "$DORMIR" "$ACORDAR"

abrir_terminal() {
    local SCRIPT="$1"
    local NOME="$2"

    if command -v gnome-terminal >/dev/null 2>&1; then
        gnome-terminal -- bash -c "exec bash '$SCRIPT'"

    elif command -v konsole >/dev/null 2>&1; then
        konsole -e bash -c "exec bash '$SCRIPT'"

    elif command -v xfce4-terminal >/dev/null 2>&1; then
        xfce4-terminal --command="bash '$SCRIPT'"

    elif command -v mate-terminal >/dev/null 2>&1; then
        mate-terminal -- bash -c "exec bash '$SCRIPT'"

    elif command -v xterm >/dev/null 2>&1; then
        xterm -hold -e bash "$SCRIPT"

    else
        echo "Nenhum emulador de terminal conhecido foi encontrado."
        exit 1
    fi
}

# Usa Zenity, se estiver instalado
if command -v zenity >/dev/null 2>&1; then
    ESCOLHA=$(zenity \
        --list \
        --title="Agendamento do computador" \
        --text="O que você deseja fazer?" \
        --column="Opção" \
        "Dormir por um período" \
        "Acordar em um horário específico" \
        --height=250 \
        --width=450) || exit 0

    case "$ESCOLHA" in
        "Dormir por um período")
            abrir_terminal "$DORMIR" "Dormir"
            ;;
        "Acordar em um horário específico")
            abrir_terminal "$ACORDAR" "Acordar"
            ;;
    esac

# Usa YAD, se Zenity não estiver instalado
elif command -v yad >/dev/null 2>&1; then
    ESCOLHA=$(yad \
        --list \
        --title="Agendamento do computador" \
        --text="O que você deseja fazer?" \
        --column="Opção" \
        "Dormir por um período" \
        "Acordar em um horário específico" \
        --height=250 \
        --width=450 \
        --print-column=1) || exit 0

    case "$ESCOLHA" in
        "Dormir por um período")
            abrir_terminal "$DORMIR" "Dormir"
            ;;
        "Acordar em um horário específico")
            abrir_terminal "$ACORDAR" "Acordar"
            ;;
    esac

# Fallback caso não haja Zenity nem YAD
else
    abrir_terminal "$DORMIR" "Dormir"
fi
