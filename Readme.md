Realiaser
====================

Realiaser is a game which helps you memorize your shell aliases.

If you are like me, you have a lot of shell aliases but don't want to spend much time memorizing them. This gem helps remind you that you have defined an alias by telling you everytime you write a command where you should have used an alias.

I defined the point system to work as follows. +1 pt for every command executed which was executed properly. -50 for every time I forget to use an alias.

This is a pretty small library, only a two hour hack, but I've already started using more of my aliases because of the positive feedback loop it provides.

Features
---------------------

* Tells if you your last command should have used an alias.
* Keeps track of your score.
* Keeps track of your last successful command and unsuccessful command.
* Doesn't modify your ENV in any way.

Installation
---------------------

There are two parts to the installation. The library and integrating it with your shell.

```script
# install the gem (sudo is optional)
sudo gem install realiaser

# the ruby script needs to be able to access aliases defined in the shell conf
alias > ~/.alias.cache
```

This is the hard part. You need to change your right shell prompt.

```
function last_command() {
  echo `history | tail -1 | cut -d ' ' -f 3-20 | realiaser`
}

RPROMPT='%{$fg[$NCOLOR]%}%p $(last_command)%{$reset_color%}'
````

Check the options on your machine for "history". This configuration is for ZSH and needs slight ajusting for Bash or other configuartions

I have new aliases and it doesn't notice them.
---------------------

The ruby script can't see aliases in the environment.

```script
alias > ~/.alias.cache
```


Update
---------------------

```script
gem update realiaser
````

Questions
---------------------

Q: Isn't this going to slow down my CLI?

A: Running Ruby on every command isn't ideal, but it turns out that it didn't slow me down at all.

```
time history -1 | cut -d ' ' -f 3-20 | /usr/bin/ruby -I~/Development/realiaser/lib ~/Development/realiaser/bin/realiaser                                          25

# Output
25

# First command
history -1  0.00s user 0.00s system 24% cpu 0.003 total

# Second command
cut -d ' ' -f 3-20  0.00s user 0.00s system 81% cpu 0.004 total

# Third command
/usr/bin/ruby -I~/Development/realiaser/lib   0.04s user 0.01s system 74% cpu 0.066 total
```
