#!/usr/bin/env bash
# Assemble the GitHub Pages site with both release channels.
#
# A Pages deploy replaces the whole site, so every deploy (stable tag, pre-release
# tag, docs-only push) runs this script and publishes both channels:
#   manifest.json + firmware/      newest stable release (what buyers flash)
#   rc/manifest.json + rc/firmware/ newest pre-release, only when it is newer than
#                                  the newest stable release; otherwise rc/ is absent
#                                  and rc.html shows that there is no test version.
#
# Firmware for releases that already exist is downloaded with `gh release download`.
# A release that is being built right now (no GitHub Release yet) is passed in:
#   LOCAL_TAG=vX.Y.Z[-rc.N] LOCAL_BIN=path/to/firmware.factory.bin
#
# Env: DEVICE (required), GH_TOKEN (required in CI), GH_REPO (optional),
#      DOCS_DIR (default docs), SITE_DIR (default site), LOCAL_TAG, LOCAL_BIN.
set -euo pipefail

: "${DEVICE:?DEVICE must be set}"
DOCS_DIR=${DOCS_DIR:-docs}
SITE_DIR=${SITE_DIR:-site}
LOCAL_TAG=${LOCAL_TAG:-}
LOCAL_BIN=${LOCAL_BIN:-}

TAG_RE='^v[0-9]+\.[0-9]+\.[0-9]+(-[0-9A-Za-z.]+)?$'

if [[ -n "$LOCAL_TAG" ]]; then
  [[ "$LOCAL_TAG" =~ $TAG_RE ]] || { echo "::error::LOCAL_TAG $LOCAL_TAG is not vX.Y.Z[-pre]"; exit 1; }
  [[ -f "$LOCAL_BIN" ]] || { echo "::error::LOCAL_BIN '$LOCAL_BIN' not found"; exit 1; }
fi

# Newest version from stdin. Plain `sort -V` puts 1.0.1-rc.1 after 1.0.1, so the
# pre-release dash becomes a tilde first: in version sort ~ sorts before anything,
# which gives 1.0.1~rc.1 < 1.0.1 < 1.0.2~rc.1.
newest() {
  sed 's/-/~/' | sort -V | tail -n1 | sed 's/~/-/'
}

# Stable: tag without a dash that GitHub does not flag as pre-release.
# Pre-release: tag with a dash. Drafts are ignored.
releases=$(gh release list --exclude-drafts --limit 200 \
  --json tagName,isPrerelease --jq '.[] | "\(.tagName) \(.isPrerelease)"')

stable_tags=""
pre_tags=""
while read -r tag pre; do
  [[ -n "$tag" && "$tag" =~ $TAG_RE ]] || continue
  if [[ "$tag" == *-* ]]; then
    pre_tags+="${tag#v}"$'\n'
  elif [[ "$pre" == "false" ]]; then
    stable_tags+="${tag#v}"$'\n'
  fi
done <<< "$releases"

if [[ -n "$LOCAL_TAG" ]]; then
  if [[ "$LOCAL_TAG" == *-* ]]; then
    pre_tags+="${LOCAL_TAG#v}"$'\n'
  else
    stable_tags+="${LOCAL_TAG#v}"$'\n'
  fi
fi

stable=$(printf '%s' "$stable_tags" | grep . | newest || true)
pre=$(printf '%s' "$pre_tags" | grep . | newest || true)

[[ -n "$stable" ]] || { echo "::error::no stable release found, the root flash page needs one"; exit 1; }

rc=""
if [[ -n "$pre" && "$(printf '%s\n%s\n' "$stable" "$pre" | newest)" == "$pre" ]]; then
  rc=$pre
fi

echo "stable channel: v$stable"
if [[ -n "$rc" ]]; then
  echo "pre-release channel: v$rc"
else
  echo "pre-release channel: none (newest pre-release: ${pre:-none})"
fi

# Put the bin for version $1 into directory $2, from LOCAL_BIN or the GitHub Release.
fetch_bin() {
  local ver=$1 dir=$2 name="${DEVICE}-$1.factory.bin"
  mkdir -p "$dir"
  if [[ "v$ver" == "$LOCAL_TAG" ]]; then
    cp "$LOCAL_BIN" "$dir/$name"
  else
    gh release download "v$ver" --pattern "$name" --dir "$dir" --clobber
  fi
  [[ -f "$dir/$name" ]] || { echo "::error::release v$ver has no $name asset"; exit 1; }
}

# Write an esp-web-tools manifest for version $1 into directory $2.
# The part path is relative to the manifest, so the bin sits in $2/firmware/.
write_manifest() {
  local ver=$1 dir=$2
  cat > "$dir/manifest.json" <<JSON
{
  "name": "Zehnder ComfoAir RF controller",
  "version": "${ver}",
  "home_assistant_domain": "esphome",
  "new_install_prompt_erase": true,
  "new_install_improv_wait_time": 20,
  "builds": [
    {
      "chipFamily": "ESP32",
      "parts": [ { "path": "firmware/${DEVICE}-${ver}.factory.bin", "offset": 0 } ]
    }
  ]
}
JSON
}

rm -rf "$SITE_DIR"
mkdir -p "$SITE_DIR"
cp -r "$DOCS_DIR"/. "$SITE_DIR"/

fetch_bin "$stable" "$SITE_DIR/firmware"
write_manifest "$stable" "$SITE_DIR"

if [[ -n "$rc" ]]; then
  fetch_bin "$rc" "$SITE_DIR/rc/firmware"
  write_manifest "$rc" "$SITE_DIR/rc"
fi
