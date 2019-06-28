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
