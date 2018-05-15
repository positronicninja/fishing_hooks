#!/bin/bash --login

# What is this?
# =============
# This is a modular pre-commit script that will execute the hooks linked in the pre-commit-enabled directory. It is
# inspired by this project: https://github.com/datagrok/modular-git-hooks && https://gist.github.com/timuruski/ed20354fae75b3abb0d1bf6b1353c842
#
# Code for the while loop is based on samples from: https://github.com/koalaman/shellcheck/wiki/SC2044

set -e

NC="\\033[0m"
RED="\\033[0;31m"
GREEN="\\033[0;32m"
YELLOW="\\033[1;333m"
REPO="$(git rev-parse --show-toplevel)"

export NC RED GREEN YELLOW REPO

# Using Git to get the top-level because this file is symlinked making
# $0 => .git/hooks/pre-commit, which isn't very helpful.
ENABLED="$REPO/scripts/git-hooks/pre-commit-enabled"

while IFS= read -r -d '' script
do
  if [[ -x "$script" ]] && (! $script "$@"); then
    echo 1>&2 "TIP: In an emergency you can use \`git commit --no-verify\` to skip commit hooks."
    exit 1
  fi
done < <(find "$ENABLED" -type l -name '*.sh' -print0)
