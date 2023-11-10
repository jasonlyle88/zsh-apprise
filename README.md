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
# Whether or not to always send a notification on a command failure, regardless of command duration, window focus, and ignore regular expression
# Defaults to yes
# Valid values: ZSTYLE boolean values
zstyle ':apprise:user-setting:*'    'notify-always-on-failure'                  'yes'

# Whether or not to notifiy when the window is focused
# Defaults to no
# Valid values: ZSTYLE boolean values
zstyle ':apprise:user-setting:*'    'notify-only-unfocused'                     'no'

# If notify-only-unfocused is set to "yes", this controls wheter or not to notify when the focus of the window is unknown or unable to be determined
# Defaults to yes
# Valid values: ZSTYLE boolean values
zstyle ':apprise:user-setting:*'    'notify-unknown-focus'                      'yes'

# The minimum number of seconds a command needs to run before a notification is sent for the command
# Defaults to 30 seconds
# Valid values: A number greater than 0
zstyle ':apprise:user-setting:*'    'notify-command-minimum-seconds'            30

# A regular expression that is evaluated against the expanded command. If the regular expression matches the command, then no notification is given.
# Defaults to nothing ignored
# Valid values: A valid regular expression
# Example: 'ssh|sleep|tmux|screen|emacs|vim|vi|nano|bat|less|more'
zstyle ':apprise:user-setting:*'    'notify-command-ignore-regex'               ''

# A tag to be provided to Apprise to determine the notifiers to use for the notification. In order for this to work, a tag must be configured with Apprise. NOTE: this can be used on its own or in conjunction with notify-apprise-notifier.
# Defaults to no tag
# Example: 'shell-notify'
zstyle ':apprise:user-setting:*'    'notify-apprise-tag'                        ''

# A notifier to be provided to Apprise for notification. NOTE: this can be used on its own or in conjunction with notify-apprise-tag.
# Defaults to no notifier
# Example: 'macosx://_/?sound=default'
zstyle ':apprise:user-setting:*'    'notify-apprise-notifier'                   ''

# A function that recieves the 6 parameters from the zsh-execute-after-command plugin and outputs the title that should be used for the notification.
# Defaults to the notification title generation function provided with this plugin
zstyle ':apprise:user-setting:*'    'notification-title-generation-function'    'za-generate-notification-title'

# A function that recieves the 6 parameters from the zsh-execute-after-command plugin and outputs the body that should be used for the notification.
# Defaults to the notification body generation function provided with this plugin
zstyle ':apprise:user-setting:*'    'notification-body-generation-function'     'za-generate-notification-body'
```

## Inspiration
I found [Federico Marzocchi's ZSH Notify](https://github.com/marzocchi/zsh-notify) ZSH plugin and was using it for a little bit. I wanted to do things a little different, and so this project was created. Thanks to Federico Marzocchi for his work on ZSH Notify!
