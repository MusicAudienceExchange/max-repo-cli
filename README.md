# max-repo-cli

This repository contains a script called from other MAX repos which pulls in shared code from `set-common` and `melodies-source`.

### Gotchas

If you are experiencing an authentication issue when trying to pull `set-common` or `melodies-source` into another MAX repo, ensure you have set the default protocal for github to `ssh` instead of the default `https` since we do not support `https` authentication for github.

`git config --global url."git@github.com:".insteadOf "https://github.com/"`

An example of the error you might see on `yarn` install:

```
remote: Invalid username or token. Password authentication is not supported for Git operations.
fatal: Authentication failed for 'https://github.com/MusicAudienceExchange/set-common.git/'
```
