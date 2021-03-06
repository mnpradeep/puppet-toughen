# Class: toughen::sssd
# 
# Parameters
# ----------
#
class toughen::sssd (
  $touch_config = false,
  $memcache_timeout = 86400,
  $offline_cred_expiry = 1,
  $known_hosts_timeout = 86400,
){

  validate_integer($memcache_timeout)
  validate_integer($offline_cred_expiry)
  validate_integer($known_hosts_timeout)
  validate_bool($touch_config)

  package { 'sssd':
    ensure => 'installed',
  }

  if $touch_config {
    file { '/etc/sssd/sssd.conf':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0600',
      require => Package['sssd'],
    }

    augeas { 'sssd-security':
      context => '/files/etc/sssd/sssd.conf',
      changes => [
        "set dir[. = '/nss'] /nss",
        "set dir[. = '/nss']/memcache_timeout ${memcache_timeout}",
        "set dir[. = '/nss']/offline_credentials_expiration ${offline_cred_expiry}",
        "set dir[. = '/nss']/ssh_known_hosts_timeout ${known_hosts_timeout}"
      ],
      require => File['/etc/sssd/sssd.conf'],
      before  => Service['sssd'],
    }

  }

  service { 'sssd':
    ensure  => 'running',
    enable  => true,
    require => Package['sssd'],
  }

}
