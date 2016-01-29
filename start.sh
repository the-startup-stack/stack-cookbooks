tmux new-session -d -s startupstack
tmux split-window -t startupstack:1 -v
tmux rename-window main
tmux send-keys -t startupstack:1.1 "vim ." "Enter"
tmux send-keys -t startupstack:1.2 "echo 'started'" "Enter"
tmux select-window -t startupstack:1
tmux attach -t startupstack
