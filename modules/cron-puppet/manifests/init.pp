class cron-puppet {

package { 'vim': ensure => present, allow_virtual => true, }
package { 'curl': ensure => present, allow_virtual => true, require => Package['vim'],}
package { 'git': ensure => present, allow_virtual => true, require => Package['curl'],}

# file { '/root/example_file2.txt':
#    ensure => "file",
#    owner  => "root",
#    group  => "root",
#    mode   => "700",
#    content => "Congratulations!
#Puppet has created this file.
#",}

user { 'monitor':
  name	     => 'monitor',
  ensure     => present,
  password   => 'monitor',
  shell      => '/bin/bash',
  home       => '/home/monitor',
}

$dir1 = ['/home/monitor/', '/home/monitor/scripts','/home/monitor/src/',]

file { $dir1:
    ensure => "directory",
    owner  => "root",
    group  => "root",
    mode   => "0750",
} 

cron { 'run-memory-check':
    ensure  => present,
    command => "/home/monitor/src/my_memory_check -c 90 -w 70 -e exwhyzey3@yahoo.com",
    user    => root,
    minute  => '*/2',
}

cron { 'puppet-apply':
    ensure  => present,
    command => "puppet apply /etc/puppet/manifests/site.pp",
    user    => root,
    minute  => '*/1',
}

} # End node puppetmon.example.com
