---
title: Using neovim on nixos
tags: nixos, neovim
author: Matt
---

Here are some tips related to using/developing neovim with [nix].

I have a hybrid nix/imperative setup to maintain a robust core of features
(managed in nix via home-manager)
while being able to easily test/iterate new plugins (vim-plug/packer).

I would like to mention that it is possible to maintain an out-of-nixpkgs list
of neovim plugins via [nixos-doc].


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
