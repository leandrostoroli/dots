-- Always on bleeding edge Neovim from https://git.io/NeovimHEAD --
-- NVIM v0.7.0-dev+751-g67bb01ae2

-- Plugins
require "joel.plugins"

-- config/setup
require "joel.config"

-- Telescope 🔭
require "joel.telescope"

-- mappings (telescope-related maps loaded via telescope mod)
require "joel.mappings"

-- settings(options)
require "joel.settings"

-- globals like P() & DN()
require "joel.globals"
