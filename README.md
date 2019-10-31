# RSpeed

[![Build Status](https://travis-ci.org/wbotelhos/rspeed.svg)](https://travis-ci.org/wbotelhos/rspeed)
[![Gem Version](https://badge.fury.io/rb/rspeed.svg)](https://badge.fury.io/rb/rspeed)
[![Maintainability](https://api.codeclimate.com/v1/badges/cc5efe8b06bc1d5e9e8a/maintainability)](https://codeclimate.com/github/wbotelhos/rspeed/maintainability)
[![Patreon](https://img.shields.io/badge/donate-%3C3-brightgreen.svg)](https://www.patreon.com/wbotelhos)

RSpeed splits your specs to you run parallels tests.

## Install

Add the following code on your `Gemfile` and run `bundle install`:

```ruby
gem 'rspeed'
```

## Setup

We need to extract the rake that executes the split via `rspeed:run`.

```ruby
rake rspeed:install
```

## Usage

`RSPEED_PIPES`: Quantity of pipes
`RSPEED_PIPE`: Current pipe

```sh
RSPEED=true RSPEED_PIPES=3 RSPEED_PIPE=1 bundle exec rake rspeed:run
```
