node 'localhost'{
  include apt
  include wget
  include dependencies
  include git

  class { 'nodejs': }

  class { '::rvm' : }
  rvm_system_ruby {
    'ruby-2.2.2':
      ensure      => present,
      default_use => true
  }

  rvm_gem {
    'ruby-2.2.2@global/bundler':
      ensure       => latest,
      require      => Rvm_system_ruby['ruby-2.2.2']
  }

  class { 'postgresql::server':
    ip_mask_allow_all_users => '0.0.0.0/0',
    listen_addresses        => '*',
    postgres_password       => 'postgres',
  }

  postgresql::server::role { 'postgres':
    password_hash => postgresql_password('postgres', 'postgres'),
    createdb => true,
    createrole => true,
    superuser => true
  }

  postgresql::server::role { 'vagrant':
    password_hash => postgresql_password('vagrant', ''),
    createdb => true,
    createrole => true,
    superuser => true
  }

  user { 'vagrant':
    ensure     => present,
    shell      => '/bin/bash',
    home       => '/home/vagrant',
    managehome => true,
    groups     => ['rvm']
  }
}
