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

main
