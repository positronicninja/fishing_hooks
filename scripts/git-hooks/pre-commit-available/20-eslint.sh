#!/bin/bash --login

# Check if eslint is installed for the current project
eslint -v >/dev/null 2>&1 || { echo -e >&2 "[ESLint]${RED}[Fatal]${NC}: Ensure eslint is installed"; exit 1; }

# Select only staged Javascript files, this may be expanded to other file types if necessary.
FILES="$(git diff --cached --diff-filter=ACMR --name-only $against \*.{js,jsx} | tr '\n' ' ')"

CONFIG="$REPO/.eslintrc.js"

echo -e "[ESLint]${GREEN}[Info]${NC}: Checking Style"

# Check for javascript style errors
if [[ -n $FILES ]]; then
  if [[ ! -f $CONFIG ]]; then
    echo -e "[ESLint]${YELLOW}[Warning]${NC}: No .eslintrc.js config file"
  fi

  # Run eslint on the staged files
  eslint --max-warnings=0 "${FILES}"

  if [[ $? -ne 0 ]]; then
    echo -e "[ESLint]${RED}[Error]${NC}: Fix the issues and commit again"
    exit 1
  fi
fi
