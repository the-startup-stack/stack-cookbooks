name "cluster_member"

run_list [
  "recipe[stack-marathon::member]"
]
