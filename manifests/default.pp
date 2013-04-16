class bootstrap {
	group {"puppet":
		ensure => "present",
	}

	if $virtual == "virtualbox" and $fqdn == '' {
		$fqdn = "localhost"
	}
}

class utils {
	package {'curl': 
		ensure => present,
		require => Exec['apt-get update']
	}

	package {"python-software-properties":
		ensure => present,
	}

	package {'vim':
		ensure => present,
	}
}

# Install PHP 5.4 PPA and required packages 
class php54 {

	exec {'add php54 apt-repo':
		command => '/usr/bin/add-apt-repository ppa:ondrej/php5',
		require => Package['python-software-properties'],
	}
}

class php {
	$packages = [
		"php5",
		"php5-cli",
		"php5-fpm",
		"php5-dev",
		"php5-xdebug",
		"php-apc",
		"php-pear",
		"php5-curl"
	]

	package {
		$packages:
			ensure => latest,
			require => [Exec['apt-get update'], Package['python-software-properties']]
	}
}

# Java PPA and installation of Oracle Java JDK and Oracle Java JRE
class oracleJVM {
	exec {'add oracleJVM-repo':
		command => '/usr/bin/add-apt-repository ppa:webupd8team/java',
		require => Package['python-software-properties'] 
	}

	exec {"oracleJVM apt update":
		command => 'apt-get update',
	}
}

class java {
	package {"oracle-java7-installer":
		ensure => latest
	}

	exec {'accept license and install java':
		command => "echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections",
		before => Package["oracle-java7-installer"],
	}
}

# Remove Apache2 from server because its slow
class apache {
	package {'apache2':
		ensure => purged	
	}	

	package {'apache2-utils':
		ensure => purged
	}
}

# Now lets install Nginx
class nginx {
	exec {'add nginx-repo':
		command => "/usr/bin/apt-add-repository ppa:nginx/development",		
		require => Package['python-software-properties'] 
	}		

	package {'nginx':
		ensure => latest,
		require => [Exec['apt-get update'], Package['python-software-properties']]
	}	

	service {'nginx':
		ensure => running,
		require => Package['nginx'],
	}
}

# Load server configurations in Nginx 
class sites {
	$sites = [
		"html-8090",
		"php-8080"
	]

	define site_links {
		$base = "/sites"
		$site = $name

		$fullPath = "$base/$site"
		$linkPath = "/etc/nginx/sites-enabled/$site"

		file { $linkPath:
			ensure => link,	
			target => $fullPath 
		}	
	}
	
	site_links{$sites:;}
}

Exec {
	path => ["/usr/bin", "/bin", "/usr/sbin", "/sbin", "/usr/local/bin", "/usr/local/sbin"]
}

exec {'apt-get update':
	command => '/usr/bin/apt-get update',
	require => [
		Exec['add php54 apt-repo'], 
		Exec['add oracleJVM-repo'],
		Exec['add nginx-repo']
	]
}

include bootstrap
include utils 
include php54
include oracleJVM
include php
include java
include apache
include nginx
include sites
