#!/usr/bin/env bash
set -e

ARCH=$(uname -m)
OS=$(uname -s)

echo "Detected ARCH=${ARCH}, OS=${OS}"

DETECTED_HOST=""

case "${OS}" in
  Linux)
    case "${ARCH}" in
      x86_64)
        DETECTED_HOST="x86_64-pc-linux-gnu"
        ;;
      i386|i686)
        DETECTED_HOST="i686-pc-linux-gnu"
        ;;
      armv7l|armv6l)
        DETECTED_HOST="arm-linux-gnueabihf"
        ;;
      aarch64)
        DETECTED_HOST="aarch64-linux-gnu"
        ;;
      riscv64)
        DETECTED_HOST="riscv64-linux-gnu"
        ;;
      riscv32)
        DETECTED_HOST="riscv32-linux-gnu"
        ;;
      *)
        echo "Unsupported architecture on Linux: ${ARCH}"
        exit 1
        ;;
    esac
    ;;
  Darwin)
    DETECTED_HOST="x86_64-apple-darwin14"
    ;;
  MINGW*|MSYS*|CYGWIN*)
    DETECTED_HOST="x86_64-w64-mingw32"
    ;;
  *)
    echo "Unsupported operating system: ${OS}"
    exit 1
    ;;
esac

if [ -z "${DETECTED_HOST}" ]; then
  echo "Could not detect a valid HOST."
  exit 1
fi

echo "Using HOST=${DETECTED_HOST}"
export DETECTED_HOST

make -C depends NO_QT=1 HOST="$DETECTED_HOST"

