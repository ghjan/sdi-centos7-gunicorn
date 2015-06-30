#!/bin/bash

if [[ -f $PIP_REQUIREMENTS_FILE ]] ; then
	pip install -r $PIP_REQUIREMENTS_FILE
else
	echo "No Requirements File found"
fi
