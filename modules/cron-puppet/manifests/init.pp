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

exec { 'mem_check_download':
	cwd => '/home/monitor/scripts',
	command => '/usr/bin/wget https://raw.githubusercontent.com/exwhyzey/voyager/master/memory_check',
	onlyif => '/usr/bin/test ! -f /home/monitor/scripts/memory_check',
}

exec { 'mem_check_permission':
	command => '/bin/chmod 755 /home/monitor/scripts/memory_check',
	onlyif => '/usr/bin/test -f /home/monitor/scripts/memory_check',
}

exec { 'mem_check_link':
	command => '/bin/ln -s /home/monitor/scripts/memory_check /home/monitor/src/my_memory_check',
}

 cron { 'run-memory-check':
    ensure  => present,
    command => "/home/monitor/src/my_memory_check -c 90 -w 60 -e xyz@xyz.com",
    user    => root,
    minute  => '*/1',
}

cron { 'puppet-apply':
    ensure  => present,
    command => "puppet apply /etc/puppet/manifests/site.pp",
    user    => root,
    minute  => '*/1',
}

} # End node puppetmon.example.com
