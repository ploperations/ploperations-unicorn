# Defines a unicorn application
#
# @param approot Path to the application working directory.
#
# @param pidfile Path to the PID file.
#
# @param socket Path to socket file.
#
# @param export_home Path to export the HOME environment.
#
# @param backlog Value to set for the backlog on the listening socket.
#
# @param workers Number of worker_processes to run.
#
# @param user Specify the user to run unicorn as.
#
# @param group Specify the group to run unicorn as.
#
# @param config_file The path to install the configuration file.
#
# @param config_template The source template for the configuration file.
#
# @param initscript The template to use for the unicorn init script.
#
# @param init_time The time in seconds between checks for the old unicorn process during a service reload.
#
# @param logdir Path to the application log directory.
#
# @param rack_env The rack environment mode to start as.
#
# @param preload_app Whether to preload the application before forking worker processes.
#
# @param source The daemon source used to run the application.
#
# @param extra_settings A hash of additional settings to pass directly intol the application configuration file.
define unicorn::app (
  $approot,
  $pidfile,
  $socket,
  $export_home     = undef,
  $backlog         = '2048',
  $workers         = $facts['processors']['count'],
  $user            = 'root',
  $group           = 'root',
  $config_file     = undef,
  $config_template = 'unicorn/config_unicorn.config.rb.erb',
  $initscript      = undef,
  $init_time       = 15,
  $logdir          = "${approot}/log",
  $rack_env        = 'production',
  $preload_app     = false,
  $source          = 'system',
  $extra_settings  = {},
) {
  require unicorn
  include unicorn::params

  $rc_d            = $unicorn::params::rc_d
  $real_initscript = pick($initscript, $unicorn::params::initscript)

  if ! $rc_d {
    fail('unicorn is not supported on this platform')
  }

  # If we have been given a config path, use it, if not, make one up.
  # This _may_ not be the most secure, as it should live outside of
  # the approot unless it's almost going to be non $unicorn_user
  # writable.
  if ! $config_file {
    $config = "${approot}/config/unicorn.config.rb"
  } else {
    $config = $config_file
  }

  $unicorn_opts = "--daemonize --env ${rack_env} --config-file ${config}"
  # XXX Debian Wheezy specific
  case $source {
    'system': {
      $daemon      = $unicorn::params::unicorn_executable
      $daemon_opts = $unicorn_opts
    }
    'bundler': {
      $daemon      = $unicorn::params::bundler_executable
      $daemon_opts = "exec unicorn ${unicorn_opts}"
    }
    /[a-z]/: {
      # A path to an executable
      $daemon      = $source
      $daemon_opts = $unicorn_opts
    }
    default: {
      fail("unicorn::app can't handle daemon source '${source}'")
    }
  }

  if $facts['service_provider'] == 'systemd' {
    systemd::unit_file { "unicorn_${name}.service":
      content => template('unicorn/systemd/unicorn.service.erb'),
      owner   => 'root',
      group   => '0',
      mode    => '0644',
      enable  => true,
      active  => true,
    }
    ~> service { "unicorn_${name}":
      ensure => running,
      enable => true,
    }
  } else {
    service { "unicorn_${name}":
      ensure    => running,
      enable    => true,
      hasstatus => true,
      start     => "${rc_d}/unicorn_${name} start",
      stop      => "${rc_d}/unicorn_${name} stop",
      restart   => "${rc_d}/unicorn_${name} reload",
      require   => File["${rc_d}/unicorn_${name}"],
    }

    if $unicorn::params::etc_default {
      file { "/etc/default/unicorn_${name}":
        owner   => 'root',
        group   => '0',
        mode    => '0644',
        content => template('unicorn/default-unicorn.erb'),
        notify  => Service["unicorn_${name}"],
        before  => Service["unicorn_${name}"],
      }
    }

    file { "${rc_d}/unicorn_${name}":
      owner   => 'root',
      group   => '0',
      mode    => '0755',
      content => template($real_initscript),
      notify  => Service["unicorn_${name}"],
    }
  }

  file { $config:
    owner   => 'root',
    group   => '0',
    mode    => '0644',
    content => template($config_template),
    notify  => Service["unicorn_${name}"];
  }
}
