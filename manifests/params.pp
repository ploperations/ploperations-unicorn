# Params class with default values.
class unicorn::params {
  case $facts['os']['name'] {
    'debian': {
      case $facts['os']['release']['major'] {
        '6': {
          $unicorn_executable = '/var/lib/gems/1.8/bin/unicorn'
          $bundler_executable = '/var/lib/gems/1.8/bin/bundle'
        }
        default: {
          $unicorn_executable = '/usr/local/bin/unicorn'
          $bundler_executable = '/usr/local/bin/bundle'
        }
      }
    }
    default: {
      $unicorn_executable = '/usr/local/bin/unicorn'
      $bundler_executable = '/usr/local/bin/bundle'
    }
  }

  case $facts['kernel'] {
    'linux': {
      $rc_d        = '/etc/init.d'
      $etc_default = true
      $initscript  = 'unicorn/init-unicorn.erb'
    }
    'freebsd': {
      $rc_d        = '/usr/local/etc/rc.d'
      $etc_default = false
      $initscript  = 'unicorn/rc.d-unicorn.erb'
    }
    default: {}
  }
}
