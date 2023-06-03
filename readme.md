to cd to directories more quickly

## prerequisites
* vifm 0.13
* tmux
* fd
* fzf
* [zd](https://github.com/haolian9/zd) # it's my baby

## usage
* `vifm --plugins-dir=/path/to/this/repo`
* `:fd` # equals to shell `cd $(fd -td | fzf)`
* `:zd` # equals to shell `cd $(zd list | fzf)`
