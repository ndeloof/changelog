Generate changelog based on merged pull-requests

Usage:

`changelog.sh TAG..HEAD` will generate changelog for specified git range
if no parameter is set, defaults to {previous tag}..HEAD

- pull-requests MUST use labels `kind/bug` or `kind/feature` to be seleected for changelog
- pull-requests title is used as changelog entry. So should be adjusted before a PR is merged to reflect a end-user facing description
- require `GITHUB_TOKEN` set to a personal access token or you will get API rate limit errors
