#!/usr/bin/env bash

pkgname=lastpass
pkgver=4.29.0.4
tmpdir="./extracted/"

main() {
    cd "${0%/*}" || exit 1

    prune
    fetch

    echo "Done!"
}

prune() {
    echo "Pruning old extracted files... "
    rm -rf ${tmpdir} && mkdir ${tmpdir}
}

fetch() {
    local filename="in/${pkgname}-${pkgver}.xpi"

    echo "Fetching LastPass..."
    wget --show-progress -qO "${filename}" "https://addons.mozilla.org/firefox/downloads/file/3019318/" \
        && echo "Extracting contents of LastPass XPI file..." && unzip -qqo "${filename}" -d "${tmpdir}"
}

main
