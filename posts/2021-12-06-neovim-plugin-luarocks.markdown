---
title: Dependency specification for neovim plugins
tags: plugins, neovim
author: Matt
---




# Debug on nix

Debugging can be tricky on nix.

You don't have to clone the repository (replace `./contrib` with `github:neovim/neovim/contrib`)

```
$ nix develop ./contrib#nvim-develop
% 
```
NB: `set titlestring=%{getpid().':'.getcwd()}`






References:

- [nixos wiki on neovim]
- [nixos doc to maintain your own neovim overlay]

