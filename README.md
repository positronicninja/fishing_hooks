# Wireless Fishing Hooks

---

## Zero Dependency Pre-Commit Hook Modules

### What is this?

This is a modular pre-commit script that will execute the hooks linked in the pre-commit-enabled directory. It is inspired by this project: https://github.com/datagrok/modular-git-hooks and a gist by Tim Uruski: https://gist.github.com/timuruski/ed20354fae75b3abb0d1bf6b1353c842

Code for the while loop is based on samples from: [shellcheck](https://github.com/koalaman/shellcheck/wiki/SC2044)

This is meant to function as a template to use the tools already employed in your project. Copy the scripts folder into you project and modify as necessary.

### Setup

You can setup the style tools to run automatically before each commit:

    scripts/git-hooks/install

Or manually on staged files:

    scripts/git-hooks/pre-commit.sh

Because these Hooks use symbolic links you can add your own or disable specific ones:

    ln -s somewhere/YOUR_HOOK scripts/git-hooks/pre-commit-enabled/YOUR_HOOK.sh

    rm scripts/git-hooks/pre-commit-enabled/20_rubocop.sh
