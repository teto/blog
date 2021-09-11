---
title: Generate a user Vim plugin overlay in nixpkgs
tags: nixpkgs, neovim
author: Matt
---

nixpkgs contains a [list of 838 plugins][vim-plugin-names] as of this date.
Regardless of this modest number, when trying out work-in-progress modules (or
as it happened test modules for neovim X when X was not released yet).

I would like to mention that it is possible to maintain an out-of-nixpkgs list
of neovim plugins via [nixos-doc].


You can use the updater script to generate basic packages out of a custom vim
plugin list:
`
pkgs/misc/vim-plugins/update.py -i vim-plugin-names -o generated.nix --no-commit
`
with the content of vim-plugin-names be like:
```
pwntester/octo.nvim
tjdevries/astronauta.nvim@main
```
You can then reference the generated vim overlay by:
```nix
let
	myVimPlugins = pkgs.vimPlugins.extend (
	(pkgs.callPackage ./generated.nix {})
	);
in
	pkgs.neovim.override {
		configure = {
			packages.myPlugins = with pkgs.vimPlugins; {
				start = [
					myVimPlugins.octo-nvim
				];
			};
		};
	}

```


vim-plugin-names: vim-plugin-names
