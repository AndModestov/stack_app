# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

# server 'example.com', user: 'deploy', roles: %w{app db web}, my_property: :my_value
# server 'example.com', user: 'deploy', roles: %w{app web}, other_property: :other_value
server '82.196.4.83', user: 'deployer', roles: %w{web app db}, primary: true


# role-based syntax
# ==================

# Defines a role with one or multiple servers. The primary server in each
# group is considered to be the first unless any  hosts have the primary
# property set. Specify the username and a domain or IP for the server.
# Don't use `:all`, it's a meta role.

role :app, %w{deployer@82.196.4.83}
role :web, %w{deployer@82.196.4.83}
role :db, %w{deployer@82.196.4.83}

set :rails_env, :production
set :stage, :production

# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult the Net::SSH documentation.
# http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start
#
# Global options
# --------------
set :ssh_options, {
    keys: %w(/home/andrew/.ssh/id_rsa),
    forward_agent: true,
    auth_methods: %w(publickey password),
    port: 2306
}