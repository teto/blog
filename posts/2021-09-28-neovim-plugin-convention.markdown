---
title: Automation opportunities in the neovim plugin ecosystem
tags: plugins, neovim
author: Matt
draft: true
---

This post is written with the intention of serving as a concrete starting point
for a discussion on how plugins can expose their functionalities/settings to
either neovim or a third party.

NB: if you are looking for the exposure of other metadata like package
dependencies,  let me redirect you to
[previous post](./2021-09-17-neovim-plugin-luarocks.markdown),


Why do you ask ?
- to be able to discover/get/set plugin settings across a single interface.
- ...which in turn could make the creation of a neovim configurator GUIs more
  tractable:
  	TODO (insert a mockup "what `nvim-config` could have been)
- I would like that 

A similar example in neovim I am proud of is how neovim options are exposed and can be
fuzzy-searched via `:Telescope vim_options` (though I preferred how this
[outdated plugin](nvim-palette) allowed to fuzzy-search on the options description). Lookup `:nvim_get_option_info` and src/nvim/options.lua if you are curious).

Before starting, let's sum up some design goals as well as the non goals:
- THIS WILL NOT BE MANDATORY ! vim/neovim strives on freedom let's not add
  what justin calls bureaucracy
- similarly it does not need to expose everything from the plugin. It's hard to
  add automation when a plugin accepts functions as settings, not exposing them 
  doesn't mean they don't exist, it just prolongs the status-quo
- such convention follows the chicken & egg issue: no one will build automation
  tools if no plugins support it so we need enough believers to bootstrap the
  project. This also implies to keep the initial design simple, while having a clear enough idea of the future extensions not to break the format. We may need a tool to validate the format

# 

I am no plugin author so I may lack the proper perspective, yet I've taken on to
provide this starting point (nothing official !), to kick off the discussion.

First off, the format choice, for the reasons listed by justin here, I think lua
is the least restricting choice: no external dependencies. etc.

The plugin ecosystem indicates a striving lua trend (check github trends), and
fennel, teal plugins can generate lua. Lua is easy to generate too and in most
cases it will be created manually anyway.

```lua
{
	-- single increasing number to detect an outdated format
	-- if unsupported format
	version = 42,
	-- list of available colorschemes, can this be automated from colors ? 
	-- check telescope ?
	colorschemes = {
		"gruvbox-256",
		"gruvbox-trueguicolors"
	},

	-- 
	user_options = {
		type = "ro", -- readonly
	ro_ = {

	},

	-- expose mappings between a provider name and a possible value
	providers = {
		[" "] = "",
		["clipboard" = ""
	}
}
```
