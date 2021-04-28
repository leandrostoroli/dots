set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
" source ~/.vimrc :-(
set nu
set rnu
set hidden
set completeopt=menu,menuone,preview,noselect,noinsert
set dictionary+=/usr/share/dict/words
set wildignore+=*/node_modules/*,*/coverage/*
set incsearch
set ignorecase
set smartcase
set ts=2
set sw=2
set guicursor=
set clipboard=unnamedplus
set noshowcmd
set splitbelow
set splitright
set updatetime=2500
set undodir=~/.vim/undodir
set undofile
set inccommand=split
set scrolloff=1
set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
set grepformat=%f:%l:%c:%m,%f:%l:%m

" load local plugin if it's there, otherwise go git it.
" Comment this out or change it to point at your local plugins
function! s:local_plug(package_name) abort 
  if isdirectory(expand("~/vim-dev/plugins/" . a:package_name))
    execute "Plug '~/vim-dev/plugins/".a:package_name."'"
  else
    execute "Plug 'joelpalmer/" .a:package_name."'"
  endif
endfunction
" -- end local_plug()

call plug#begin('~/.vim/plugged')
" locals - comment out or replace with yours
call s:local_plug('ci_dark.vim')
call s:local_plug('fzf-gh.vim')
" add more locals --
" Plugins
Plug 'editorconfig/editorconfig-vim'
Plug 'dense-analysis/ale'
Plug 'windwp/nvim-autopairs'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-unimpaired'
Plug 'itchyny/lightline.vim'
Plug 'maximbaz/lightline-ale'
Plug 'tpope/vim-abolish'
Plug 'stsewd/fzf-checkout.vim'
Plug 'pbrisbin/vim-mkdir'
Plug 'vim-test/vim-test'
Plug 'mbbill/undotree'
Plug 'ruanyl/coverage.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'moll/vim-node'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'rust-lang/rust.vim'
Plug 'ludovicchabant/vim-gutentags'
Plug 'luochen1990/rainbow'
Plug 'andymass/vim-matchup'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'hrsh7th/nvim-compe'
Plug 'hrsh7th/vim-vsnip'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
" trying out gh cli telescope plugin
Plug 'nvim-telescope/telescope-github.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'junegunn/vim-peekaboo'
Plug 'chrisbra/Colorizer'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
call plug#end()

" fzf-gh settings
let g:fzf_gh_website=1

" NERDTree
let NERDTreeShowHidden=1
let NERDTreeMinimalMenu=1
let NERDTreeMinimalUI = 1

" firenvim
let g:firenvim_config = {
			\ 'globalSettings': {
			\ 'alt': 'all',
			\  },
			\ 'localSettings': {
			\ '.*': {
			\ 'cmdline': 'neovim',
			\ 'priority': 0,
			\ 'selector': 'textarea, div[role="textbox"]',
			\ 'takeover': 'never',
			\ },
			\ }
			\ }
set t_Co=256
set termguicolors
set bg=dark
" syntax highlight only to 1K instead of default 3K
set synmaxcol=1000
" THEME stuff
" better vertsplit char- part of ci_dark theme
set fillchars+=vert:│
let g:ci_dark_enable_bold = 1
let g:rainbow_active = 1
colorscheme ci_dark

" lightline config
let g:lightline = {
			\ 'colorscheme': 'ci_dark',
			\ 'component': {
	    \  'spell': '%{&spell?"SPELL":""}',
      \  'lineinfo': '%3l/%1L:%-2c'},
			\ 'active': {
			\   'left': [ [ 'mode', 'paste', 'spell' ],
			\             [ 'gitbranch', 'readonly', 'filename' ] ],
			\   'right': [ [ 'lineinfo' ],
			\             [ 'filetype' ], [ 'linter_errors'], [ 'lsp_diagnostics_hints' ],  [ 'lsp_diagnostics_warnings' ],  [ 'lsp_diagnostics_errors' ], [ 'bufferNr' ] ] },
			\ 'inactive': {
			\   'left': [ ['filename'] ],
			\   'right': [ ['filetype'], [ 'bufferNr' ]] }, 
			\ 'component_function': {
			\   'gitbranch': 'LightlineGitBranch',
			\   'filename': 'LightlineFilename',
      \   'bufferNr': 'LightlineBufferNr',
			\   'lsp_diagnostics_hints': 'LspHints',
			\   'lsp_diagnostics_warnings': 'LspWarnings',
			\   'lsp_diagnostics_errors': 'LspErrors',
			\ }
			\ }
let g:lightline.component_expand = {
      \  'linter_errors': 'lightline#ale#errors'
      \ }
let g:lightline.component_type = {
      \     'linter_errors': 'warning'
      \ }

function! LightlineFilename()
	let filename = expand('%:~:.') !=# '' ? expand('%:~:.') : '[No Name]'
	let modified = &modified ? ' +' : ''
	return filename . modified
endfunction

function! LightlineGitBranch()
	let head = get(b:,'gitsigns_head','')
	let status = get(b:,'gitsigns_status','')
	let status_text = strlen(status) > 0 ? ' ' . status : ''
	return head . status_text
endfunction

function! LightlineBufferNr()
	let bn = ' BN:' . bufnr('%')
	return bn
endfunction

function! LspHints() abort
	let sl = ''
	if luaeval('not vim.tbl_isempty(vim.lsp.buf_get_clients(0))')
		let sl.='💡:'
		let sl.= luaeval("vim.lsp.diagnostic.get_count(0, [[Hint]])")
	else
			let sl.='🦀'
	endif
	return sl
endfunction

function! LspWarnings() abort
	let sl = ''
	if luaeval('not vim.tbl_isempty(vim.lsp.buf_get_clients(0))')
		let sl.='⚠️ :'
		let sl.= luaeval("vim.lsp.diagnostic.get_count(0, [[Warn]])")
	else
			let sl.='🦀'
	endif
	return sl
endfunction

function! LspErrors() abort
	let sl = ''
	if luaeval('not vim.tbl_isempty(vim.lsp.buf_get_clients(0))')
		let sl.='❗:'
		let sl.= luaeval("vim.lsp.diagnostic.get_count(0, [[Error]])")
	else
			let sl.='🦀'
	endif
	return sl
endfunction
" -- end of lightline configs --
" treesitter folding
" * moved to ftplugins for js & rs (unsupported)
" set foldmethod=expr
" set foldexpr=nvim_treesitter#foldexpr()
" all. the. lua. --------
" --- lsp configs --- 
" Additional lsp settings in ftplugin for each language
" JavaScipt also using ALE for linting & fixing
lua require'lspconfig'.tsserver.setup{}
" - C
lua require'lspconfig'.clangd.setup{}
" - VimL (full circle!)
lua require'lspconfig'.vimls.setup{}
" - Rust and general + compe goodness!
"   @TODO: Kill off 'completion-nvim' b/c
"   nvim-compe is the amazing goodness!?

lua << END
-- treesitter
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true
  },
	incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
	indent = {
    enable = true
  },
	autopairs = {
		enable = true
	}
}

require('gitsigns').setup {
      signs = {
        add          = {hl = 'DiffAdd'   , text = '│', numhl='GitSignsAddNr'},
        change       = {hl = 'DiffChange', text = '│', numhl='GitSignsChangeNr'},
        delete       = {hl = 'DiffDelete', text = '_', numhl='GitSignsDeleteNr'},
        topdelete    = {hl = 'DiffDelete', text = '‾', numhl='GitSignsDeleteNr'},
        changedelete = {hl = 'DiffChange', text = '~', numhl='GitSignsChangeNr'},
      },

}

-- nvim-autopairs
require('nvim-autopairs').setup()
-- telescope
require('joel.telescope')
-- nvim_lsp object
local nvim_lsp = require'lspconfig'

-- setup compe
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    vsnip = true;
    nvim_lsp = true;
    nvim_lua = true;
    spell = true;
    tags = true;
    snippets_nvim = true;
    treesitter = true;
  };
}

-- snippet support
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Enable rust_analyzer
nvim_lsp.rust_analyzer.setup({
		capabilities = capabilities,
    on_attach=on_attach,
    settings = {
        ["rust-analyzer"] = {
            cargo = {
                loadOutDirsFromCheck = true
            },
            procMacro = {
                enable = true
            },
        }
    }
})

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif vim.fn.call("vsnip#available", {1}) == 1 then
    return t "<Plug>(vsnip-expand-or-jump)"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
    return t "<Plug>(vsnip-jump-prev)"
  else
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

-- Enable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
		underline = true,
    signs = true,
    update_in_insert = false,
  }
)

-- Send diagnostics to quickfix list
do
  local method = "textDocument/publishDiagnostics"
  local default_handler = vim.lsp.handlers[method]
  vim.lsp.handlers[method] = function(err, method, result, client_id, bufnr, config)
    default_handler(err, method, result, client_id, bufnr, config)
    local diagnostics = vim.lsp.diagnostic.get_all()
    local qflist = {}
    for bufnr, diagnostic in pairs(diagnostics) do
      for _, d in ipairs(diagnostic) do
        d.bufnr = bufnr
        d.lnum = d.range.start.line + 1
        d.col = d.range.start.character + 1
        d.text = d.message
        table.insert(qflist, d)
      end
    end
    vim.lsp.util.set_qflist(qflist)
  end
end
END

syntax enable

" *** mappings galore ***
" turn off highlight
noremap <silent><Leader>\ :noh<cr>
" write only if something is changed
noremap <Leader>w :up<cr>
" use ZZ but leave in for now 
noremap <silent> <Leader>q :q<cr>
" use ZQ for :q! (quit & discard changes)
" Discard all changed buffers & quit
noremap <silent> <Leader>Q :qall!<cr>
" write all and quit
noremap <silent> <Leader>W :wqall<cr>

" expands to dir of current file in cmd mode
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
" Buffer stuff - <C-6> is toggle current and alt(last viewed)
" go to next buffer
nnoremap <silent> <leader><right> :bn<CR>
" go to prev buffer
nnoremap <silent> <leader><left> :bp<CR>
" delete current buffer - will close split - :q to close split
nnoremap <silent> <leader>x :bd<CR>
" Experimental *** delete current buffer - don't close split*
nmap ,d :b#<bar>bd#<CR>

" ALE maps+
" @TODO: finish killing ALE
highlight clear ALEErrorSign
highlight clear ALEWarningSign
let g:ale_sign_error = "❗️"
let g:ale_sign_warning = "⚠︎"
" nmap <silent> <leader>h :ALEHover<cr>
nmap <leader>f <Plug>(ale_fix)
nmap <silent> <leader>d <Plug>(ale_go_to_definition)
nnoremap <silent> <leader>r :ALEFindReferences -relative<Return>
nnoremap <silent> <leader>rn :ALERename<Return>

" open file in directory of current file
nmap <leader>e :e %:h/
nmap <leader>v :vs %:h/
let g:ale_completion_enabled = 0
let g:ale_completion_autoimport = 1

" compe maps
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

" sessions
nmap <leader>ss :mksession ~/vim-sessions/
nmap <leader>os :wa<Bar>exe "mksession! " . v:this_session
nmap <silent><leader>ls :mksession! ~/vim-sessions/latest.vim<cr>

" paste last thing yanked(not system copied), not deleted
nmap ,p "0p
nmap ,P "0P

" DELETE: with y,d or c{motion} & it wont replace "0
nnoremap _ "_
" REPLACE: delete inner word & replace with last yanked (including system)
nmap ,r "_diwhp
" open quickfix / close
nmap <silent><leader>co :cope<CR>
nmap <silent><leader>cl :cclose<CR>
" open location list - close manually
nmap <silent><leader>lo :lope<CR>
" vim-surround maps
" surround word under cursor w/ backticks
nmap <leader>` ysiW`
" Duplicate a selection
" Visual mode: D
vmap D y'>p
" Join lines and restore cursor location
nnoremap J mjJ`j
" save some strokes (best mapping ever)
nnoremap ; :
vnoremap ; :
" -- completion maps --
" Mostly handled by `compe` 🌟
" thesaurus completion @TODO: Remove?
set thesaurus+=~/.vim/thesaurus/thesaurii.txt
inoremap <C-t> <C-x><C-t>
" line completion - use more!
inoremap <C-l> <C-x><C-l>
" check for spelling completion (compe?)
inoremap <C-s> <C-x><C-s>
" file path completion (compe!)
" inoremap <C-f> <C-x><C-f>
" Vim command-line completion
inoremap <C-v> <C-x><C-v>
" -- end completion maps --

filetype plugin indent on    " required
" auto exit insert mode
au CursorHoldI * stopinsert
au FileType text set colorcolumn=100 autoindent linebreak
au BufNewFile,BufRead *.markdown,*.mdown,*.mkd,*.mkdn,*.mdwn,*.md,*.MD  set ft=markdown

" When editing a file, always jump to the last known cursor position
autocmd BufReadPost *
			\ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
			\ |   exe "normal! g`\""
			\ | endif
" no help when I fat finger F1
nmap <F1> <Esc>
" yank all in buffer
nmap <silent><leader>a :%y<cr>
" yank the rest of the line
nmap Y y$
" Move between Vimdows
nmap <up> <C-w><up>
nmap <down> <C-w><down>
nmap <left> <C-w><left>
nmap <right> <C-w><right>
" back in jumplist
nmap <silent> <leader><bs> <C-o>
" forward in jumplist
nmap <silent> <leader><space> <C-i>
" Add empty line(s)
" handled by unimpaired for now
" open latest `todo` file, set by `T mark
nnoremap <silent> <leader>to :sp \| norm `T<cr>
" Replace word under cursor in file (case-sensitive)
nmap <leader>sr *:%s///gI<left><left><left>
" Replace word under cursor in line (case-sensitive)
nmap <leader>sl *:s///gI<left><left><left>
" undotree
nnoremap <silent><leader>u :UndotreeToggle<CR>
let g:undotree_HelpLine = 0
let g:undotree_WindowLayout = 2
let g:undotree_ShortIndicators = 1
let g:undotree_DiffpanelHeight = 6
" Fugitive & gitsigns maps
nnoremap <silent> <leader>gb :Git blame<Return>
nnoremap <silent> <leader>hh :lua require"gitsigns".toggle_linehl()<Return>
nmap <leader>gp :Gpush origin
" fzf-checkout settings
nnoremap <leader>gc :GBranches<CR>
let g:fzf_branch_actions = {
			\ 'rebase': {
			\   'prompt': 'Rebase> ',
			\   'execute': 'echo system("{git} rebase {branch}")',
			\   'multiple': v:false,
			\   'keymap': 'ctrl-r',
			\   'required': ['branch'],
			\   'confirm': v:false,
			\ },
			\ 'diff': {
			\   'prompt': 'Diff> ',
			\   'execute': 'Git diff {branch}',
			\   'multiple': v:false,
			\   'keymap': 'ctrl-f',
			\   'required': ['branch'],
			\   'confirm': v:false,
			\ },
			\ 'track': {
			\   'prompt': 'Track> ',
			\   'execute': 'echo system("{git} checkout --track {branch}")',
			\   'multiple': v:false,
			\   'keymap': 'ctrl-t',
			\   'required': ['branch'],
			\   'confirm': v:false,
			\ },
			\}
let g:fzf_checkout_git_options = '--sort=-committerdate'
let g:fzf_checkout_previous_ref_first = v:true

" splitsville
" - small vertical split to the right & go to it
nnoremap <silent> ,\ :75vsp<CR><C-w><right>
" split - larger top
nnoremap <silent> ,- :22sp<CR><C-w><down>
" Markdown-preview settings
nmap <leader>md <Plug>MarkdownPreview
" 
" ** Test and  coverage related **
" Specify the path to `coverage.json` file relative to your current working directory.
let g:coverage_json_report_path = 'coverage/coverage-final.json'

" Define the symbol display for covered lines
let g:coverage_sign_covered = '⦿'

" Define the interval time of updating the coverage lines
let g:coverage_interval = 3000

" Do not display signs on covered lines
let g:coverage_show_covered = 0

" Display signs on uncovered lines
let g:coverage_show_uncovered = 1

" using lowercase t for term:// split now
" nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
let g:test#runner_commands = ['Jest']

" **Term settings**
" open new neovim terminal: zsh in vsplit or split
command! -nargs=* T split | terminal <args>
nmap <silent> <leader>t :T<cr>
command! -nargs=* VT vsplit | terminal <args>
nmap <silent> <leader>tv :VT<cr>
" open existing terminal (or any) buffer in vert right split: @[N]
command! -nargs=* VRSB vertical rightbelow sb<args>
nnoremap <leader>br :VRSB
" delete terminal buffer - :q is fine in split
nnoremap <silent> <leader>tx :bd!<CR>
" open file under cursor in vert split - not term specific but...
nmap <silent> <leader>gf :vs <cfile><CR>
au TermOpen,TermEnter * setlocal nonu nornu | execute 'keepalt' 'file' fnamemodify(getcwd() . ' ⓣ  '. bufnr('%'), ':t')

" - not sure why I have this & <del> set? hmmm
if has('nvim')
	tmap <C-o> <C-\><C-n>
endif
" -- this all needs to become one function call --
" -- yank path out of terminal
command! -nargs=* NCD call chansend(b:terminal_job_id, "yp\<cr>")
nmap <silent><leader>D :NCD<cr>
" -- change lcd to term dir (copied from above :NCD)
nmap <silent><leader>F :lcd<c-r>+<cr>
" --- 
" end term settings ***

" change dir for window to file's dir
nnoremap <silent><leader>cd :lcd %:p:h<cr> 
" change dir for window to file's git working dir
nnoremap <silent><leader>gd :Glcd<cr> 

" Delete to Esc from (almost) all the things
nnoremap <Del> <Esc>
vnoremap <Del> <Esc>gV
onoremap <Del> <Esc>
cnoremap <Del> <C-C><Esc>
inoremap <Del> <Esc>`^
tnoremap <Del> <C-\><C-n>
" diff since last save
" -- quicky
nnoremap <leader>c :w !diff % -<CR>
" full featured diff
command! DiffOrig let g:diffline = line('.') | vert new | set bt=nofile | r # | 0d_ | diffthis | :exe "norm! ".g:diffline."G" | wincmd p | diffthis | wincmd p
nnoremap <Leader>do :DiffOrig<cr>
" end diffing, delete scratch(or diff2) buffer & go back to location
nnoremap <silent> <leader>dc :bd<cr>:diffoff<cr>:exe "norm! ".g:diffline."G"<cr>
" diff 2 or more windows/splits, end with \dc or just :diffoff to keep file2
nnoremap <leader>dw :windo diffthis<cr>
" telescope time
" -- find files with gitfiles & fallback on find_files
nnoremap <silent> ,<space> :lua require'joel.telescope'.project_files()<cr>
" find and/or create notes
nnoremap <silent> ,n :lua require'joel.telescope'.find_notes()<cr>
" Explore files starting at $HOME
nnoremap <silent> ,e :lua require'joel.telescope'.file_explorer()<cr>
" find a Vim runtimepath file
nnoremap <silent> <leader>rt :lua require'joel.telescope'.vim_rtp()<cr>
" find or create neovim configs
nnoremap <silent> <leader>nc :lua require'joel.telescope'.nvim_config()<cr>
" slowness: https://github.com/nvim-telescope/telescope.nvim/issues/392
nnoremap <silent> ,g :Telescope live_grep<cr>
nnoremap <silent> ,b :Telescope buffers<cr>
nnoremap <silent> ,h :Telescope help_tags<cr>
nnoremap <silent> <leader>fm :Telescope marks<cr>
nnoremap <silent> <leader>is :Telescope gh issues<cr>
" FZF mappings and config
" -- Temporarily back in for demo
" command! -bang VimRTP call fzf#vim#files('~/.vim', <bang>0)
" command! -bang Notes call fzf#vim#files('~/notes/CC', <bang>0)
" ---> :PRS and :PRSR - fzf-gh.vim
" PRs assigned awaiting my review
nnoremap <silent> <leader>pr :PRSR<CR>
nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <leader>bc :BCommits<CR>
nnoremap <silent> <leader>bt :BTags<CR>
nnoremap <silent> ,l :Lines<CR>
nnoremap <silent> <leader>l :BLines<CR>
nnoremap <C-p> :GFiles<CR>
nnoremap <leader>p :Files<CR>
" 'grep' word under cursor
nnoremap <silent> <leader>g :Rg <C-R>=expand("<cword>")<CR><CR>
" 'grep' -- ripgrep!
nnoremap <silent> <leader>rg :RG<CR>
let g:fzf_layout = { 'window': { 'width': 0.99, 'height': 0.8 } }
let g:fzf_preview_window = 'right:61%'
let $FZF_DEFAULT_OPTS='--reverse --multi'
" ripgrep with FZF only used as selector
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

" FZF fuzzy file finding with ripgrep
command! -bang -nargs=* Rg
			\ call fzf#vim#grep(
			\   'rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
			\   fzf#vim#with_preview(), <bang>0)

autocmd! FileType fzf set laststatus=1 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

augroup LuaHighlight
	autocmd!
	autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
augroup END

autocmd BufRead,BufNewFile *.h set filetype=c

function! OpenURLUnderCursor()
  let l:uri = expand('<cWORD>')
  silent exec "!open '" . l:uri . "'"
  :redraw!
endfunction

nnoremap <silent>gx :call OpenURLUnderCursor()<CR>
