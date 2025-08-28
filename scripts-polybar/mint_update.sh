#!/bin/sh

APT_UPDATES=$(apt-get -s dist-upgrade | grep -c "^Inst")
FLATPAK_UPDATES=$(flatpak remote-ls --updates 2>/dev/null | wc -l)

TOTAL_UPDATES=$((APT_UPDATES + FLATPAK_UPDATES))

echo "$TOTAL_UPDATES"
