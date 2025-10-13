# Dotfiles configuration

Following the [example](https://news.ycombinator.com/item?id=11071754) provided by StreakyCobra, I'm managing my config using a bare github repo that allows for all tracked files to be version controlled while ignoring untracked files in the `$HOME` dir.

They key part to all of this is the `config` alias

```sh
alias config='/usr/bin/git --git-dir=$HOME/.myconf/ --work-tree=$HOME'
config config status.showUntrackedFiles no
```

When copying to a new machine the alias needs to be set again (probably easiest to just add to the `.zshrc` or `.bashrc`) 

```sh
git clone --separate-git-dir=$HOME/.cfg /path/to/repo $HOME/cfg-tmp
rm -r ~/cfg-tmp
alias config='/usr/bin/git --git-dir=$HOME/.myconf/ --work-tree=$HOME'
config config status.showUntrackedFiles no
```
