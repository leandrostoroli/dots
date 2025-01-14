-- rustc 1.59.0-nightly (acbe4443c 2021-12-02)
-- rust-analyzer 49b097097 2021-12-06 dev

-- treesitter folding
vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt_local.foldnestmax = 3
vim.opt_local.foldlevel = 1

-- @TODOUA: kill or refactor this exec block
vim.api.nvim_exec(
  [[
setlocal shortmess+=c
" wrap selection in Some(*)
vmap ,sm cSome(<c-r>"<esc>
" grep for functions and move function sig to top of window
nnoremap <silent><buffer>,f :Rg<Space>fn<Space><CR>
" surround (W)ord with angle brackets
nmap <localleader>ab ysiW>

" rustfmt/vim-rust settings
let g:rustfmt_autosave = 1

" local mappings
noremap <silent><localleader>cb :Cbuild<cr>
noremap <silent><localleader>cc :Ccheck<cr>
noremap <silent><localleader>ct :Ctest<cr>
noremap <silent><localleader>cr :Crun<cr>

]],
  false
)

-- snippets dir- vsnip. Need to try LuaSnip
vim.b.vsnip_snippet_dir = vim.fn.expand "~/.config/nvim/snippets/"

-- rust-tools --
-- Command:
-- RustRunnables
vim.api.nvim_buf_set_keymap(
  0,
  "n",
  "<space>rr",
  [[<cmd>lua require('rust-tools.runnables').runnables()<cr>
]],
  { noremap = true, silent = true }
)

-- @TODOUA: check to see if rust-tools selects is handling close (nil)
-- Meantime, close runnable & debuggable pickers manually :close!

-- Lsp maps
vim.api.nvim_buf_set_keymap(
  0,
  "n",
  "<localleader>=",
  [[<cmd>lua vim.lsp.buf.formatting()<CR>
]],
  { noremap = true, silent = true }
)

vim.api.nvim_buf_set_keymap(
  0,
  "n",
  "g0",
  [[<cmd>lua vim.lsp.buf.document_symbol()<CR>]],
  { noremap = true, silent = true }
)

vim.api.nvim_buf_set_keymap(
  0,
  "n",
  "gW",
  [[<cmd>lua vim.lsp.buf.workspace_symbol()<CR>]],
  { noremap = true, silent = true }
)

vim.api.nvim_buf_set_keymap(
  0,
  "n",
  "gr",
  [[<cmd>lua require'telescope.builtin'.lsp_references()<CR>
]],
  { noremap = true, silent = true }
)

vim.api.nvim_buf_set_keymap(
  0,
  "n",
  "gD",
  "<cmd>lua vim.lsp.buf.implementation()<CR>",
  { noremap = true, silent = true }
)

vim.api.nvim_buf_set_keymap(0, "n", "gd", [[<cmd>lua vim.lsp.buf.declaration()<CR>]], {
  noremap = true,
  silent = true,
})

vim.api.nvim_buf_set_keymap(0, "n", "K", [[<cmd>lua vim.lsp.buf.hover()<CR>]], { noremap = true, silent = true })

vim.api.nvim_buf_set_keymap(
  0,
  "n",
  "<c-]>",
  [[<cmd>lua require'telescope.builtin'.lsp_definitions()<CR>
]],
  { noremap = true, silent = true }
)

vim.api.nvim_buf_set_keymap(
  0,
  "n",
  "<c-k>",
  [[<cmd>lua vim.lsp.buf.signature_help()<CR>]],
  { noremap = true, silent = true }
)

vim.api.nvim_buf_set_keymap(0, "n", "1gD", [[<cmd>lua vim.lsp.buf.definition()<CR>]], {
  noremap = true,
  silent = true,
})

vim.api.nvim_buf_set_keymap(0, "n", "ga", [[<cmd>lua vim.lsp.buf.code_action()<CR>]], {
  noremap = true,
  silent = true,
})

-- Goto previous/next diagnostic warning/error
vim.api.nvim_buf_set_keymap(
  0,
  "n",
  "g[",
  [[<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>]],
  { noremap = true, silent = true }
)
vim.api.nvim_buf_set_keymap(
  0,
  "n",
  "g]",
  [[<cmd>lua vim.lsp.diagnostic.goto_next()<CR>]],
  { noremap = true, silent = true }
)
-- end of LSP buf maps

-- define LSP signs
vim.fn.sign_define("DiagnosticSignHint", {
  text = "",
  texthl = "DiagnosticSignHint",
})

vim.fn.sign_define("DiagnosticSignWarn", {
  text = "",
  texthl = "DiagnosticSignWarn",
})

vim.fn.sign_define("DiagnosticSignError", {
  text = "",
  texthl = "DiagnosticSignError",
})

-- Show diagnostic popup on cursor hold
vim.api.nvim_exec(
  [[
augroup RustLineDiagnostics
   autocmd!
   autocmd CursorHold * lua vim.diagnostic.open_float(0, {focusable = false, scope = 'line'})
augroup end
]],
  false
)

-- Setup cmp source buffer configuration
local cmp = require "cmp"
cmp.setup.buffer {
  sources = {
    { name = "nvim_lsp" },
    { name = "treesitter" },
    { name = "vsnip" },
    {
      name = "buffer",
      option = {
        get_bufnrs = function()
          return vim.api.nvim_list_bufs()
        end,
      },
    },
    { name = "path" },
  },
}

-- ** Letting rust-tools handle the below:
-- Get error at first to to RA loading and: https://github.com/neovim/neovim/pull/15926
-- @TODOUA: 11-Oct-2021 ← revist
-- Enable type inlay hints
-- vim.api.nvim_exec(
--   [[
-- augroup RustInlayHints
--   autocmd!
--   autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost * :lua require'lsp_extensions'.inlay_hints{ prefix = '=>', highlight = "Comment", enabled = {"TypeHint", "ChainingHint", "ParameterHint"} }
-- augroup end
-- ]],
--   false
-- )
