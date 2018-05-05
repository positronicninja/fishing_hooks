#!/bin/bash --login

# Check if sass-lint is installed for the current project
sass-lint --version >/dev/null 2>&1 || { echo >&2 "${red}[SASS Lint Style][Fatal]: Add sass-lint to your package.json"; exit 1; }

# Select only staged CSS files, this may be expanded to other file types if necessary.
FILES="$(git diff --cached --diff-filter=ACMR --name-only $against \*.{css,sass,scss} | tr '\n' ' ')"

CONFIG=".sasslintrc"

echo "${green}[SASS Lint Style][Info]: Checking SASS Lint Style${NC}"

# Check for css style errors
if [[ -n $FILES ]]; then
  if [[ ! -f $CONFIG ]]; then
    echo "${yellow}[SASS Lint Style][Error]: No local $CONFIG config file.${NC}"
    exit 1
  fi

  # Run sass-lint on the staged files
  sass-lint --verbose --config ${CONFIG} ${FILES}

  if [[ $? -ne 0 ]]; then
    echo "${red}[SASS Lint Style][Error]: Fix the issues and commit again${NC}"
    exit 1
  fi
fi
