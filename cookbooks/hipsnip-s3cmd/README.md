Description [![Build Status](https://travis-ci.org/hipsnip-cookbooks/s3cmd.png)](https://travis-ci.org/hipsnip-cookbooks/s3cmd)
===========
A simple recipe for installing the s3cmd tool using the default package manager on the system.
It then creates configuration files for the list of users defined in the attributes (see below).


Requirements
============
A system with the "s3cmd" package available. Tested on Ubuntu 12.04 with Chef `10.18` and `11.4`.
Assumed to work on other Debian-based distros as well.


Attributes
==========

    ['s3cmd']['users'] = The list of Users to create the ".s3cfg" file for (defaults to ["root"])
    ['s3cmd']['bucket_location'] = The S3 zone for the buckets - defaults to "EU"
    ['s3cmd']['access_key'] = AWS access key
    ['s3cmd']['secret_key'] = AWS secret key

Users that are listed, but not present on the system will be ignored.


Usage
=====
Make sure you set your credentials in `['s3cmd']['access_key']` and `['s3cmd']['secret_key']`, and then include `hipsnip-s3cmd::default`
in your run list.


Development
============
Please refer to the Readme [here](https://github.com/hipsnip-cookbooks/cookbook-development/blob/master/README.md)


License and Author
==================

Author:: Adam Borocz ([on GitHub](https://github.com/motns))

Copyright:: 2013, HipSnip Ltd.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
