graphite_hostname = 'stats'

include_attribute 'graphite'
include_attribute 'graphite::carbon_aggregator'
include_attribute 'statsd'
include_attribute 'collectd'

override['graphite']['password']                      = 'verysecret' # CHANGE THIS
override['graphite']['url']                           = graphite_hostname
override['graphite']['storage_dir']                   = '/mnt/data-store/graphite/storage'

# must re-override existing database path because we changed storage_dir
override['graphite']['web']['database']['NAME']       = node['graphite']['storage_dir'] + '/graphite.db'
override['graphite']['web']['admin_email']            = 'devopen@the-startup-stack.com'
override['graphite']['carbon']['enable_udp_listener'] = "True"

# set fixed versions for graphite packages
graphite_version                                                = '0.9.12'  # ruby variable, not chef!
override['graphite']['package_names']['whisper']['source']      = "https://codeload.github.com/graphite-project/whisper/zip/#{graphite_version}"
override['graphite']['package_names']['carbon']['source']       = "https://codeload.github.com/graphite-project/carbon/zip/#{graphite_version}"
override['graphite']['package_names']['graphite-web']['source'] = "https://codeload.github.com/graphite-project/graphite-web/zip/#{graphite_version}"

override['graphite']['apache']['basic_auth']['enabled'] = true
override['graphite']['apache']['basic_auth']['user']    = Chef::DataBagItem.load('graphite', 'credentials')['user']
override['graphite']['apache']['basic_auth']['pass']    = Chef::DataBagItem.load('graphite', 'credentials')['password']

override['graphite']['storage_aggregation'] = [
  {
    'name' => 'default_average',
    'pattern' => /.*/,
    'xFilesFactor' => '0.6',
    'aggregationMethod' => 'average'
  },
  {
    'name' => 'all_min',
    'pattern' => '\.min$',
    'xFilesFactor' => '0.1',
    'aggregationMethod' => 'min'
  },
  {
    'name' => 'all_max',
    'pattern' => '\.max$',
    'xFilesFactor' => '0.1',
    'aggregationMethod' => 'max'
  },
  {
    'name' => 'all_sum',
    'pattern' => '\.sum$',
    'xFilesFactor' => '0.1',
    'aggregationMethod' => 'sum'
  },
  {
    'name' => 'count',
    'pattern' => '\.count$',
    'xFilesFactor' => '0',
    'aggregationMethod' => 'sum'
  }
]

override['graphite']['storage_schemas'] = [
  {
    'name' => 'carbon',
    'pattern' => /^carbon\./,
    'retentions' => '1m:10d'
  },
  {
    'name' => 'collectd',
    'pattern' => /^collectd\./,
    'retentions' => '1m:30d'
  },
  {
    'name' => 'stats',
    'pattern' => /^stats\./,
    'retentions' => '10s:30d'
  },
  {
    'name' => 'sensu',
    'pattern' => /^sensu\./,
    'retentions' => '1m:30d'
  },
  {
    'name' => 'default',
    'pattern' => /.*/,
    'retentions' => '60s:1d'
  }
  # {
  #   'name' => 'everything_30s7d_15m1m',
  #   'match-all' => true,
  #   'retentions' => '30s:7d,15m:1m'
  # }
]

# node.default['graphite']['aggregation_rules'] = [
#   {
#     'output_template' => '<env>.applications.<app>.all.requests',
#     'frequency' => '60',
#     'method' => 'sum',
#     'input_pattern' => '<env>.applications.<app>.*.requests'
#   },
#   {
#     'output_template' => '<env>.applications.<app>.all.latency',
#     'frequency' => '60',
#     'method' => 'sum',
#     'input_pattern' => '<env>.applications.<app>.*.latency'
#   },
# ]

override['graphite']['graph_templates'] = [
  {
    'name' => 'default',
    'background' => 'black',
    'foreground' => 'white',
    'majorLine' => 'white',
    'minorLine' => 'grey',
    'lineColors' => 'blue,green,red,purple,brown,yellow,aqua,grey,magenta,pink,gold,rose',
    'fontName' => 'Sans',
    'fontSize' => '10',
    'fontBold' => 'False',
    'fontItalic' => 'False'
  },
  {
    'name' => 'solarized-dark',
    'background' => '#002b36',
    'foreground' => '#839496',
    'majorLine' => '#fdf6e3',
    'minorLine' => '#eee8d5',
    'lineColors' => '#268bd2,#859900,#dc322f,#d33682,#db4b16,#b58900,#2aa198,#6c71c4',
    'fontName' => 'Sans',
    'fontSize' => '10',
    'fontBold' => 'False',
    'fontItalic' => 'False',
  },
  {
    'name' => 'solarized-light',
    'background' => '#fdf6e3',
    'foreground' => '#657b83',
    'majorLine' => '#073642',
    'minorLine' => '#586e75',
    'lineColors' => '#268bd2,#859900,#dc322f,#d33682,#db4b16,#b58900,#2aa198,#6c71c4',
    'fontName' => 'Sans',
    'fontSize' => '10',
    'fontBold' => 'False',
    'fontItalic' => 'False',
  },
  {
    'name' => 'noc',
    'background' => 'black',
    'foreground' => 'white',
    'majorLine' => 'white',
    'minorLine' => 'grey',
    'lineColors' => 'blue,green,red,yellow,purple,brown,aqua,grey,magenta,pink,gold,rose',
    'fontName' => 'Sans',
    'fontSize' => '10',
    'fontBold' => 'False',
    'fontItalic' => 'False',
  },
  {
    'name' => 'plain',
    'background' => 'white',
    'foreground' => 'black',
    'minorLine' => 'grey',
    'majorLine' => 'rose',
    'lineColors' => 'blue,green,red,yellow,purple,brown,aqua,grey,magenta,pink,gold,rose',
  },
  {
    'name' => 'summary',
    'background' => 'black',
    'lineColors' => '#6666ff, #66ff66, #ff6666',
  },
  {
    'name' => 'alphas',
    'background' => 'white',
    'foreground' => 'black',
    'majorLine' => 'grey',
    'minorLine' => 'rose',
    'lineColors' => '00ff00aa,ff000077,00337799',
  }
]

override["statsd"]["graphite_host"] = '127.0.0.1'
# override["statsd"]["graphite_port"] = ''
# override["statsd"]["graphite_role"] = ''

override["collectd"]["version"] = '5.4.0'
override["collectd"]["url"] = 'https://s3.amazonaws.com/collectd-5.4.0/collectd-5.4.0.tar.gz'
override["collectd"]["checksum"] = 'c434548789d407b00f15c361305766ba4e36f92ccf2ec98d604aab2a46005239'
override["collectd"]["graphite_role"] = 'stats_server'
override['collectd']['plugins']["syslog"] = { "config" => { "LogLevel" => "Info" } }
override['collectd']['plugins']["disk"]   = {}
override['collectd']['plugins']["swap"]      = { }
override['collectd']['plugins']["memory"]    = { }
override['collectd']['plugins']["cpu"]       = { }
override['collectd']['plugins']["interface"] = {"config" => { "Interface" => "lo", "IgnoreSelected" => true } }
override['collectd']['plugins']["df"] = { "config" => {
                                        "ReportReserved" => false,
                                        "FSType" => [ "proc", "sysfs", "fusectl", "debugfs", "devtmpfs", "devpts", "tmpfs" ],
                                        "IgnoreSelected" => true
                                      } }
override['collectd']['plugins']["write_graphite"] = { "config" => { "Host" => graphite_hostname, "Prefix" => "collectd." } }
