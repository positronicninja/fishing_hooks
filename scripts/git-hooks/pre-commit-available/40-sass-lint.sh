#!/bin/bash --login

# Check if sass-lint is installed for the current project
sass-lint --version >/dev/null 2>&1 || { echo -e >&2 "[SASS Lint]${RED}[Fatal]${NC}: Ensure sass-lint is installed"; exit 1; }

# Select only staged CSS files, this may be expanded to other file types if necessary.
FILES="$(git diff --cached --diff-filter=ACMR --name-only $against \*.{css,sass,scss} | tr '\n' ' ')"

CONFIG="$REPO/.sasslintrc"

echo -e "[SASS Lint]${GREEN}[Info]${NC}: Checking Style"

# Check for css style errors
if [[ -n $FILES ]]; then
  if [[ ! -f $CONFIG ]]; then
    echo -e "[SASS Lint]${YELLOW}[Error]${NC}: No local .sasslintrc config file"
    exit 1
  fi

  # Run sass-lint on the staged files
  sass-lint --verbose --config "${CONFIG}" "${FILES}"

  if [[ $? -ne 0 ]]; then
    echo -e "[SASS Lint]${RED}[Error]${NC}: Fix the issues and commit again"
    exit 1
  fi
fi
