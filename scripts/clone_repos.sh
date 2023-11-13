#!/usr/bin/env bash

#
# Copyright (C) 2019 Saalim Quadri (danascape)
#
# SPDX-License-Identifier: Apache-2.0 license
#

# Set Variables
# Workspace Path
WORKSPACE_PATH="/mnt/build/builds"

# Home Path
HOME_PATH="/mnt/build"

# Scripts Path
CI_PATH="$HOME_PATH/stormCI"

# Organization URL
ORG_URL="https://github.com/stormbreaker-project"

# Repositories
REPOS="
	linux-kernel-mainline
	linux-asus-X00P-3.18
	linux-asus-X00P-4.9
	linux-asus-X01AD
	linux-nothing-spacewar
	linux-oneplus-billie
	linux-xiaomi-msm8953
	"

check_kernel_repo()
{
	echo "Checking if $repo already exists"
	if [[ -d "$WORKSPACE_PATH/$repo" ]]; then
		echo "$repo exists. Checking commit-id."
		compare_commit_id
	else
		echo "$repo does not exist. Cloning the repository."
		git clone --depth 1 -b master $ORG_URL/"$repo" "$WORKSPACE_PATH"/"$repo"
	fi

}

compare_commit_id()
{
	echo "Fetching remote information of the device"
	cd "$WORKSPACE_PATH"/"$repo" || exit 1
	# Check commit ID from archive
	PREVIOUS_COMMIT_ID=$(cat "$CI_PATH"/commit-id/"$repo"-id)
	# Check commit ID of currently cloned repository
	CURRENT_COMMIT_ID=$(git log -1 --pretty=oneline | awk '{print $1}')
	cd "$CI_PATH" || exit 1
	if [[ "$PREVIOUS_COMMIT_ID" == "$CURRENT_COMMIT_ID" ]]; then
		echo "Commit ID ($CURRENT_COMMIT_ID) matches. Skipping Clone."
	else
		echo "Commit IDs are different."
		echo "Cloning the device repository after deleting"
		rm -rf "${WORKSPACE_PATH:?}"/"$repo"
		if [[ -d "$WORKSPACE_PATH/$repo" ]]; then
			echo "Something went wrong!"
		else
			git clone --depth 1 -b master $ORG_URL/"$repo" "$WORKSPACE_PATH"/"$repo"
		fi
	fi
}

for repo in $REPOS; do
	check_kernel_repo
done

# Generate/Update Commit IDs.
bash "$CI_PATH"/scripts/generate_ids.sh
