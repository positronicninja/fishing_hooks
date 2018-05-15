#!/bin/bash --login

# Check if prettier is installed for the current project
prettier -v >/dev/null 2>&1 || { echo -e "[Prettier]${RED}[Fatal]${NC}: Ensure prettier is installed"; exit 1; }

# Select only staged Javascript  files, this may be expanded to other file types if necessary.
FILES="$(git diff --cached --diff-filter=ACMR --name-only $against \*.{js,jsx} | tr '\n' ' ')"

CONFIG="$REPO/.prettierrc"

echo -e "[Prettier]${GREEN}[Info]${NC}: Checking Style"

# Check for javascript style errors
if [[ -n $FILES ]]; then
  if [[ ! -f $CONFIG ]]; then
    echo -e "[Prettier]${YELLOW}[Warning]${NC}: No .prettierrc config file"
  fi

  # Run prettier on the staged files
  PRETTIER="$(prettier --list-different --config "$CONFIG" "${FILES}")"
  CLEAN_EXIT="$(echo -n "$PRETTIER" | head -c1 | wc -c)"

  if [[ $CLEAN_EXIT -ne 0 ]]; then
    echo -e "[Prettier]${RED}[Error]${NC}: Make these files pretty and commit again\\n"
    echo -e "$PRETTIER\\n"
    exit 1
  fi
fi
