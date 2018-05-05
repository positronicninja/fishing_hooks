#!/bin/bash --login

# Verify rubocop is installed for the current project
bin/rubocop -v >/dev/null 2>&1 || { echo >&2 "${red}[Ruby Style][Fatal]: Add rubocop to your Gemfile"; exit 1; }

# Select only staged Ruby files, this may be expanded to other file types if necessary.
FILES="$(git diff --cached --diff-filter=ACMR --name-only $against \*.{erb,rake,rb} | tr '\n' ' ')"

CONFIG=".rubocop.yml"

echo "${green}[Ruby Style][Info]: Checking Ruby Style${NC}"

# Check for ruby style errors
if [[ -n $FILES ]]; then
  if [[ ! -f $CONFIG ]]; then
    echo "${yellow}[Ruby Style][Warning]: No $CONFIG config file.${NC}"
  fi

  # Run rubocop on the staged files
  echo $TOP_LEVEL/bin/bundle

  bin/rubocop -R --force-exclusion db/schema.rb ${FILES}

  if [[ $? -ne 0 ]]; then
    echo "${red}[Ruby Style][Error]: Fix the issues and commit again${NC}"
    exit 1
  fi
fi
