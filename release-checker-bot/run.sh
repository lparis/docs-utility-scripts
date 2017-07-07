#!/usr/bin/env bash

set -ex

bundle install --gemfile=docs-utility-scripts-1-11/release-checker-bot/Gemfile

ruby docs-utility-scripts-1-11/release-checker-bot/get-releases.rb