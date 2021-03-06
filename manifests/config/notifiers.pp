# == Define reaktor::config::notifiers
#
# This class is called from reaktor::config for configuring the notifiers.
#
define reaktor::config::notifiers(
  $link   = undef,
  $ensure = 'present',
  $owner  = $::reaktor::user,
  $group  = $::reaktor::group,
  $target = undef,
  $config = {},
) {
  $link_ensure = $ensure ? {
    'present' => 'link',
    true      => 'link',
    default   => $ensure
  }

  $_link = $link ? {
    undef   => "${reaktor::_install_dir}/lib/reaktor/notification/active_notifiers/${title}.rb",
    default => $link,
  }

  $_target = $target ? {
    undef   => "../available_notifiers/${title}",
    default => $target
  }

  file { $_link:
    ensure  => $link_ensure,
    owner   => $owner,
    group   => $group,
    require => Vcsrepo[$reaktor::_install_dir],
  }

  file { "${::reaktor::homedir}/etc/${title}_environment":
    ensure => $ensure,
    owner  => $owner,
    group  => $group,
    content => template("${module_name}/notifier_environment.erb"),
    require => Vcsrepo[$reaktor::_install_dir],
  }

  if $link_ensure == 'link' {
    File[$_link] {
      target => $_target
    }
  }
}
