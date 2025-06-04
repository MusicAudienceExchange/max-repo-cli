#!/bin/sh

NPMRC=".npmrc"

gh_token() {
  if [ -n "${GH_PAT}" ]; then
    echo "$GH_PAT"
  elif [ -e "$NPMRC" ]; then
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
    if [ ! -d "${dir_name}/.git" ]; then
      echo "INFO: ${dir_name} does not appear to be a git repo; skipping"
      return
    fi
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

  if [ ! -z "${npm_package_config_max_melodies_source}" ]; then
    local melodies_checkout_path="${npm_package_config_max_melodies_source_path:-src/melodies-source}"
    checkout_repo "melodies-source" "${npm_package_config_max_melodies_source}" "${melodies_checkout_path}"
  fi
}

run
