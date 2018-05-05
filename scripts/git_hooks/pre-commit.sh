#!/bin/bash --login

# What is this?
# =============
# This is a modular pre-commit script that will execute the scripts found in the pre-commit.d directory. It is
# inspired by this project: https://github.com/datagrok/modular-git-hooks

set -e

# Using Git to get the top-level because this file is symlinked making
# $0 => .git/hooks/pre-commit, which isn't very helpful.
pre_commit_hooks="$(git rev-parse --show-toplevel)/scripts/git_hooks/pre-commit.d"

for hook_script in $(find $pre_commit_hooks -type f); do
  if [[ -x $hook_script ]] && (! $hook_script $@); then
    echo 1>&2 "TIP: In an emergency you can use \`git commit --no-verify\` to skip commit hooks."
    exit 1
  fi
done
