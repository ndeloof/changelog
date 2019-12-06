#!/bin/bash

set -e

## Usage :
## changelog PREVIOUS_TAG..HEAD


RANGE=${1:-"$(git describe --tags  --abbrev=0)..HEAD"}
echo "Generate changelog for range ${RANGE}"
echo

# configure refs so we get pull-requests metadata
git config --add remote.origin.fetch +refs/pull/*/head:refs/remotes/origin/pull/*
git fetch origin


pullrequests() {
    for commit in $(git log ${RANGE} --format='format:%H'); do
        # Get the oldest remotes/origin/pull/* branch to include this commit, i.e. the one to introduce it 
        git branch -a --sort=committerdate  --contains $commit --list 'origin/pull/*' | head -1 | cut -d'/' -f4
    done
}

changes=$(pullrequests | uniq)

echo "pull requests merged within range:"
echo $changes

echo
echo '#Features'
for pr in $changes; do 
    curl -fs -u ndeloof:$GITHUB_TOKEN https://api.github.com/repos/docker/compose/pulls/${pr} | jq -r ' select( .labels[].name | contains("kind/feature") ) | "* "+.title'
done

echo '#Bugs'
for pr in $changes; do 
    curl -fs -u ndeloof:$GITHUB_TOKEN https://api.github.com/repos/docker/compose/pulls/${pr} | jq -r ' select( .labels[].name | contains("kind/bug") ) | "* "+.title'
done
