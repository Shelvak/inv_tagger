set :stage, :production

role :all, 'mbm-datos.no-ip.org'

server 'mbm-datos.no-ip.org', user: 'deployer', roles: %w{web app db}
