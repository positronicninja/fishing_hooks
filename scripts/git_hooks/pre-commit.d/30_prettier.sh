#!/bin/bash --login

# Check if prettier is installed for the current project
prettier -v >/dev/null 2>&1 || { echo "${red}[Prettier Style][Fatal]: Add prettier to your package.json"; exit 1; }

# Select only staged Javascript  files, this may be expanded to other file types if necessary.
FILES="$(git diff --cached --diff-filter=ACMR --name-only $against \*.{js,jsx} | tr '\n' ' ')"

CONFIG=".prettierrc"

echo "${green}[Prettier Style][Info]: Checking Prettier Style${NC}"

# Check for javascript style errors
if [[ -n $FILES ]]; then
  if [[ ! -f $CONFIG ]]; then
    echo "${yellow}[Prettier Style][Warning]: No $CONFIG config file.${NC}"
  fi

  # Run prettier on the staged files
  PRETTIER="$(prettier --list-different --config $CONFIG ${FILES})"
  CLEAN_EXIT="$(cat $PRETTIER | head -c1 | wc -c)"

  if [[ $CLEAN_EXIT -ne 0 ]]; then
    echo $PRETTIER
    echo "${red}[Prettier Style][Error]: Make these files pretty and commit again${NC}"
    exit 1
  fi
fi
