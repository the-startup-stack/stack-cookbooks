# Stack Logger

![The Startup Stack](http://assets.avi.io/logo-black.png)


`stack-logger` is part of [the-startup-stack](http://the-startup-stack.com).

This cookbook will install a complete ELK stack based on docker.

## What it includes?

### Raid

RAID level disk is included in this cookbook so you can get more storage space
for your logs.

## Docker

This will install and configure the docker service so all images can be pulled
from the Docker registry.

## Settings

### Data Bags

Couple of data bags included to set up the cookbook

* `aws` `main` for AWS
* `docker` `credentials` for docker. that includes `username`, `password` and
  `email`

### Attributes

```
override['logger']['disk_count']  = 5
override['logger']['disk_size']   = 1025
override['logger']['raid_level']  = 10
override['logger']['disk_piops']  = 3000
override['logger']['mount_point'] = '/mnt'
override['logger']['docker_repo'] = 'the-startup-stack'
```

## License

Copyright 2015, The Startup Stack

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## Authors

* Avi Tzurel [@kensodev](http://twitter.com/kensodev) [KensoDev github](http://github.com/kensodev)

## Issues

[https://github.com/the-startup-stack/stack-cookbooks/issues](https://github.com/the-startup-stack/stack-cookbooks/issues)
