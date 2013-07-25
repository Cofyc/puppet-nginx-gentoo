#
class nginx (
  $ensure                 = present,
  $default_site           = true,
  $worker_processes       = 1,
  $worker_connections     = 1024,
) {
  include nginx::config

  Service['nginx'] {
    restart => "/etc/init.d/nginx reload",
  }

  if !defined(Package_Use['www-servers/nginx']) {
    package_use { 'www-servers/nginx':
      use    => split('nginx_modules_http_stub_status nginx_modules_http_realip', ' '),
      notify => Package['nginx'],
    }
  }
  package { "nginx":
    ensure => $ensure,
  } ->
  file { 'nginx':
    path    => $nginx::config::configfile,
    content => template('nginx/nginx.conf.erb'),
    require => Package["nginx"],
    notify  => Service["nginx"],
  } ->
  file { $nginx::config::sitesdir:
    ensure => directory,
  } ->
  service { "nginx":
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

  if $default_site {
    nginx::site { "default":
      site_tpl => "nginx/site.default.conf.erb",
    }
  }
}
