#
# Automatically generated by blueprint(7).  Edit at your own risk.
#
class byzpi {
	Exec {
		path => '/usr/sbin:/usr/bin:/sbin:/bin',
	}
	Class['packages'] -> Class['files'] -> Class['services']
	class files {
		file {
			'/etc':
				ensure => directory;
			'/etc/avahi':
				ensure => directory;
			'/etc/avahi/avahi-daemon.conf':
				content => template('byzpi/etc/avahi/avahi-daemon.conf'),
				ensure  => file,
				group   => root,
				mode    => 0644,
				owner   => root;
			'/etc/default':
				ensure => directory;
			'/etc/default/ifplugd':
				content => template('byzpi/etc/default/ifplugd'),
				ensure  => file,
				group   => root,
				mode    => 0644,
				owner   => root;
			'/etc/dnsmasq.conf':
				content => template('byzpi/etc/dnsmasq.conf'),
				ensure  => file,
				group   => root,
				mode    => 0644,
				owner   => root;
			'/etc/ifplugd':
				ensure => directory;
			'/etc/ifplugd/action.d':
				ensure => directory;
			'/etc/ifplugd/action.d/mesh':
				content => template('byzpi/etc/ifplugd/action.d/mesh'),
				ensure  => file,
				group   => root,
				mode    => 0755,
				owner   => root;
			'/etc/init.d':
				ensure => directory;
			'/etc/init.d/ssl':
				content => template('byzpi/etc/init.d/ssl'),
				ensure  => file,
				group   => root,
				mode    => 0755,
				owner   => root;
			'/etc/olsrd':
				ensure => directory;
			'/etc/olsrd/olsrd.conf':
				content => template('byzpi/etc/olsrd/olsrd.conf'),
				ensure  => file,
				group   => root,
				mode    => 0644,
				owner   => root;
			'/etc/rc.local':
				content => template('byzpi/etc/rc.local'),
				ensure  => file,
				group   => root,
				mode    => 0755,
				owner   => root;
			'/etc/resolv.conf.gateway':
				content => template('byzpi/etc/resolv.conf.gateway'),
				ensure  => file,
				group   => root,
				mode    => 0644,
				owner   => root;
			'/etc/ssl':
				ensure => directory;
			'/etc/ssl/openssl.cnf':
				content => template('byzpi/etc/ssl/openssl.cnf'),
				ensure  => file,
				group   => root,
				mode    => 0644,
				owner   => root;
			'/etc/network/interfaces':
				content => template('byzpi/etc/network/interfaces'),
				ensure  => file,
				group   => root,
				mode    => 0644,
				owner   => root;
		}
	}
	include files
	class packages {
		exec { 'apt-get -q update':
			before => Class['apt'],
		}
		class apt {
			exec { '/bin/sh -c " { curl http://npmjs.org/install.sh || wget -O- http://npmjs.org/install.sh } | sh"':
				creates => '/usr/bin/npm',
				require => Package['nodejs'],
			}
			package {
				'apache2':
					ensure => '2.2.22-13';
				'autoconfigd':
					ensure => '0.1-3';
				'avahi-daemon':
					ensure => '0.6.31-2';
				'avahi-discover':
					ensure => '0.6.31-2';
				'avahi-dnsconfd':
					ensure => '0.6.31-2';
				'avahi-utils':
					ensure => '0.6.31-2';
				'captive-portal-daemon':
					ensure => '0.3-1';
				'dhcpcd5':
					ensure => '5.5.6-1';
				'dnsmasq':
					ensure => '2.62-3+deb7u1';
				'firmware-linux':
					ensure => '0.36+wheezy.1';
				'ifplugd':
					ensure => '0.28-19';
				'iputils-arping':
					ensure => '3:20101006-1';
				'nodejs':
					ensure => '0.6.19~dfsg1-6';
				'npm':
					ensure => '1.1.4~dfsg-2';
				'olsrd':
					ensure => '0.6.2-2.1';
				'olsrd-plugins':
					ensure => '0.6.2-2.1';
				'openssl-blacklist':
					ensure => '0.5-3';
				'python-openssl':
					ensure => '0.13-2+rpi1';
				'python-cherrypy3':
					ensure => '3.2.2-2';
				'python-mako':
					ensure => '0.7.0-1.1';
				'python-markupsafe':
					ensure => '0.15-1';
				'python-setuptools':
					ensure => '0.6.24-1';
				'verify-operation':
					ensure => '0.1-1';
				'wireless-tools':
					ensure => '30~pre9-8';
			}
		}
		include apt
	}
	include packages
	class services {
		class sysvinit {
			service {
				'apache2':
					enable    => true,
					ensure    => running,
					subscribe => [Package['apache2']];
				'avahi-daemon':
					enable    => true,
					ensure    => running,
					subscribe => [File['/etc/avahi/avahi-daemon.conf'], Package['avahi-daemon']];
				'avahi-dnsconfd':
					enable    => true,
					ensure    => running,
					subscribe => [File['/etc/avahi/avahi-daemon.conf'], Package['avahi-dnsconfd']];
				'dnsmasq':
					enable    => false,
					subscribe => [File['/etc/dnsmasq.conf'], Package['dnsmasq']];
				'ifplugd':
					enable    => true,
					ensure    => running,
					subscribe => [File['/etc/ifplugd/action.d/mesh'], File['/etc/resolv.conf.gateway'], Package['ifplugd']];
				'olsrd':
					enable    => false,
					subscribe => [File['/etc/olsrd/olsrd.conf'], Package['olsrd']];
			}
		}
		include sysvinit
	}
	include services
}
