#!/bin/bash

set -e

cd /tmp && wget https://web-dl.packagecloud.io/chef/stable/packages/ubuntu/trusty/chef-server-core_12.1.2-1_amd64.deb
dpkg -i /tmp/chef-server-core_12.1.2-1_amd64.deb
chef-server-ctl reconfigure
chef-server-ctl user-create ${chef_username} ${chef_user} ${chef_user_email} ${chef_password} --filename /tmp/stack.pem
chef-server-ctl org-create ${chef_organization_id} "${chef_organization_name}" --association_user ${chef_username} --filename /tmp/stack-validator.pem
mkdir -p /etc/opscode/
chef-server-ctl install opscode-manage
chef-server-ctl reconfigure
opscode-manage-ctl reconfigure
chef-server-ctl install opscode-reporting
chef-server-ctl reconfigure
opscode-reporting-ctl reconfigure
chef-server-ctl reconfigure
echo "nginx[\"enable_non_ssl\"] = true" > /etc/opscode/chef-server.rb
chef-server-ctl reconfigure
echo "Finished"
