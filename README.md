# LastPatch: LastPass Extension Patcher

LastPatch downloads the latest version of the LastPass extension for Firefox and applies some patches to fix minor UI issues.

## Installation

There's nothing special to install for LastPatch. If you have `wget`, `zip` and `unzip` then clone the repo and you're good to go.

## Usage

1. Run `patch.sh` in a terminal
   > This downloads the latest extension before extracting, patching and rebuilding it.  
   > The patched but unsigned addon will be saved to `out/lastpass_patched-${version}-unsigned.xpi`.
2. Upload the patched, unsigned .xpi file to [AMO Developer Hub] and wait for it to be validated automatically
   > Set the addon as self-distributed so it's hidden from AMO and bypasses the manual validation process.
3. Click the button to sign the add-on
4. Download the signed xpi and drag it into about:addons

### Version Suffix

If you make any changes or need to make multiple builds for any reason, AMO may reject your xpi file if the version matches
one you've already uploaded previously to AMO. You can get around this by customising the version:
```sh
$ VERSION_SUFFIX="01" /path/to/patch.sh
```

This will append "01" to the current version, resulting in e.g. `4.32.0.201`.

## Patches

Currently the following elements are patched:

#### Manifest
* Includes "Patched" in the add-on name to easily identify it in Add-ons Manager
* Sets the version (if needed)
* Generates an ID based on your hostname
* Bumps `strict_min_version` to 57 to clear a ton of AMO warnings

#### In-field Generate Password Dialog
* Password length label: increased contrast
* Password length input: colour set to black
* Generated password: colour set to black

[AMO Developer Hub]: https://addons.mozilla.org/developers
