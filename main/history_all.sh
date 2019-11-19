#!/usr/bin/env bash
set -eu

awk -F '' '{print $1}' \
  | grep -v '^\s*$' \
  | awk '!l[$0]++'

