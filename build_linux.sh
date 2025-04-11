#!/usr/bin/env sh
set -e
cd "$(dirname "$0")"

if [ "$(uname)" = "Darwin" ]; then
	export GOOS="${GOOS:-linux}"
fi

export GOFLAGS="${GOFLAGS} -mod=vendor"
TAG=$(git describe --tags --dirty)
BUILDFLAGS="github.com/containernetworking/plugins/pkg/utils/buildversion.BuildVersion=${TAG}"

mkdir -p "${PWD}/bin"

echo "Building plugins ${GOOS}"
PLUGINS="plugins/meta/* plugins/main/* plugins/ipam/*"
for d in $PLUGINS; do
	if [ -d "$d" ]; then
		plugin="$(basename "$d")"
		if [ "${plugin}" != "windows" ]; then
			echo "  $plugin"
			${GO:-go} build -o "${PWD}/bin/$plugin" -ldflags "-X ${BUILDFLAGS}" "$@" ./"$d"
		fi
	fi
done
