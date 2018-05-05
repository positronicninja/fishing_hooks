#!/bin/bash --login

# Check if eslint is installed for the current project
bin/eslint -v >/dev/null 2>&1 || { echo >&2 "${red}[ESLint Style][Fatal]: Add eslint to your package.json"; exit 1; }

# Select only staged Javascript  files, this may be expanded to other file types if necessary.
FILES="$(git diff --cached --diff-filter=ACMR --name-only $against \*.{js,jsx} | tr '\n' ' ')"

CONFIG=".eslintrc.js"

echo "${green}[ESLint Style][Info]: Checking ESLint Style${NC}"

# Check for javascript style errors
if [[ -n $FILES ]]; then
  if [[ ! -f $CONFIG ]]; then
    echo "${yellow}[ESLint Style][Warning]: No $CONFIG config file.${NC}"
  fi

  # Run eslint on the staged files
  bin/eslint --max-warnings=0 ${FILES}

  if [[ $? -ne 0 ]]; then
    echo "${red}[ESLint Style][Error]: Fix the issues and commit again${NC}"
    exit 1
  fi
fi
