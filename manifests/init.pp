# Install and run unicorn.
#
# @example
#   unicorn::app { 'my-sinatra-app':
#     approot     => '/opt/my-sinatra-app',
#     pidfile     => '/opt/my-sinatra-app/unicorn.pid',
#     socket      => '/opt/my-sinatra-app/unicorn.sock',
#     user        => 'sinatra',
#     group       => 'sinatra',
#     preload_app => true,
#     rack_env    => 'production',
#     source      => 'bundler',
#     require     => [
#       Class['ruby::dev'],
#       Bundler::Install[$app_root],
#     ],
#   }
#
# @param export_home Path to export the HOME environment.
#
# @param manage_package Whether to manage the unicorn package.
#
# @param ensure State to ensure the unicorn package.
#
# @param provider The provider used to ensure the unicorn package.
#
# @param manage_rack Whether to manage the rack package.
#
# @param rack_ensure State to ensure the rack package.
#
# @param rack_provider The provider used to ensure the rack package.
class unicorn (
  $export_home = undef,
  $manage_package = true,
  $ensure   = 'present',
  $provider = 'gem',
  $manage_rack = true,
  $rack_ensure = 'present',
  $rack_provider = 'gem',
) {
  if $manage_package {
    # The unicorn gem has prerequisites that requires building native extensions.
    require ruby::dev

    package { 'unicorn':
      ensure   => $ensure,
      provider => $provider,
    }
  }

  if $manage_rack {
    package { 'rack':
      ensure   => $rack_ensure,
      provider => $rack_provider,
    }
  }
}
