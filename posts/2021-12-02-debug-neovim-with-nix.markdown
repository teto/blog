---
title: Using neovim on nixos
tags: nixos, neovim
author: Matt
---

Here are some tips related to developing/debugging a program on nixpkgs, more specifically [neovim].

I have a hybrid nix/imperative setup to maintain a robust core of features
(managed in nix via home-manager)
while being able to easily test/iterate new plugins (vim-plug/packer).

I would like to mention that it is possible to maintain an out-of-nixpkgs list
of neovim plugins via [nixos-doc].


# Debug on nix

Debugging can be tricky on nix. Programs are built in a sandbox and when
compiled with debug symbols, once opening a backtrace, paths reference
non-existing files such as `/build/src/`
<!-- TODO copy a valid example -->

Clone the repository in 'REPO' since we need the source code.
<!-- see if hakyll supports notes -->
Note: when using nix flakes, you dont have to clone the repo to reproduce the crash, nix can handle it if you replace the flake reference `./contrib` by `github:neovim/neovim?dir=contrib`, e.g., `nix run github:neovim/neovim?dir=contrib#nvim-develop`

```
$ nix develop ./contrib#nvim-develop
```

Then reproduce yor crash. Once the process has crashed

Note: As I usually have several neovim instances running concurrently, I like to
see the process ID in the title bar: `set titlestring=%{getpid().':'.getcwd()}`


Open your backtrace with gdb as you are used to, for instance with:
`coredumpctl debug`

If you check out the backtrace, you get:
```
TODO
```
Trying to look at the source code  is not helpful (yet):
```
```

Happily, gdb can replace prefixes of path with your suggestion:

```sh
set substitute-path /build/ ~/neovim
```



References:

- [nixos wiki on neovim]
- [nixos doc to maintain your own neovim overlay]

neovim: www.neovim.io
