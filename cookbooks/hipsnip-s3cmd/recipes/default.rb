#
# Cookbook Name:: s3cmd
# Recipe:: default
#
# Copyright 2012, HipSnip Ltd.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


# Force this to run during compile time - we need it later in the Chef run
package("s3cmd") { action :nothing }.run_action(:install)

node['s3cmd']['users'].each do |user|

  home = user == "root" ? "/root" : "/home/#{user}"

  if File.exists? home
    file = "#{home}/.s3cfg"

    template file do
        source "s3cfg.erb"
        mode 0655
    end
  else
    warn %Q(Home folder "#{home}" doesn't exist)
  end
end