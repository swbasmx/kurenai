#!/usr/bin/env bash
# Construye el source package para una PPA de Launchpad y, con --send,
# lo firma y lo sube.
#
#   packaging/ppa.sh jammy            # solo construye
#   packaging/ppa.sh jammy --send     # firma y sube a ppa:usuario/kurenai
#
# Variables:
#   PPA       destino (por defecto, ppa:swbasmx/kurenai)
#   DEBFULLNAME / DEBEMAIL   nombre y correo del Maintainer
#   GPGKEY    ID de la clave de firma (por defecto, git user.signingkey)
set -euo pipefail

ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
SERIES=${1:-jammy}
PPA=${PPA:-ppa:swbasmx/kurenai}
SEND=0
[[ ${2:-} == --send ]] && SEND=1

name=${DEBFULLNAME:-$(git -C "$ROOT" config user.name || true)}
email=${DEBEMAIL:-$(git -C "$ROOT" config user.email || true)}
keyid=${GPGKEY:-$(git -C "$ROOT" config user.signingkey || true)}

[[ -n $name && -n $email ]] || {
  printf 'define DEBFULLNAME y DEBEMAIL con tu nombre y correo reales\n' >&2
  exit 1
}

if ! [[ $email =~ @ ]]; then
  printf 'correo inválido: %s\n' "$email" >&2
  exit 1
fi

base=$(awk '/^kurenai \(/ {print $2; exit}' "$ROOT/debian/changelog")
upstream=${base%%-*}
version="${base%%~*}~${SERIES}1"

work=$(mktemp -d "${TMPDIR:-/tmp}/kurenai-ppa.XXXXXX")
trap 'rm -rf -- "$work"' EXIT

srcdir=$work/kurenai-$upstream
mkdir -p "$srcdir"
git -C "$ROOT" archive --format=tar HEAD | tar -x -C "$srcdir"

{
  printf 'kurenai (%s) %s; urgency=medium\n\n' "$version" "$SERIES"
  printf '  * Build for Ubuntu %s.\n\n' "$SERIES"
  printf ' -- %s <%s>  %s\n\n' "$name" "$email" "$(date -R)"
  cat "$ROOT/debian/changelog"
} > "$srcdir/debian/changelog"

printf 'paquete:   kurenai %s (%s)\n' "$version" "$SERIES"
printf 'origen:    %s\n' "$srcdir"
printf 'destino:   %s\n' "$PPA"

(
  cd "$srcdir"
  dpkg-buildpackage -S -sa -us -uc
)

changes=$work/kurenai_${version}_source.changes
[[ -f $changes ]] || {
  printf 'no se generó %s\n' "$changes" >&2
  exit 1
}

if (( ! SEND )); then
  printf '\nlisto. para subirlo:\n'
  printf '  debsign -k %s %s\n' "${keyid:-<KEYID>}" "$changes"
  printf '  dput %s %s\n' "$PPA" "$changes"
  printf '\n(o ejecuta: packaging/ppa.sh %s --send)\n' "$SERIES"
  exit 0
fi

[[ -n $keyid ]] || {
  printf 'define GPGKEY con el ID de tu clave de firma\n' >&2
  exit 1
}

debsign -k "$keyid" "$changes"
dput "$PPA" "$changes"
printf '\nsubido. Launchpad tarda unos minutos en publicar la compilación.\n'
