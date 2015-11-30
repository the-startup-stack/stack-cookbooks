include_recipe "git"

sensu_plugins_directory   = "/opt/sensu-community-plugins"

git sensu_plugins_directory do
  repository "git@github.com:sensu/sensu-community-plugins.git"
  reference "master"
  action :sync
end

ruby_block "flat sensu community plugins" do
  block do
    ["plugins", "handlers"].each do |dirname|
      Dir.glob("#{sensu_plugins_directory}/#{dirname}/**/*").each do |name|
        new_file_name = "#{node['sensu']['directory']}/#{dirname}/#{File.basename name}"
        File.symlink name, new_file_name unless File.symlink?(new_file_name)
      end
    end
  end
end
