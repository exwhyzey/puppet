class cron-puppet {

file { '/root/example_file2.txt':
    ensure => "file",
    owner  => "root",
    group  => "root",
    mode   => "700",
    content => "Congratulations!
Puppet has created this file.
",}

user { 'monitor':
  name	     => 'monitor',
  ensure     => present,
  password   => 'monitor',
  shell      => '/bin/bash',
  home       => '/home/monitor',
}

package { 'vim': ensure => present, allow_virtual => true, }
package { 'curl': ensure => present, allow_virtual => true, require => Package['vim'],}
package { 'git': ensure => present, allow_virtual => true, require => Package['curl']}


cron { 'puppet-apply':
    ensure  => present,
    command => "puppet apply /etc/puppet/manifests/site.pp",
    user    => root,
    minute  => '*/1',
}

} # End node puppetmon.example.com
