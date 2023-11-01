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
REMOTE_URL="https://github.com/danascape-projects"

# GitHub API Token - Place your own and don't share it with anyone.
GITHUB_API_TOKEN=""

# Repositories.
REPOS="
	device_asus_X00P-kernel
	device_asus_X01AD-kernel
	device_nothing_spacewar-kernel
	device_oneplus_billie-kernel
    device_xiaomi_msm8953-kernel
	"

# X00P Family
X00P_FAMILY="
    device_asus_X00P-3.18-kernel
    device_asus_X00P-4.9-kernel
    "

# MSM8953 family
MSM8953_FAMILY="
	device_xiaomi_daisy-kernel
	device_xiaomi_mido-kernel
	device_xiaomi_sakura-kernel
	device_xiaomi_tissot-kernel
	device_xiaomi_vince-kernel
	device_xiaomi_ysl-kernel
	"

check_kernel_repo()
{
	local repo
	local device

	device="$2"
	repo="$1"

	echo "Checking if $repo already exists"
	if [[ -f "$DIST_PATH/$repo/README.md" ]]; then
		echo "$repo exists. Copying dist contents."
		copy_dist_files "$device"
	else
		echo "Dist for $repo does not exist. Creating the repository."
		create_org_repository "$repo" "$device"
	fi

}

copy_dist_files()
{
	echo "Checking dist for $device"

}

create_org_repository()
{
	if [[ $# = 0 ]]; then
		echo "usage: create_org_repository [target]" >&2
		return 1
	fi

	local device
	local repo
	device="$2"
	repo="$1"
	curl -s -X POST -H "Authorization: token ${GITHUB_API_TOKEN}" -d '{ "name": "'"$repo"'" }' "https://api.github.com/orgs/${ORG_URL}/repos" > /dev/null

	setup_org_repository "$repo" "$device"
}

setup_org_repository()
{
	local DEVICE
	local repo
	repo="$1"
	DEVICE="$2"

	mkdir $DIST_PATH/$repo
	echo "$repo" >> $DIST_PATH/$repo/README.md

	cd $DIST_PATH/$repo
	REPO_URL="$REMOTE_URL/$repo"
	git init
	git remote add origin $REPO_URL
	git checkout -b master
	git add README.md
	git commit -sm "[CI]: Create remote for $repo"
	git push -u origin master
}

for repo in ${REPOS}; do
	DEVICE=$(echo $repo | awk -F'_' '{split($3, a, "-"); print a[1]}')
	if [[ "$DEVICE" == "X00P" ]]; then
		echo "X00P Detected. Using X00P family."
		for devRepo in ${X00P_FAMILY}; do
			check_kernel_repo $devRepo
		done
	elif [[ "$DEVICE" == "msm8953" ]]; then
		echo "msm8953 Family Detected."
		for devRepo in ${MSM8953_FAMILY}; do
			check_kernel_repo $devRepo
		done
	else
		check_kernel_repo $repo
	fi
done
