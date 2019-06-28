# RSpeed

[![Build Status](https://travis-ci.org/wbotelhos/rspeed.svg)](https://travis-ci.org/wbotelhos/rspeed)
[![Gem Version](https://badge.fury.io/rb/rspeed.svg)](https://badge.fury.io/rb/rspeed)
[![Maintainability](https://api.codeclimate.com/v1/badges/cc5efe8b06bc1d5e9e8a/maintainability)](https://codeclimate.com/github/wbotelhos/rspeed/maintainability)
[![Patreon](https://img.shields.io/badge/donate-%3C3-brightgreen.svg)](https://www.patreon.com/wbotelhos)

Split and speed up your RSpec tests.

## Install

Add the following code on your `Gemfile` and run `bundle install`:

```ruby
gem 'rspeed'
```

## Usage

```sh
RSPEED=true RSPEED_PIPES=3 RSPEED_PIPE=1 r spec
```

## Rake Example

```sh
# frozen_string_literal: true

require "rspeed"

namespace :rspeed do
  task run: :environment do
    pipe_number = ENV.fetch("RSPEED_PIPE", 1)
    splitter    = ::RSpeed::Splitter.new
    json        = splitter.get("rspeed_#{pipe_number}")
    files       = json.map { |item| item["files"] }.reject(&:blank?).flatten(1).map { |item| item[1] }

    puts "\n\n>>> [RSpeed] Pipe #{pipe_number}:\n\n#{files.join("\n")}\n\n"

    sh "bundle exec rspec #{files.join(" ")}"
  end
end
```
