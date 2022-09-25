# Card Baseball

[![Rubocop Actions Status](https://github.com/dsandstrom/card_baseball/workflows/Rubocop/badge.svg)](https://github.com/dsandstrom/card_baseball/actions?query=workflow%3ARubocop) [![Stylelint Actions Status](https://github.com/dsandstrom/card_baseball/workflows/Stylelint/badge.svg)](https://github.com/dsandstrom/card_baseball/actions?query=workflow%3AStylelint)

## Introduction
This is a Ruby on Rails app built to house League and Player information for a Card Baseball Game. The "card" game has since been abandoned, but has been heartfully continued using an Excel file. This app hopes to reproduce the game, but is currently a work in progress.

## Local Setup

#### System dependencies
* Ruby
* rbenv, rvm, or similar
* PostgreSQL

#### Configuration

##### Install Ruby, Rails, and gems

Clone from GitHub and `cd` into project directory

```sh
# install ruby version set in .ruby-version
rbenv install # or `rvm install`
gem install bundler
bundle install --without production
```

#### Install Frontend Dependencies
Install [yarn](https://github.com/yarnpkg/yarn) on your system. This step might
also install Node.js, but please see below to ensure that you use the right
version when working on the project.

I use [Node Version Manager](https://github.com/nvm-sh/nvm) to maintain a more
consistent Node.js version. The version number is stored in *./.nvmrc*. Please
use that version of node or use **nvm** to install it.

```sh
# using nvm
# cd into project directory
nvm install
nvm use

# finally, install packages
yarn install
```

#### Setup secrets

Environment variables are used to store passwords and tokens. The gem [dotenv-rails](https://github.com/bkeepers/dotenv) is used in test and development environments. An example file is included in the repo for an idea of the key options.  For production, set variables when running the app.

* Rename `.env.example` to `.env` and add the real values

#### Database creation/initialization

```sh
bin/rails db:setup
```

#### How to run the test suite

```sh
bin/rails rspec spec/
```

#### Services (job queues, cache servers, search engines, etc.)

I use guard to automate local development
```sh
bundle exec guard -g backend # start rspec and bundler watchers
bundle exec guard -g frontend # start server (port 3000) and livereload watcher
```
