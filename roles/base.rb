name 'base'

run_list [
  'recipe[stack-base]',
  'recipe[stack-hosts]',
  'recipe[stack-users]',
  'role[sensu_client]'
]
