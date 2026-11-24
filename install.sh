#!/usr/bin/env bash
# Tokyo Night for Zen Browser — installer
# Usage:  bash install.sh          (auto-detects the profile)
#         ZEN_PROFILE=/path/to/profile bash install.sh
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Folders that can hold Zen's profiles.ini (native, then Flatpak)
ROOTS=(
  "$HOME/.config/zen"
  "$HOME/.zen"
  "$HOME/.var/app/app.zen_browser.zen/.zen"
  "$HOME/.var/app/app.zen_browser.zen/config/zen"
)

# Prints the profile path that Zen actually uses for the given root.
find_profile() {
  local root="$1" ini="$1/profiles.ini" rel
  [[ -f "$ini" ]] || return 1

  # 1) [Install...] Default=<path> is the profile the installed Zen launches
  rel="$(awk -F= '/^\[Install/{f=1;next} /^\[/{f=0} f && $1=="Default"{print $2; exit}' "$ini")"

  # 2) fallback: the [Profile...] flagged Default=1
  if [[ -z "$rel" ]]; then
    rel="$(awk -F= '
      function flush() { if (d && p && !done) { print p; done=1 } }
      /^\[/ { flush(); p=""; d=0; next }
      $1=="Path" { p=$2 }
      $1=="Default" && $2=="1" { d=1 }
      END { flush() }' "$ini")"
  fi

  [[ -n "$rel" ]] || return 1
  if [[ "$rel" = /* ]]; then printf '%s\n' "$rel"; else printf '%s\n' "$root/$rel"; fi
}

PROFILE="${ZEN_PROFILE:-}"
if [[ -z "$PROFILE" ]]; then
  for r in "${ROOTS[@]}"; do
    if p="$(find_profile "$r")" && [[ -d "$p" ]]; then PROFILE="$p"; break; fi
  done
fi

if [[ -z "$PROFILE" || ! -d "$PROFILE" ]]; then
  echo "Zen profili bulunamadi. Zen'de about:profiles > Root Directory yolunu kopyalayip su sekilde calistir:" >&2
  echo "  ZEN_PROFILE=\"/profil/yolu\" bash install.sh" >&2
  exit 1
fi

echo "Profil: $PROFILE"
mkdir -p "$PROFILE/chrome"

for f in userChrome.css userContent.css; do
  if [[ -f "$PROFILE/chrome/$f" ]]; then
    cp "$PROFILE/chrome/$f" "$PROFILE/chrome/$f.bak-$(date +%Y%m%d-%H%M%S)"
    echo "Yedeklendi: chrome/$f"
  fi
  cp "$SRC/$f" "$PROFILE/chrome/$f"
  echo "Kopyalandi: chrome/$f"
done

# userChrome.css'in yuklenmesi icin gerekli tercih
PREF='user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);'
if ! grep -qF "$PREF" "$PROFILE/user.js" 2>/dev/null; then
  printf '%s\n' "$PREF" >> "$PROFILE/user.js"
  echo "user.js: legacyUserProfileCustomizations.stylesheets = true"
fi

if pgrep -x zen-bin >/dev/null 2>&1 || pgrep -x zen >/dev/null 2>&1; then
  echo "Not: Zen su an acik. Temanin gorunmesi icin tamamen kapatip yeniden ac."
fi
echo "Tamam."
