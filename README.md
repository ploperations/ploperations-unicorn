# unicorn

![PDK Version Badge](https://img.shields.io/puppetforge/pdk-version/ploperations/unicorn.svg?style=popout)
[![Puppet Forge Version Badge](https://img.shields.io/puppetforge/v/ploperations/unicorn.svg?style=popout)](https://forge.puppet.com/modules/ploperations/unicorn)
![Download Count Badge](https://img.shields.io/puppetforge/dt/ploperations/unicorn.svg?style=popout)
[![Build Status](https://github.com/ploperations/ploperations-unicorn/actions/workflows/pr_test.yml/badge.svg?branch=main)](https://github.com/ploperations/ploperations-unicorn/actions/workflows/pr_test.yml)

## Description

Install and run unicorn.

## Usage

Unicorn applications can either be run using the system unicorn (installed via
gems) or out of bundler. To make this selection, use the `source` parameter for
the defined type.

## Reference

This module is documented via `pdk bundle exec puppet strings generate --format markdown`. Please see [REFERENCE.md](REFERENCE.md) for more info.

## Changelog

[CHANGELOG.md](CHANGELOG.md) is generated prior to each release via `pdk bundle exec rake changelog`. This proecss relies on labels that are applied to each pull request.

## Development

Pull requests are welcome!
