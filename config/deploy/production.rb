set :stage, :production

role :all, %w{mbm-datos.no-ip.org}

server 'mbm-datos.no-ip.org', user: 'deployer', roles: :all
