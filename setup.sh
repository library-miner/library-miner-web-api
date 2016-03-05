#!/bin/bash

# bundle install
bundle install

# setup database settings
cp config/{database.yml.example,database.yml}

# setup database
bundle exec rake db:create db:migrate db:seed
