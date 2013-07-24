#
define nginx::site (
  $site_tpl,
) {
  include nginx::config
  file { "${nginx::config::sitesdir}/${name}.conf":
    content => template($site_tpl),
    require => File[$nginx::config::sitesdir],
    notify  => Service['nginx'],
  }
}
