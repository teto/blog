---
title: Automatic install of neovim plugin dependencies (2)
tags: plugins, neovim
author: Matt
---


See [part 1](./posts/2021-09-17-neovim-plugin-luarocks.markdown) for the long
motivational speech. The short version is: let's leverage rockspec and the
luarocks infrastructure to specify/autoinstall neovim plugin dependencies.

In [part 1][part 1] presented a vision of this for the package manager nix. The good
news is that I finished adding this to nixpkgs (the collection of packages used
by the package manager nix).  

I want to detail how I did it with the hope my experience inspires other package managers such as 
packer.nvim. Later on I list a few hurdles that I feel could be solved with a
community effort.

The [first part][#lua-plugin-packaging-in-nixpkgs] details the vim/lua [nix][nix] workflow while the second part
presents how packer.nvim could achieve autodiscovery of plugin dependencies and
its install. If you don't know about nix


# lua plugin packaging in nixpkgs

The [nixpkgs manual](https://nixos.org/manual/nixpkgs/stable/#users-guide-to-lua-infrastructure) explains
how to update the lua package set.
To sum it up, [this script](https://github.com/NixOS/nixpkgs/blob/master/maintainers/scripts/update-luarocks-packages)
looks for packages to update in a [.csv
file](https://github.com/NixOS/nixpkgs/blob/master/maintainers/scripts/luarocks-packages.csv).
In theory, we could import the list of packages referenced by luarocks but working with a list of manually selected packages
allow to deal with issues more sensibly until our scripts get more robust.
The script calls [our fork of luarocks][luarocks-nix] which adds a `nix` command
to luarocks to convert a [rockspec][rockspec-format] to a nix derivation:

For instance:
```
$ luarocks nix plenary.nvim
{ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua, luassert
}:
buildLuarocksPackage {
  pname = "plenary.nvim";
  version = "scm-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/plenary.nvim-scm-1.rockspec";
    sha256 = "08kv1s66zhl9amzy9gx3101854ig992kl1gzzr51sx3szr43bx3x";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/nvim-lua/plenary.nvim",
  "rev": "968a4b9afec0c633bc369662e78f8c5db0eba249",
  "date": "2022-06-12T21:41:00+02:00",
  "path": "/nix/store/z2mzxda6fr97axyjfb8117l7wlb47wwb-plenary.nvim",
  "sha256": "05x9hnz960ljcb2psqycxgdmh99j36y16vbb9l92wjv5szkz37x5",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua luassert ];

  meta = {
    homepage = "http://github.com/nvim-lua/plenary.nvim";
    description = "lua functions you don't want to write ";
    license.fullName = "MIT/X11";
  };
}
```
The results of running this command per-package are aggregated at https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/lua-modules/generated-packages.nix .
As usual with generated nix packages, some packages need more care than others
and need some tweaks to work. These tweaks live in [overrides.nix](https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/lua-modules/overrides.nix) that 
is stable across the package updates (apart for luv whose buildsystem keep changing).

There is a similar process for vim: [vim generated file](https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/vim/plugins/generated.nix) 
and [its overrides](https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/vim/plugins/overrides.nix).
The vim packaging workflow is simpler but it requires setting plugin
dependencies by hand. Metadata retreival is also limited by github's api.
Because nixos is one of a kind, it can also be reassuring to be able to run the
package test suite. For these reasons I've been pushing to be able to install
vim plugins as luarocks packages. When generating the vim packageset, the vim updater now
checks whether a homonym of the package lives in the lua package set. If yes,
the updater calls build [buildNeovimPluginFrom2Nix](https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/neovim/build-neovim-plugin.nix) instead of 
[buildVimPluginFrom2Nix](https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/vim/plugins/build-vim-plugin.nix), ie., nix does a __flat install__ (i.e., luarocks installs in a `lua` folder instead  of the nested share/lua/5.X/... folders).




# how to discover dependencies in packer ?


We will need to tweak luarocks settings, this is doable in a file referenced by the environment variable
`LUAROCKS_CONFIG`.
By default luarocks installs rockspecs in "share/lua/VERSION" but we want to install it in a `lua` folder:
```
lua_modules_path = "lua"
```

The second difficulty is for copying the `copy_directories` component of the rockspec
(the viml scripts for instance): luarocks doesn't allow to configure this path.
A postprocessing step can be copy or move these files to the root of the
installation folder:
`cp -rfv "$TARGET_DIR/$rocksSubdir/$pname/$version/." "$TARGET_DIR"`.

And this is it for the packaging aspect !

## 
Here I have listed a few points that could be worth improving:

- Specifying the source files can be painful: see [plenary rockspec](https://github.com/nvim-lua/plenary.nvim/blob/968a4b9afec0c633bc369662e78f8c5db0eba249/plenary.nvim-scm-1.rockspec#L34) to convince yourself. Turns out everything under the 'lua' folder is automatically globbed for the 'builtin' module type so in this peculiar case, we could have just written nothing. A luarocks `glob` function could be useful otherwise.
- A config entry to specify where to install the `copy_directories` component of the
  rockspec would remove our postprocessing oneliner.
- it is a more generic problem but the lack of support for `pkg-config` is
  annoying on systems like nixos
- we could ask for a "neovim" module type if the rockspec approach really takes off, that




[part 1]: ./posts/2021-09-17-neovim-plugin-luarocks.markdown
[support]: https://luarocks.org/labels/neovim
[luarocks-nix]: https://github.com/nix-community/luarocks-nix
rockspec-format: https://github.com/luarocks/luarocks/wiki/Rockspec-format
nix: www.nixos.org