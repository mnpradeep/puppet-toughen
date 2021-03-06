class toughen::cron (
  $allow_users = ['root']
){
  service { 'crond':
    ensure => 'running',
    enable => true,
  }

  file { '/etc/crontab':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
  }

  file { [ '/etc/cron.d',
      '/etc/cron.hourly',
      '/etc/cron.daily',
      '/etc/cron.weekly',
      '/etc/cron.monthly' ]:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }

  file { ['/etc/cron.deny', '/etc/at.deny']:
    ensure => absent,
  }

  file { ['/etc/cron.allow', '/etc/at.allow']:
    ensure  => file,
    content => template('toughen/schedulers.allow.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
  }
}
