#!/bin/bash --login

# Verify rubocop is installed for the current project
rubocop -v >/dev/null 2>&1 || { echo -e >&2 "[RuboCop]${RED}[Fatal]${NC}: Ensure rubocop is installed"; exit 1; }

# Select only staged Ruby files, this may be expanded to other file types if necessary.
FILES="$(git diff --cached --diff-filter=ACMR --name-only $against \*.{erb,rake,rb} | tr '\n' ' ')"

CONFIG="$REPO/.rubocop.yml"

echo -e "[RuboCop]${GREEN}[Info]${NC}: Checking Style"

# Check for ruby style errors
if [[ -n $FILES ]]; then
  if [[ ! -f $CONFIG ]]; then
    echo -e "[RuboCop]${YELLOW}[Warning]${NC}: No .rubocop.yml config file"
  fi

  # Run rubocop on the staged files
  rubocop -R --force-exclusion db/schema.rb "${FILES}"

  if [[ $? -ne 0 ]]; then
    echo -e "[RuboCop]${RED}[Error]${NC}: Fix the issues and commit again"
    exit 1
  fi
fi
