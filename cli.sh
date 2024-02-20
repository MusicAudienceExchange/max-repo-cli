#!/bin/sh

NPMRC=".npmrc"

gh_token() {
  if [ -e "$NPMRC" ]; then
    tok=$(grep -Eo 'ghp_.*$' "$NPMRC")
    echo "$tok"
  fi
}

checkout_repo() {
  tok=$(gh_token)

  repo="${1}"
  target_branch="${2}"
  dir_name="${3}"

  url="https://${tok:+$tok@}github.com/MusicAudienceExchange/${repo}.git"
  if [ ! -d ${dir_name} ]; then
    echo "Checking out ${dir_name}"
    git clone -b "$target_branch" "$url" "${dir_name}"
  else
    current_branch=$(cd "${dir_name}" && git branch --show-current)
    if [ "$current_branch" != "$target_branch" ]; then
      echo "WARNING: ${dir_name} is currently on '${current_branch}' which differs from the desired '${target_branch}'."
      echo "         Either update package.json or switch the branch back to '${target_branch}'."
      exit 1
    else
      echo "Updating ${dir_name}"
      (cd "${dir_name}" && git pull)
      if [ "$?" -ne 0 ]; then
        echo "WARNING: Unable to pull remote changes into ${dir_name}"
        exit 1
      fi
    fi
  fi
}

run() {
  if [ ! -z "${npm_package_config_max_common}" ]; then
    checkout_repo "set-common" "${npm_package_config_max_common}" "common"
  fi

  if [ ! -z "${npm_package_config_max_email_templates}" ]; then
    checkout_repo "email-templates" "${npm_package_config_max_email_templates}" "email-templates"
  fi

}

run
