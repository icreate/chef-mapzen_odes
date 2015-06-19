#
# Cookbook Name:: mapzen_odes
# Recipe:: user
#

# create user provided someone doesn't tell us to
#   run as root.
user_account node[:mapzen_odes][:user][:id] do
  home          node[:mapzen_odes][:setup][:basedir]
  shell         node[:mapzen_odes][:user][:shell]
  manage_home   node[:mapzen_odes][:user][:manage_home]
  create_group  node[:mapzen_odes][:user][:create_group]
  ssh_keygen    node[:mapzen_odes][:user][:ssh_keygen]
  not_if        { node[:mapzen_odes][:user][:id] == 'root' }
end
