#!/usr/bin/env bash

#
# Copyright (C) 2019 Saalim Quadri (danascape)
#
# SPDX-License-Identifier: Apache-2.0 license
#

# Set Variables
# Workspace Path.
WORKSPACE_PATH="$HOME/builds"

# Dist Path.
DIST_PATH="$WORKSPACE_PATH/dist"

# Scripts Path.
CI_PATH="$HOME/stormCI"

# Organization URL (To Create repositories).
ORG_URL="danascape-projects"

# GitHub API Token - Place your own and don't share it with anyone.
GITHUB_API_TOKEN=""

# Repositories.
REPOS="
	device_asus_X00P-3.18-kernel
	device_asus_X00P-4.9-kernel
	device_asus_X01AD-kernel
	device_nothing_spacewar-kernel
	device_oneplus_billie-kernel
	"

create_org_repository()
{
    if [[ $# = 0 ]]; then
		echo "usage: create_org_repository [target]" >&2
		return 1
	fi

    local repo
    repo="$1"
    curl -s -X POST -H "Authorization: token ${GITHUB_API_TOKEN}" -d '{ "name": "'"$repo"'" }' "https://api.github.com/orgs/${ORG_URL}/repos"
}

for repo in ${REPOS}; do
    create_org_repository "$repo"
done