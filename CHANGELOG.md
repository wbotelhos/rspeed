## master

#### Break Change

- Drops `RSPEED_RESULT_KEY` key in favor of `RSPEED_NAME`;
- Renames env `RSPEED_NAME` to `RSPEED_APP`;

#### News

- Adds env `RSPEED_SPEC_PATH` to indicate the spec folders path;
- Saves pipes and profiles with a zero at the beginning;

## v0.5.2

#### Fix

- Avoid duplicate entries in the consolidated result;

#### Update

- CSV dependency dropped;
- Drops tmp key in favor of profile keys fetch;

## v0.5.1

#### Fix

- Only pipe number 1 will warm up avoiding duplicated spec entries;

## v0.5.0

#### Fix

- Add env `RSPEED_NAME` to specify the application name and avoid result conflicts between multiple runs;
- No more depends on pipe sequence to generate ou aggregate the resul;
- rake `rspeed:install`;

#### Update

- The result of the pipes are no more saved on Redis. It's now calculated based on result key `rspeed`;

## v0.4.0

- Now we make diff to discover removed and added examples;

## v0.3.0

- Removed and added files now is considered on run;

## v0.2.0

- Splits specs by examples over files;

## v0.1.0

- First release;

## v0.0.1

- RubyGems namespace reservation.
