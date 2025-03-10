#!/bin/bash

gtar -cvf nsb_installer.tar.gz --exclude="*.DS_Store" \
  --exclude=".git" --exclude=".gitignore" --exclude=".idea" \
  --exclude="dashboard.json" --exclude="todos" --exclude="img"\
  datastax_nsb
