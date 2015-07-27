require File.expand_path('../support/helpers', __FILE__)

describe_recipe "logentries-rsyslog::default" do
  include Helpers::CookbookTest

  let(:s3cmd_version) { assert_sh("s3cmd --version") }

  it "installs s3cmd" do
    s3cmd_version.must_include 's3cmd version'
  end

  it "creates /home/vagrant/.s3cfg" do
    file("/home/vagrant/.s3cfg").must_exist
    file("/home/vagrant/.s3cfg").must_include 'access_key = myaccesskey'
    file("/home/vagrant/.s3cfg").must_include 'secret_key = mysecretkey'
    file("/home/vagrant/.s3cfg").must_include 'bucket_location = EU'
  end
end