#!/usr/bin/env bash

set -ex

bundle install --gemfile=docs-utility-scripts-2-0/stemcell-rn-bot/Gemfile

ruby docs-utility-scripts-2-0/stemcell-rn-bot/get-stemcells.rb