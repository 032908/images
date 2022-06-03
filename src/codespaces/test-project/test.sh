#!/bin/bash
cd $(dirname "$0")

source test-utils.sh codespace

# Run common tests
checkCommon

# Check default extensions
checkExtension "gitHub.vscode-pull-request-github"

# Check Oryx
check "oryx" oryx --version

# Check .NET
check "dotnet" dotnet --list-sdks
check "oryx-install-dotnet-3.1" oryx prep --skip-detection --platforms-and-versions dotnet=3.1
check "dotnet-3.1-installed" bash -c 'dotnet --info | grep -E "\s3\.1\.[0-9]*\s"'
check "dotnet-6-installed-by-oryx" dotnet --info | grep "/usr/local/dotnet/6\.0\.[0-9]*/sdk"

# Check Python
check "python" python --version
check "python3" python3 --version
check "pip" pip --version
check "pip3" pip3 --version
check "pipx" pipx --version
check "pylint" pylint --version
check "flake8" flake8 --version
check "autopep8" autopep8 --version
check "yapf" yapf --version
check "mypy" mypy --version
check "pydocstyle" pydocstyle --version
check "bandit" bandit --version
check "virtualenv" virtualenv --version
echo $(echo "python versions" && cd /usr/local/python && ls -a)

# Check Python packages
check "numpy" python -c 'import numpy'
check "pandas" python -c 'import pandas'
check "scipy" python -c 'import scipy'
check "matplotlib" python -c 'import matplotlib'
check "seaborn" python -c 'import seaborn'
check "scikit-learn" python -c 'import sklearn'
check "tensorflow" python -c 'import tensorflow'
check "keras" python -c 'import keras'
check "torch" python -c 'import torch'
check "requests" python -c 'import requests'

# Check JupyterLab
check "jupyter-lab" jupyter-lab --version

# Check Java tools
check "java" java -version
check "sdkman" bash -c ". /usr/local/sdkman/bin/sdkman-init.sh && sdk version"
check "gradle" gradle --version
check "maven" mvn --version
echo $(echo "java versions" && cd /usr/local/sdkman/candidates/java && ls -a)

# Check Ruby tools
check "ruby" ruby --version
check "rvm" bash -c ". /usr/local/rvm/scripts/rvm && rvm --version"
check "rbenv" bash -c 'eval "$(rbenv init -)" && rbenv --version'
check "rake" gem list rake
echo $(echo "ruby versions" && cd /usr/local/rvm/rubies && ls -a)

# Check Jekyll dynamic install
mkdir jekyll-test
cd jekyll-test
touch _config.yml
check "oryx-build-jekyll" oryx build --apptype static-sites --manifest-dir /tmp
check "jekyll" gem list jekyll
cd ..
rm -rf jekyll-test

# Node.js
check "node" node --version
check "nvm" bash -c ". /usr/local/share/nvm/nvm.sh && nvm --version"
check "nvs" bash -c ". /home/codespace/.nvs/nvs.sh && nvs --version"
check "yarn" yarn --version
check "npm" npm --version
echo $(echo "node versions" && cd /usr/local/share/nvm/versions/node && ls -a)

# PHP
check "php" php --version
check "php composer" composer --version
check "pecl" pecl version
check "Xdebug" php --version | grep 'Xdebug'
echo $(echo "php versions" && cd /usr/local/php && ls -a)

# Hugo
check "hugo" hugo version

# Anaconda
check "Anaconda" conda --version

# Go
check "go" go version

# Check utilities
checkOSPackages "additional-os-packages" vim xtail software-properties-common
check "gh" gh --version
check "git-lfs" git-lfs --version
check "docker" docker --version
check "kubectl" kubectl version --client
check "helm" helm version

# Check expected shells
check "bash" bash --version
check "fish" fish --version
check "zsh" zsh --version

# Check that we can run a puppeteer node app.
yarn
check "run-puppeteer" node puppeteer.js

# Report result
reportResults
