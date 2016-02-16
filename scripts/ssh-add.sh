ssh-add -D
ssh-add -k
find site-cookbooks -name private_key | grep $1 | xargs ssh-add