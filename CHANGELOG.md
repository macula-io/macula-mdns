# Changelog

All notable changes to this project will be documented in this file.

## [0.1.1] - 2026-09-05

### Fixed

- **`mdns:vsn/0`, `mdns:start/0`, and a private module-listing helper
  referenced the wrong OTP application name, crash-looping the built-in
  advertiser on every distributed node.** These called `application:get_key/2` and
  `application:ensure_all_started/1` with `?MODULE` (`mdns`), left over
  from before the 0.1.0 rename to `macula_mdns` — so `get_key(mdns, vsn)`
  always returned `undefined` and badmatched. `mdns_erlang_tcp_advertiser`
  calls `mdns:vsn/0` on every announce; found and reproduced on a real
  `-sname` node: the advertiser crashes, restarts, crashes again ~1s
  later, `mdns_advertise_sup` hits `reached_max_restart_intensity` and
  shuts down, and the app is left running with no advertiser and no
  further restart attempt — silently, since `application:which_applications/0`
  still reports `macula_mdns` as up. Fixed all three call sites to use
  `macula_mdns` directly; `subscribe/1` and `notify/2`'s use of `?MODULE`
  as a gproc namespace key is unrelated and untouched. Verified with a
  before/after boot test on a real distributed node: 2 crash reports + 1
  supervisor shutdown before the fix, 0 of either after, over an 8s idle
  window. Pre-existing since the 0.1.0 rename; unrelated to the gproc bump
  below (reproduced identically under both gproc 0.9.1 and 1.3.0).

### Changed

- `gproc` bumped `0.9.1 → 1.3.0` and loosened `"0.9.1"` → `"~> 1.3"`; the
  previous exact pin made it impossible for a consumer resolving both
  this package and macula-io/macula together to ever satisfy macula's
  own `gproc ~> 1.3` — a real solver conflict, not a hypothetical one
  (surfaced by an adversarial review of macula 10.20.0, which depends on
  this package). Verified safe: gproc 0.9.1→1.3.0 audited commit-by-commit
  across all 4 tag jumps (macula-io/macula's CHANGELOG has the full trace)
  — purely additive remote-registration API plus internal non-exported
  refactors plus an OTP 29 warnings fix. This library's own gproc surface
  (`gproc:reg/1`, `gproc:send/2`, `gproc:goodbye/0`, `{via, gproc, ...}`
  in `mdns_advertise`/`mdns_discover`) is untouched by any of it.
- `macula_envy` loosened `"0.1.1"` → `"~> 0.1.1"` (no version change,
  same exact-pin hygiene fix; three-segment form since it's a 0.x
  package and `~> 0.1` alone would admit a future breaking minor).

## [0.1.0] - 2024-12-24

### Added
- Initial release as `macula_mdns` on hex.pm
- rebar3 build support (original used erlang.mk)
- hex.pm package configuration
- ex_doc documentation support
- Fixed deprecated `crypto:rand_uniform` calls

### Attribution
This is a fork of [shortishly/mdns](https://github.com/shortishly/mdns) by Peter Morgan.
All credit for the original design and implementation goes to Peter Morgan.

### Changes from original
- Added `rebar.config` for rebar3 compatibility
- Added `macula_mdns.app.src` for OTP application spec
- Package published to hex.pm as `macula_mdns`
- Depends on `macula_envy` instead of `envy`
- Module names remain `mdns*` for API compatibility
- Replaced deprecated `crypto:rand_uniform/2` with `rand:uniform/1`
