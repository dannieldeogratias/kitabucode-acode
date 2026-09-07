#!/usr/bin/env bash
# Build-time downloads only. Docker/QEMU prepares native runtime trees for each ABI.
set -euo pipefail
cd "$(dirname "$0")/.."
for spec in x64:amd64 arm64:arm64; do
  arch=${spec%%:*}
  platform=${spec#*:}
  image="kitabucode-runtime:$arch"
  rootfs="src/plugins/proot/assets/alpine_assets/$arch/alpine.rootfs"
  docker import --platform "linux/$platform" "$rootfs" "$image" >/dev/null
  container=$(docker create --platform "linux/$platform" "$image" /bin/sh -ec '
    apk update
    apk upgrade
    apk add bash command-not-found tzdata wget python3 py3-pip py3-lsp-server py3-pyflakes py3-pycodestyle py3-mccabe nodejs npm git build-base openjdk21-jdk
    mkdir -p /usr/share/kitabucode
    apk info -vv > /usr/share/kitabucode/packages.txt
    cp /lib/apk/db/installed /usr/share/kitabucode/package-metadata.txt
    printf "%s\n" "Alpine package sources: https://gitlab.alpinelinux.org/alpine/aports/-/tree/3.21-stable" > /usr/share/kitabucode/SOURCES.txt
    python3 -c "print(123)"
    node -e "console.log(123)"
    pylsp --version
    cc --version
    javac -version
    rm -f /var/cache/apk/*
  ')
  # Keep any original rootfs intact on failure.
  trap 'docker rm -f "$container" >/dev/null 2>&1 || true' EXIT
  docker start -a "$container"
  test "$(docker inspect -f '{{.State.ExitCode}}' "$container")" = 0
  docker export "$container" | gzip -n > "$rootfs.prepared"
  mv "$rootfs.prepared" "$rootfs"
  docker rm "$container" >/dev/null
  trap - EXIT
  echo "Prepared $arch: $(du -h "$rootfs" | cut -f1)"
done

