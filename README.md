# unicorn
![](https://img.shields.io/puppetforge/pdk-version/ploperations/unicorn.svg?style=popout)
![](https://img.shields.io/puppetforge/v/ploperations/unicorn.svg?style=popout)
![](https://img.shields.io/puppetforge/dt/ploperations/unicorn.svg?style=popout)
[![Build Status](https://github.com/ploperations/ploperations-unicorn/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/ploperations/ploperations-unicorn/actions/workflows/ci.yml)

Install and run unicorn.

Synopsis
--------

    unicorn::app { 'my-sinatra-app':
      approot     => '/opt/my-sinatra-app',
      pidfile     => '/opt/my-sinatra-app/unicorn.pid',
      socket      => '/opt/my-sinatra-app/unicorn.sock',
      user        => 'sinatra',
      group       => 'sinatra',
      preload_app => true,
      rack_env    => 'production',
      source      => 'bundler',
      require     => [
        Class['ruby::dev'],
        Bundler::Install[$app_root],
      ],
    }

Usage
-----

Unicorn applications can either be run using the system unicorn (installed via
gems) or out of bundler. To make this selection, use the `source` parameter for
the defined type.

Requirements
------------

  * Debian something.

## Reference

This module is documented via `pdk bundle exec puppet strings generate --format markdown`. Please see [REFERENCE.md](REFERENCE.md) for more info.

## Changelog

[CHANGELOG.md](CHANGELOG.md) is generated prior to each release via `pdk bundle exec rake changelog`. This proecss relies on labels that are applied to each pull request.
