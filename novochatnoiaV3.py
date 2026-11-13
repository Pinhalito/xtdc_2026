#!/usr/bin/env python3
# -*- coding: utf-8 -*-
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
# 2026_10_11_00_43_31
#
import json
import subprocess
import sys
import time
from pathlib import Path

import pandas as pd


def esperar_arquivo_estavel(path, timeout=10):
    """Espera o arquivo terminar de ser escrito."""
    last_size = -1

    for _ in range(timeout * 2):
        if not path.exists():
            time.sleep(0.5)
            continue

        size = path.stat().st_size

        if size == last_size:
            return True

        last_size = size
        time.sleep(0.5)

    return True


def converter(json_file):
    print(f"\nConvertendo {json_file.name}...")

    esperar_arquivo_estavel(json_file)

    with open(json_file, "r", encoding="utf-8") as f:
        chat = json.load(f)

    df = pd.DataFrame(chat)

    df = df.rename(columns={
        "user_display_name": "Nome",
        "comment": "Mensagem",
        "timestamp": "Tempo"
    })

    df = df[["Nome", "Mensagem", "Tempo"]]

    df["Mensagem"] = (
        df["Mensagem"]
        .fillna("")
        .str.replace(r"[\r\n\t]+", " ", regex=True)
        .str.replace(r"\s+", " ", regex=True)
        .str.strip()
    )

    df = df.drop_duplicates()

    base = json_file.with_suffix("")

    csv = Path(str(base) + ".csv")
    xlsx = Path(str(base) + ".xlsx")

    df.to_csv(csv, sep=";", index=False, encoding="utf-8-sig")
    df.to_excel(xlsx, index=False)

    print(f"  ✓ {csv.name}")
    print(f"  ✓ {xlsx.name}")


def baixar(url):
    antes = set(Path(".").glob("youtube_chat_*.json"))

    print(f"\nBaixando: {url}")

    subprocess.run(
        ["yt-chat-downloader", url],
        check=True
    )

    depois = set(Path(".").glob("youtube_chat_*.json"))

    novos = sorted(depois - antes, key=lambda p: p.stat().st_mtime)

    if not novos:
        raise RuntimeError("Nenhum JSON foi criado.")

    return novos[-1]


def limpar_nomes_lixo():
    """Corrige arquivos quebrados tipo '.json .csv'."""
    for f in Path(".").iterdir():
        if " " in f.suffix:
            novo = Path(str(f).replace(" ", ""))
            f.rename(novo)


def main():

    if len(sys.argv) < 2:
        print("Uso:")
        print("python3 script.py URL1 [URL2 ...]")
        return

    for url in sys.argv[1:]:
        try:
            json_file = baixar(url)

            limpar_nomes_lixo()

            converter(json_file)

        except Exception as e:
            print(f"Erro: {e}")


if __name__ == "__main__":
    main()
