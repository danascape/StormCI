#!/usr/bin/env bash

#
# Copyright (C) 2019 Saalim Quadri (danascape)
#
# SPDX-License-Identifier: Apache-2.0 license
#

# Set Variables
# Scripts Path
CI_PATH="$HOME/stormCI"

concatenate_jsons()
{
    jq -s '.' $(cat $CI_PATH/json-files) > $CI_PATH/json/devices.json
}

result_json_ids()
{
    git add json/
	git commit -sm "[CI]: Update Device JSONs"
}

# Concatenate JSONs.
concatenate_jsons

# Create Commit of Updated JSONs.
result_json_ids
