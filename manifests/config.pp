#
class nginx::config {
  $configdir  = "/etc/nginx"
  $configfile = "${configdir}/nginx.conf"
  $sitesdir   = "${configdir}/sites"
}
