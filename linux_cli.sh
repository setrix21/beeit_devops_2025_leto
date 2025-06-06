#!/bin/bash

LOG="/dev/stdout"

echo "Používaný shell: $SHELL"
echo "Aktuální uživatel: $(whoami)"
echo "Linux verze:"
cat /etc/os-release

CILOVA_SLOZKA="adresar/podadresar/posledniadresar/"
mkdir -p "$CILOVA_SLOZKA"

echo "Ahoj ze sveta Linux" > "$CILOVA_SLOZKA/soubor.txt"

ln -sf "$PWD/$CILOVA_SLOZKA/soubor.txt" /tmp/softLink

cp "$CILOVA_SLOZKA/soubor.txt" /tmp/
echo "UID: $(id -u)"
echo "GID: $(id -g)"

chmod o=r "$CILOVA_SLOZKA/soubor.txt"

echo "chmod na symlink mění cílový soubor, ne samotný odkaz"

print_help() {
  echo ""
  echo "Použití: $0 [volby]"
  echo "  -h                  Zobrazí nápovědu"
  echo "  -m <cesta>          Vytvoří zanořený adresář"
  echo "  -l <typ> <z> <cíl>  Vytvoří link (soft nebo hard)"
  echo "  -i                  Vypíše informace: UID, GID, hostname, datum"
  echo "  -u                  Vypíše seznam balíčků, které mají update"
  echo "  -U                  Provede update a upgrade systému"
  echo "  -o <soubor>         Přesměruje výstup do souboru"
}

while getopts ":hm:l:iUuo:" opt; do
  case $opt in
    h)
      print_help
      exit 0
      ;;
    m)
      echo "Vytvářím adresář: $OPTARG" | tee -a "$LOG"
      mkdir -p "$OPTARG" || { echo "Chyba: nelze vytvořit adresář" | tee -a "$LOG"; exit 1; }
      ;;
    l)
      typ=$OPTARG
      shift $((OPTIND))
      src=$1
      tgt=$2
      if [ -e "$tgt" ]; then
        echo "Chyba: link '$tgt' už existuje" | tee -a "$LOG"
        exit 2
      fi
      if [ "$typ" == "soft" ]; then
        ln -s "$src" "$tgt" && echo "Soft link vytvořen" | tee -a "$LOG"
      elif [ "$typ" == "hard" ]; then
        ln "$src" "$tgt" && echo "Hard link vytvořen" | tee -a "$LOG"
      else
        echo "Chyba: typ linku musí být 'soft' nebo 'hard'" | tee -a "$LOG"
        exit 3
      fi
      ;;
    i)
      echo "UID: $(id -u)" | tee -a "$LOG"
      echo "GID: $(id -g)" | tee -a "$LOG"
      echo "HOSTNAME: $(hostname)" | tee -a "$LOG"
      echo "DATUM: $(date)" | tee -a "$LOG"
      ;;
    u)
      echo "Vyhledávám aktualizace..." | tee -a "$LOG"
      sudo apt update -qq && apt list --upgradable | tee -a "$LOG"
      ;;
    U)
      echo "Provádím update a upgrade systému..." | tee -a "$LOG"
      sudo apt update && sudo apt upgrade -y | tee -a "$LOG"
      ;;
    o)
      LOG="$OPTARG"
      echo "Výstup bude logován do: $LOG"
      ;;
    \?)
      echo "Chyba: neplatný parametr -$OPTARG"
      print_help
      exit 4
      ;;
  esac
done

