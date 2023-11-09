# ZSH Apprise

## Purpose

This is a ZSH plugin that is used to send shell command completion notifications via [Apprise](https://github.com/caronc/apprise).

## Requirements
- ZSH shell
- [ZSH Execute After Command](https://github.com/jasonlyle88/zsh-apprise) Plugin

## Installation

### Manual installation
```shell
git clone 'https://github.com/jasonlyle88/zsh-apprise' "${XDG_CONFIG_HOME:-${HOME}}/zsh-apprise"
echo 'source "${XDG_CONFIG_HOME:-${HOME}}/zsh-apprise/zsh-apprise.plugin.zsh"' >> "${HOME}/.zshrc"
source "${XDG_CONFIG_HOME:-${HOME}}/zsh-apprise/zsh-apprise.plugin.zsh"
```

### Installation with package managers

#### [Antidote](https://getantidote.github.io/)
Add `jasonlyle88/zsh-apprise` to your plugins file (default is `~/.zsh_plugins.txt`)

#### [Oh-My-Zsh](https://ohmyz.sh/)
```shell
git clone 'https://github.com/jasonlyle88/zsh-apprise' "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-apprise"
omz plugin enable zsh-apprise
```

#### Others
This should be compatible with other ZSH frameworks/package managers, but I have not tested them. If you have tested this plugin with another package manager, feel free to create a merge request and add the instructions here!

## Configuration
This plugin uses ZSH's built in zstyle for storing settings. Below is a list of the settings and their initial values:

```shell
TODO
```

## Inspiration
I found [Federico Marzocchi's ZSH Notify](https://github.com/marzocchi/zsh-notify) ZSH plugin and was using it for a little bit. I wanted to do things a little different, and so this project was created. Thanks to Federico Marzocchi for his work on ZSH Notify!
