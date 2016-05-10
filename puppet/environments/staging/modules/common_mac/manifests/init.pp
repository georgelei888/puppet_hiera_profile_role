class common_mac
{ 
  notify {"Create a testmachine user for OSX": }

  user { 'testmachine':
  		ensure     => 'present',
  		comment    => 'testmachine',
  		gid        => '20',
  		groups     => ['admin', 'staff'],
  		home       => '/Users/testmachine',
		iterations => '1120',
  		password   => hiera('profile::common_mac::password'),
  		salt       => hiera('profile::common_mac::salt'),
  		shell      => '/bin/bash',
  		uid        => '502',
  }

  file { '/Users/testmachine':
		ensure	   => 'directory',
		owner	   => 'testmachine',
		group	   => 'staff',
		mode	   => 0755,
		require    => User['testmachine'],
  }
}
