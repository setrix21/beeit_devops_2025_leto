echo "Použivaný shell:$SHELL"
echo "Aktuální uživatel: $(whoami)"
echo "Linux verze:"
cat /etc/os-release

# dalsicommit
CILOVA_SLOZKA="adresar/podadresar/posledniadresar/"
mkdir -p "$CILOVA_SLOZKA"

echo "AHoj ze sveta Linux" > "$CILOVA_SLOZKA/soubor.txt"

ln -sf "$PWD/$CILOVA_SLOZKA/soubor.txt" /tmp/softLink

cp "$CILOVA_SLOZKA/soubor.txt" /tmp/

echo "UID: $(id -u)"
echo "GID: $(id -g)"

chmod o=r "$CILOVA_SLOZKA/soubor.txt"

echo "chmod nefunguje na symlink"

