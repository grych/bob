#!/usr/bin/env bash
git rm -rf doc/
rdoc --main README.rdoc --exclude tmp/ --exclude log/ --exclude bin/ --exclude db/

