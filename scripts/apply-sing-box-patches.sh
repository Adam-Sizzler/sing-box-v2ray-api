#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="${1:-sing-box}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
PATCH_DIR="${PATCH_DIR:-${REPO_DIR}/patches/sing-box}"
PATCH_STRIP="${PATCH_STRIP:-2}"

if [ ! -d "${SOURCE_DIR}" ]; then
  echo "sing-box source directory not found: ${SOURCE_DIR}" >&2
  exit 1
fi

if [ ! -d "${PATCH_DIR}" ]; then
  echo "patch directory not found: ${PATCH_DIR}" >&2
  exit 1
fi

shopt -s nullglob
PATCHES=("${PATCH_DIR}"/*.patch)
shopt -u nullglob

if [ "${#PATCHES[@]}" -eq 0 ]; then
  echo "No sing-box patches found in ${PATCH_DIR}; nothing to apply."
  exit 0
fi

for PATCH_FILE in "${PATCHES[@]}"; do
  echo "==> Checking patch: ${PATCH_FILE}"
  patch --dry-run -d "${SOURCE_DIR}" -p"${PATCH_STRIP}" < "${PATCH_FILE}"

  echo "==> Applying patch: ${PATCH_FILE}"
  patch -d "${SOURCE_DIR}" -p"${PATCH_STRIP}" < "${PATCH_FILE}"
done

echo "All sing-box patches applied successfully."
