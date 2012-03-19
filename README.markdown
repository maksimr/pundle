pundle.js
============

[Pundle] is short from **P**entadactylb*undle* and is a simple plugin manager


##How it use

1. Setup Pundle

```
$ git clone https://github.com/maksimr/pundle.git ~/.pentadactyl/plugin/pundle
 ```

2. Configure pundles:

Sample `.pentadactylrc`:

```vim
 " set bundle
 Bundle maksimr/beautiful-translate
```

Commands


```vim
 " :BundleInstall(!)          - install(update) bundles
 " :BundleRemove bundleName   - remove bundle
```


Git Installation
------------

You must have git is installed on your system.
Then download this file and put it in pentadactyl's plugins or barrel folders

Windows

Define git on "Windows". You must download "Git" from http://git-scm.com/
and add in "Environment Variables" %PATH%
('System Properties' 'Environment Variables' 'System variables' 'Path') path to git
example C:\Program Files\Git\bin and restart computer.

(version: 0.1) maksimr
