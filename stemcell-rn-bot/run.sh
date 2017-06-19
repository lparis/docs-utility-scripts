#!/usr/bin/env bash

set -ex

bundle install --gemfile=docs-utility-scripts-1-11/stemcell-rn-bot/Gemfile

ruby docs-utility-scripts-1-11/stemcell-rn-bot/get-stemcells.rb