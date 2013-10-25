# == Class: homework
#
# This is an example puppet module created for Lillie Hejl
#
# It simply installs apache and configures sshd to not allow root login
#
# === Parameters
#
# This module does not have any parameters at this time
#
# === Variables
#
# This module does not have any variables at this time
#
# === Examples
#
#  include homework
#
# === Authors
#
# Bryce Wade <bryce@hawkeyes.org>
#
# === Copyright
#
# Copyright 2013 Bryce Wade, unless otherwise noted.
#
class homework inherits homework::params {
#
# First make sure httpd is installed
# In the future we may want to make sure it is running and customize
# the configuration, but for now that is not a requirement, and we don't
# want to make assumptions that will paint us into a corner down the road
#
# (But let's face it, it would probably be easier to use a module from the
# puppet forge if we want that complexity)

  package { 'httpd':
    ensure => installed,
  }

# Now let's set up sshd

# Grab a pre-configured file for the particular distro.  This is severely 
# limits where we can use it, and what we can do with it, but it is safer
# than trying to edit pre-existing files, and simpler than setting up
# templates

  file { '/etc/ssh/sshd_config':
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    alias   => 'sshd_config',
    source  => "puppet:///modules/homework/${::lsbdistcodename}/etc/ssh/sshd_config",
    notify  => Service['sshd'],
    require => Package['openssh-server'],
  }

# We should probably ensure ssh-server is actually installed
  package { 'openssh-server':
    ensure => present,
  }

# not allowing root logins tends to imply that we should allow non-root
# users to log in.  In which case we should probably make sure sshd is
# running, and restart it when we make changes
  service { 'sshd':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => [
      File['sshd_config'],
      Package['openssh-server']
    ],
  }
}
