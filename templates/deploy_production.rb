server 'change-me@example.com', user: 'deploy', roles: %w{web app db}

set :branch, ENV['BRANCH'] || 'production'
