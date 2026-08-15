#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  tool/publish.sh [--dry-run]

Runs package checks, validates the pub.dev archive, then publishes.

Options:
  --dry-run, -n  Run checks and pub.dev validation without uploading.
  --help, -h     Show this help message.
USAGE
}

mode="publish"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --dry-run|-n)
      mode="dry-run"
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 64
      ;;
  esac
  shift
done

cd "$(dirname "${BASH_SOURCE[0]}")/.."

echo "==> Resolving dependencies"
flutter pub get

echo "==> Analyzing"
flutter analyze

test_count="0"
if [ -d test ]; then
  test_count="$(find test -type f -name '*_test.dart' | wc -l | tr -d ' ')"
fi

if [ "$test_count" != "0" ]; then
  echo "==> Running tests"
  flutter test
else
  echo "==> Skipping tests: no test/*_test.dart files found"
fi

echo "==> Validating package"
set +e
dry_run_output="$(dart pub publish --dry-run 2>&1)"
dry_run_status="$?"
set -e
printf '%s\n' "$dry_run_output"

if printf '%s\n' "$dry_run_output" |
  grep -Eq "Package validation found the following [0-9]+ errors|can't be published yet"; then
  exit "$dry_run_status"
fi

if [ "$dry_run_status" -ne 0 ] &&
  ! printf '%s\n' "$dry_run_output" | grep -Eq "Package has [0-9]+ warning"; then
  exit "$dry_run_status"
fi

if [ "$mode" = "dry-run" ]; then
  echo "==> Dry run complete"
  exit 0
fi

echo "==> Publishing"
dart pub publish
