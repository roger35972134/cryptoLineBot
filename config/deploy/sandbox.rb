# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.

role :app, %w(deploy@192.168.0.101:14922)
role :web, %w(deploy@192.168.0.101:14922)
role :db,  %w(deploy@192.168.0.101:14922)

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.

server '192.168.0.101', user: 'deploy', roles: %w(web app), port: 14922

set :deploy_to, '/home/deploy/coin_gecko_crawler'
set :rails_env, :production
set :pty, false