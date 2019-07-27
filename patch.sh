#!/usr/bin/env bash

pkgname=lastpass
pkgver=4.29.0.4

main() {
    cd "${0%/*}" || exit 1

    fetch

    echo "Done!"
}

fetch() {
    local filename="in/${pkgname}-${pkgver}.xpi"

    echo "Fetching LastPass..."
    wget --show-progress -qO "${filename}" "https://addons.mozilla.org/firefox/downloads/file/3019318/"
}

main
