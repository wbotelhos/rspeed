# RSpeed

[![Build Status](https://github.com/wbotelhos/rspeed/workflows/CI/badge.svg)](https://github.com/wbotelhos/rspeed/actions)
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

- `RSPEED`: Enables RSpeed
- `RSPEED_PIPES`: Quantity of pipes
- `RSPEED_PIPE`: Current pipe
- `RESPEED_TMP_KEY`: The temporary keep that keeps the partial pipes result
- `RESPEED_RESULT_KEY`: The key that keeps the final result of all pipes

```sh
RSPEED=true RSPEED_PIPES=3 RSPEED_PIPE=1 bundle exec rake rspeed:run
```

## How it Works

### First run

1. Since we has no statistics on the first time, we run all specs and collect it;

```json
{ "file": "./spec/models/1_spec.rb", "time": 0.01 }
{ "file": "./spec/models/2_spec.rb", "time": 0.02 }
{ "file": "./spec/models/3_spec.rb", "time": 0.001 }
{ "file": "./spec/models/4_spec.rb", "time": 1 }
```

### Second and next runs

1. Previous statistics is balanced by times and distributed between pipes:

```json
{ "file": "./spec/models/4_spec.rb", "time": 1 }
```

```json
{ "file": "./spec/models/2_spec.rb", "time": 0.02 }
```

```json
{ "file": "./spec/models/3_spec.rb", "time": 0.001 }
{ "file": "./spec/models/1_spec.rb", "time": 0.01 }
```

2. Run the current pipe `1`:

```json
{ "file": "./spec/models/4_spec.rb", "time": 1 }
```

- Collects statistics and temporary save it;

4. Run the current pipe `2`:

```json
{ "file": "./spec/models/2_spec.rb", "time": 0.02 }
```

- Collects statistics and temporary save it;

5. Run the current pipe `3`:

```json
{ "file": "./spec/models/3_spec.rb", "time": 0.001 }
{ "file": "./spec/models/1_spec.rb", "time": 0.01 }
```

- Collects statistics and temporary save it;
- Sum all the last statistics and save it for the next run;
