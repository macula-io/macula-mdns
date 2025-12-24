# Changelog

All notable changes to this project will be documented in this file.

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
