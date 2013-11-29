set :stage, :production

role :web, 'mbm-datos.no-ip.org'
role :app, 'mbm-datos.no-ip.org'
role :db, 'mbm-datos.no-ip.org', primary: true

server 'mbm-datos.no-ip.org', user: 'deployer', roles: %w{web app db}
