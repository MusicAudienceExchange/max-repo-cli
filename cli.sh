#!/bin/sh

NPMRC=".npmrc"

gh_token() {
  if [ -e "$NPMRC" ]; then
    tok=$(grep -Eo 'ghp_.*$' "$NPMRC")
    echo "$tok"
  fi
}

run() {
  tok=$(gh_token)

  if [ ! -z "${npm_package_config_max_common}" ]; then
    url="https://${tok:+$tok@}github.com/MusicAudienceExchange/set-common.git"
    target_branch=$npm_package_config_max_common
    if [ ! -d common ]; then
      git clone -b "$target_branch" "$url" common
    else
      current_branch=$(cd common && git branch --show-current)
      if [ "$current_branch" != "$target_branch" ]; then
        echo "WARNING: common is currently on '${current_branch}' which differs from the desired '${target_branch}'."
        echo "         Either update package.json or switch the branch back to '${target_branch}'."
      fi
    fi
  fi
}

run
