name 'base'

run_list [
  'recipe[stack-base]',
  'recipe[stack-hosts]',
]
