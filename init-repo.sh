#!/usr/bin/env bash

set -e    # exit script when error happens
# set -u    # report error if visiting undeclared variable

if [[ -z "$(command -v npm)" ]]; then
    echo "node is not installed. Exit."
    exit 1
fi

if [[ -n $(git rev-parse HEAD 2>&1 >/dev/null) ]]; then
    echo "not a git repository! Exit."
    exit 1
fi
cd "$(git rev-parse --show-toplevel)"

# install husky
npm install --save-dev husky
npx husky install
npm set-script prepare "husky install"  # install husky automatically after npm install

# install commitlint to check commit msg format
npm install --save-dev @commitlint/config-conventional @commitlint/cli
cat <<EOF > commitlint.config.js
module.exports = {
    extends: ['@commitlint/config-conventional'],
    // overwrite default configuration
    // check https://github.com/conventional-changelog/commitlint/blob/master/docs/reference-rules.md for more
    rules: {
        // 'type-enum': [2, 'always', ['feat', 'fix']],
    }
};
EOF
npx husky add .husky/commit-msg 'npx --no-install commitlint --edit "$1"'

# install Prettier
npm install --save-dev --save-exact prettier
cat <<EOF > .prettierrc.json
{
    "printWidth": 120,
    "tabWidth": 4,
    "tabs": false,
    "singleQuote": true,
    "semicolon": true,
    "quoteProps": "preserve",
    "bracketSpacing": false,
    "bracketSameLine": true,
    "overrides": [
        {
            "files": ["*.yaml", "*.yml"],
            "options": {
                "semi": true
            }
        }
    ]
}
EOF
# install lint-staged
npm install --save-dev husky lint-staged
npx husky add .husky/pre-commit "npx --no-install lint-staged"
cat <<EOF > .lintstagedrc.json
{
    "**/*": "prettier --write --ignore-unknown"
}
EOF

# install CHANGELOG generator

cat <<EOF > README.md.example
[![code style: prettier](https://img.shields.io/badge/code_style-prettier-ff69b4.svg?style=flat-square)](https://github.com/prettier/prettier)

## Contributing

## Copyright
<MY_PROJECT> is licensed under the GNU General Public License, v3. A copy of this license is included in the file [LICENSE](LICENSE).

EOF

# github actions
cat <<EOF > .github/dependabot.yaml.example
version: 2
updates:
  # enable version updates for npm
  - package-ecosystem: 'npm'
    # look for package.json and package-lock.json in the root directory
    directory: '/'
    # check the npm registry for updates every day (weekdays)
    schedule:
      interval: 'weekly'
EOF
cat <<EOF > .github/workflows/ci.yaml.example
# lint and test at push and pull_request
name: CI
on:
  push:
    branches:
      - '**'
  pull_request:
    branches:
      - '**'
jobs:
  linter:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-node@v2
        with:
          node-version: 14
      - run: npm ci
      - name: Lint
        run: npm run lint
  tests:
    needs: linter
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-node@v2
        with:
        node-version: 14
      - run: npm ci
      - name: Unit test
        run: npm run test
EOF
cat <<EOF >. github/workflows/cd.yaml.example
# release at push and pull_request on main
name: CD
on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main
  jobs:
    release:
      runs-on: ubuntu-latest
      steps:
        - uses: actions/checkout@v2
        - uses: actions/setup-node@v2
          with:
            node-version: 14
        - run: npm ci --ignore-scripts
        - name: release
          run: npx semantic-release
          env:
            GH_TOKEN: \${{ secrets.GH_TOKEN }}
            NPM_TOKEN: \${{ secrets.NPM_TOKEN }}
EOF
