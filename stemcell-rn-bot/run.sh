#!/usr/bin/env bash

set -ex

bundle install --gemfile=docs-utility-scripts-1-10/stemcell-rn-bot/Gemfile

ruby docs-utility-scripts-1-10/stemcell-rn-bot/get-stemcells.rb