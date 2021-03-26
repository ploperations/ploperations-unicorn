# Install and run unicorn.
#
# @param export_home Path to export the HOME environment.
#
# @param manage_package Whether to manage the unicorn package.
#
# @param ensure State to ensure the unicorn package.
#
# @param provider The provider used to ensure the unicorn package.
class unicorn (
  $export_home = undef,
  $manage_package = true,
  $ensure   = 'present',
  $provider = 'gem',
) {
  if $manage_package {
    # The unicorn gem has prerequisites that requires building native extensions.
    require ruby::dev
    include rack

    package { 'unicorn':
      ensure   => $ensure,
      provider => $provider,
    }
  }
}
