---
title: Automatic install of neovim plugin dependencies
tags: plugins, neovim
author: Matt
---




# Improve package management in neovim

Vim plugins used to be written in Vimscript, which lacked the ecosystem of a
more general language. As a consequence, plugins tended to be self-contained and
rarely referenced external plugins, thus limiting code reuse and
functionalities.

Neovim 0.5 has dramatically improved lua support and as a consequence, a rich
lua plugin ecosystem is born, including new (lua) package managers:
[packer.nvim](https://github.com/wbthomason/packer.nvim), [paq](https://github.com/savq/paq-nvim).

Plugins now rely on external (lua mostly) dependencies and now ask user to explicitly install these dependencies.
For instance in [neogit](https://github.com/TimUntersberger/neogit)'s readme,
the packer installation instructions mention the plenary.nvim dependency:
```lua
use { 'TimUntersberger/neogit', requires = 'nvim-lua/plenary.nvim' }
```

This has several drawbacks:
- not scalable: increase the number of plugins and you have users confused, what
  happens when the plugin updates its dependencies ? Remove some, add new ones,
  should the user track all these ?
- prevents automatic installation of plugins. With sublime or vscode, you can
  invoke a palette (ctrl+p) find a plugin and install it on the go. I would like
  to see something similar for neovim.

Installing and configuring software can be hard but if we limit ourselves to lua
dependencies, we could rely on luarocks, a well established lua package manager
and its associated package format (rockspec files, format described 
[here](https://github.com/luarocks/luarocks/wiki/Rockspec-format), example at) to share metadata about lua plugins: name,
description, etc. and dependencies !

Packer has some support for luarocks through the use of `use_rocks` but looking
at the tracker, there are comments about improving this to use plugin rockspecs
directly as well as improving the implementation, take for instance
[this packer issue](https://github.com/wbthomason/packer.nvim/issues/526).

I work on adding this support natively to [nixpkgs](https://nixos.org/) which
shouldn't be long now. In order to test my implementation, I've contributed a
few rockspecs to lua plugins I use at https://luarocks.org/labels/neovim.

This vision relies on the presence of *.rockspec in plugin repositories.
So as a plugin maintainer, what can you do ?

# For lua plugin maintainers

As a maintainer, you've already got your hands full so let's sum up here some
information to get you started and not waste time.

1. Copy for instance this rockspec https://github.com/nvim-lua/plenary.nvim/blob/master/plenary.nvim-scm-1.rockspec in your repo
, update the different fields to match your project and carefully rename the file; luarocks fails if the file prefix doesn't match the project name

and that's it !

Now if your plugin is a 'core' plugin upon which others plugins are likely to
build, then you should register your plugin on www.luarocks.org so that other
plugins can reference it by its name. You can register your plugin directly via the website 
or use the CLI with `luarocks upload`.
Note that `scm` ("source control", i.e., the development version) versions are not 
listed in the global manifest.

As an extra step, you could setup a job on your CI to check that the rockspec
keeps working, e.g. `luarocks install ./my-project-version.rockspec`
