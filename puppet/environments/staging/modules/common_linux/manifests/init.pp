class common_linux
{ 
  notify {"Create a testuser user for CentOS": }

  user { 'testuser':
		ensure	   =>  'present',
		comment    =>  'Test User',
		home       =>  '/home/testuser',
                managehome =>  true,
  }
	
  ssh_authorized_key { 'testuser_ssh':
		user	   =>  'testuser',
		type	   =>  'rsa',
		key	   =>  hiera('profile::common_linux::sshkey'),
  }
}
