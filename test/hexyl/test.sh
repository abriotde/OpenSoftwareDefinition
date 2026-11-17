#!/bin/env bash

BIN_FILE=`whereis ls|awk '{print $2}'`
WORK_DIR=`pwd`
ROOT_DIR="$WORK_DIR/../.."
DEFINITION_FILE="$ROOT_DIR/software-specification.md"
SOURCE_CODE_DIR="$WORK_DIR/hexyl/"

if [ 1 == 0 ]; then
	# git submodule init
	cd $WORK_DIR/hexyl/
	cargo build
	$WORK_DIR/target/debug/hexyl $BIN_FILE > $WORK_DIR/out.log
fi

opencode run "Using specifications in $DEFINITION_FILE, generate L1-general, L2-functional, L3-architectural, L4-detailed folders for software defined in $SOURCE_CODE_DIR" -m local-ollama/qwen2.5-coder:7b

Using specifications in software-specification.md, generate L1-general, L2-functional, L3-architectural, L4-detailed folders in ./test/hexyl for software defined in ./test/hexyl/hexyl

