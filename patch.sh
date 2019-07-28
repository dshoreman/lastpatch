#!/usr/bin/env bash

set -Eeo pipefail

trap 'echo -e "\nAborted due to error" && exit 1' ERR
trap 'echo -e "\nAborted by user" && exit 1' SIGINT

pkgname=lastpass
pkgver=4.29.0.4
tmpdir="./extracted/"

main() {
    cd "${0%/*}" || exit 1

    prune
    fetch
    patch
    rebuild

    echo "Done!"
}

prune() {
    echo "Pruning old extracted files... "
    echo "Removed ~$(rm -rvf ${tmpdir} | wc -l) files and directories" && mkdir ${tmpdir}
}

fetch() {
    local filename="in/${pkgname}-${pkgver}.xpi"

    echo "Fetching LastPass..."
    wget --show-progress -qO "${filename}" "https://addons.mozilla.org/firefox/downloads/file/3019318/" \
        && echo "Extracting contents of LastPass XPI file..." && unzip -qqo "${filename}" -d "${tmpdir}"
}

patch() {
    echo
    echo "LET THE PATCHING BEGIN!"
    echo

    echo "Tweaking the name so it can easily be identified..."
    sed -i -E "s/^(\t\"name\":) \"(.*)(\",?)$/\1 \"\2 (Patched)\",/" extracted/manifest.json
    sed -i -E "s/^(\t\"short_name\":) \"(.*): .*(\",?)$/\1 \"\2 (Patched)\3/" extracted/manifest.json

    if [ -z "${VERSION_SUFFIX}" ]; then
        echo "Skipping version patch, no VERSION_SUFFIX given"
    else
        echo "Patching version to append '${VERSION_SUFFIX}'..."
        sed -i -E "s/^(\t\"version\": )(\".*)(\",?)$/\1\2${VERSION_SUFFIX}\3/" extracted/manifest.json
    fi

    echo "Setting a unique Extension ID for AMO based on your hostname..."
    sed -i -E "s/^(\t{3}\"id\": )\".*(\",?)$/\1\"${pkgname}@$(hostname)\2/" extracted/manifest.json

    echo "Setting min Firefox version to clean majority of AMO warnings..."
    sed -i -E "s/^(\t{3}\"strict_min_version\":) \".*(\",?)$/\1\"57.0\2/" extracted/manifest.json

    echo "Patching complete"
}

rebuild() {
    echo "Cloning existing XPI..."
    cp "in/${pkgname}-${pkgver}.xpi" "out/lastpass_custom-${pkgver}${VERSION_SUFFIX}.xpi"

    echo "Updating archive..."
    cd ./extracted/
    zip -qur "../out/lastpass_custom-${pkgver}.xpi" ./*

    cd ..
}

main
