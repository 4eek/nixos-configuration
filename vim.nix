with import <nixpkgs> {};

vim_configurable.customize {
  name = "vim";   # Specifies the vim binary name.
  # Below you can specify what usually goes into `~/.vimrc`
  vimrcConfig.customRC = ''
    " Preferred global default settings:
    set number                        " Enable line numbers by default
    set relativenumber                " Show relative line numbers
    set background=dark               " Set the default background to dark or light
    set smartindent                   " Automatically insert extra level of indentation
    set tabstop=2                     " Default tabstop
    set shiftwidth=2                  " Default indent spacing
    set expandtab                     " Expand [TABS] to spaces
    set backspace=indent,eol,start    " Backspace for dummies
    syntax enable                     " Enable syntax highlighting
    set mouse=a                       " Automatically enable mouse usage
    set mousehide                     " Hide the mouse cursor while typing
    scriptencoding utf-8              " Use utf-8 encoding
    set clipboard=unnamed,unnamedplus " Use system clipboard
    set history=1000                  " Store a ton of history (default is 20)
    set hidden                        " Allow buffer switching without saving
    set showmode                      " Display the current mode
    set cursorline                    " Highlight current line
    set incsearch                     " Find as you type search
    set hlsearch                      " Highlight search terms
    set gdefault                      " makes the s% flag global by default. Use /g to turn the global option off.
    set ignorecase                    " Case insensitive search
    set smartcase                     " Case sensitive when uc present
    set wildmenu                      " Show list instead of just completing
    set wildmode=list:longest,full    " Command <Tab> completion, list matches, then longest common part, then all.
    set whichwrap=b,s,h,l,<,>,[,]     " Backspace and cursor keys wrap too
    set scrolljump=5                  " Lines to scroll when cursor leaves screen
    set scrolloff=3                   " Minimum lines to keep above and below cursor
    set list
    set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace
    set splitright                    " split vertical splits to the right
    set splitbelow                    " split horizontal splits to the bottom
    colorscheme gruvbox               " Set the default colour scheme
    set t_Co=256                      " Use 265 colors in vim
    set spell spelllang=en_gb         " Default spell checking language
    hi clear SpellBad                 " Clear any unwanted default settings
    hi SpellBad cterm=underline       " Set the spell checking highlight style
    hi SpellBad ctermbg=NONE          " Set the spell checking highlight background
    match ErrorMsg '\s\+$'            "

    set ruler                         " Show the ruler
    set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
    set showcmd                       " Show partial commands in status line and
                                      " Selected characters/lines in visual mode

    let g:airline_powerline_fonts = 1   " Use powerline fonts
    let g:airline_theme='gruvbox'     " Set the airline theme

    "call togglebg#map("<F10>")   " Toggle background colour between dark|light

    set laststatus=2   " Set up the status line so it's coloured and always on

    " Removes trailing spaces:
    function! TrimWhiteSpace()
        %s/\s\+$//e
    endfunction

    nnoremap <silent> <Leader>RemoveTrailingWhiteSpace :call TrimWhiteSpace()<CR>
    autocmd FileWritePre    * :call TrimWhiteSpace()
    autocmd FileAppendPre   * :call TrimWhiteSpace()
    autocmd FilterWritePre  * :call TrimWhiteSpace()
    autocmd BufWritePre     * :call TrimWhiteSpace()

    set sessionoptions="buffers,curdir"

    " Instead of reverting the cursor to the last position in the buffer, we
    " set it to the first line when editing a git commit message
    au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])
    au FileType gitcommit setlocal spell

    " http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
    " Restore cursor to file position in previous editing session
    function! ResCur()
        if line("'\"") <= line("$")
            normal! g`"
            return 1
        endif
    endfunction
    augroup resCur
        autocmd!
        autocmd BufWinEnter * call ResCur()
    augroup END

    " Setting up the directories {
            "set backup                  " Backups are nice ...
            set undofile                " So is persistent undo ...
            set undolevels=1000         " Maximum number of changes that can be undone
            set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
    "}

    " Transparent editing of gpg encrypted files.
    " By Wouter Hanegraaff <wouter@blub.net>
    augroup encrypted
        au!

        " First make sure nothing is written to ~/.viminfo while editing an encrypted file.
        autocmd BufReadPre,FileReadPre      *.gpg set viminfo=
        " We don't want a swap file, as it writes unencrypted data to disk
        autocmd BufReadPre,FileReadPre      *.gpg set noswapfile
        " Switch to binary mode to read the encrypted file
        autocmd BufReadPre,FileReadPre      *.gpg set bin
        autocmd BufReadPre,FileReadPre      *.gpg let ch_save = &ch|set ch=2
        autocmd BufReadPost,FileReadPost    *.gpg '[,']!gpg --decrypt 2> /dev/null
        " Switch to normal mode for editing
        autocmd BufReadPost,FileReadPost    *.gpg set nobin
        autocmd BufReadPost,FileReadPost    *.gpg let &ch = ch_save|unlet ch_save
        autocmd BufReadPost,FileReadPost    *.gpg execute ":doautocmd BufReadPost " . expand("%:r")

        " Convert all text to encrypted text before writing
        autocmd BufWritePre,FileWritePre    *.gpg   '[,']!gpg --default-key=9D708096EC9C7331 --default-recipient-self -ae 2>/dev/null
        " Undo the encryption so we are back in the normal text, directly
        " after the file has been written.
        autocmd BufWritePost,FileWritePost    *.gpg   u
    augroup END

    " Add files ending in md to the list of files recognised as markdown:
    autocmd BufNewFile,BufFilePre,BufRead *.md set filetype=markdown

    " My Markdown environment
    function! MarkdownSettings()
        set textwidth=79
        set spell spelllang=en_gb
    endfunction
    autocmd BufNewFile,BufFilePre,BufRead *.mdwn :call MarkdownSettings()
    autocmd BufNewFile,BufFilePre,BufRead *.md :call MarkdownSettings()

    " My ReStructured Text environment
    function! ReStructuredSettings()
        set textwidth=79
        set spell spelllang=en_gb
    endfunction
    autocmd BufNewFile,BufFilePre,BufRead *.rst :call ReStructuredSettings()
    autocmd BufNewFile,BufFilePre,BufRead *.txt :call ReStructuredSettings()

    " My LaTeX environment:
    function! LaTeXSettings()
        set textwidth=79
        set spell spelllang=en_gb
    endfunction
    autocmd BufNewFile,BufFilePre,BufRead *.tex :call LaTeXSettings()

    " Settings for my Haskell environment:
    function! HaskellSettings()
        set tabstop=4
        set shiftwidth=4
        set expandtab
        set textwidth=79
    endfunction
    autocmd BufNewFile,BufFilePre,BufRead *.hs :call HaskellSettings()

    " Settings for my Nix environment:
    function! NixSettings()
        set tabstop=2
        set shiftwidth=2
        set expandtab
        set textwidth=79
        set filetype=nix
    endfunction
    autocmd BufNewFile,BufFilePre,BufRead *.nix :call NixSettings()

    " Settings for my Golang environment:
    function! GoSettings()
        set tabstop=7
        set shiftwidth=7
        set noexpandtab
    endfunction
    autocmd BufNewFile,BufFilePre,BufRead *.go :call GoSettings()

    " Settings for my Python environment:
    function! PythonSettings()
        set tabstop=4
        set shiftwidth=4
        set expandtab
        set textwidth=79
        set spell!
    endfunction
    autocmd BufNewFile,BufFilePre,BufRead *.py :call PythonSettings()

    " My Mutt environment
    function! MuttSettings()
        set textwidth=79
        set spell spelllang=en_gb
        "set tabstop=4
        "set shiftwidth=4
        "set expandtab
    endfunction
    autocmd BufNewFile,BufFilePre,BufRead /tmp/mutt-* :call MuttSettings()
    autocmd BufNewFile,BufFilePre,BufRead /tmp/neomutt-* :call MuttSettings()

    " Settings for my C environment:
    function! CSettings()
        set tabstop=2
        set shiftwidth=2
        set expandtab
        set textwidth=79
    endfunction
    autocmd BufNewFile,BufFilePre,BufRead *.c :call CSettings()

    " Settings for my YAML environment:
    function! YAMLSettings()
        set tabstop=2
        set shiftwidth=2
        set expandtab
        set textwidth=79
    endfunction
    autocmd BufNewFile,BufFilePre,BufRead *.yaml :call YAMLSettings()

    " Settings for my Bash environment:
    function! BashSettings()
        set tabstop=4
        set shiftwidth=4
        set expandtab
        set textwidth=79
        set spell!
    endfunction
    autocmd BufNewFile,BufFilePre,BufRead *.sh :call BashSettings()

    " My Bzr commit environment
    function! BzrSettings()
        set textwidth=79
        set spell spelllang=en_gb
        set tabstop=4
        set shiftwidth=4
        set expandtab
    endfunction
    autocmd BufNewFile,BufFilePre,BufRead bzr_* :call BzrSettings()

    " Settings for my Elixir environment:
    function! ElixirSettings()
        set tabstop=2
        set shiftwidth=2
        set expandtab
        set textwidth=79
        set spell!
        au BufWrite * :Autoformat
    endfunction
    autocmd BufNewFile,BufFilePre,BufRead *.ex :call ElixirSettings()
    autocmd BufNewFile,BufFilePre,BufRead *.exs :call ElixirSettings()

  '';
  # store your plugins in Vim packages
  vimrcConfig.packages.myVimPackage = with pkgs.vimPlugins; {
    start = [               # Plugins loaded on launch
    airline               # Lean & mean status/tabline for vim that's light as air
    ctrlp                 # Full path fuzzy file, buffer, mru, tag, ... finder for Vim
    ghc-mod-vim           # Happy Haskell programming on Vim, powered by ghc-mod
    neco-ghc              # Completion plugin for Haskell, using ghc-mod
    neocomplete-vim       # Keyword completion system
    nerdcommenter         # Comment functions so powerful—no comment necessary
    nerdtree              # File system explorer
    nerdtree-git-plugin   # Plugin for nerdtree showing git status
    snipmate              # Concise vim script implementing TextMate's snippets features
    gruvbox               # Gruvbox colours for Vim
    supertab              # Allows you to use <Tab> for all your insert completion
    syntastic             # Syntax checking hacks
    tabular               # Script for text filtering and alignment
    vim-airline-themes    # Collection of themes for airline
    vim-nix               # Support for writing Nix expressions in vim
    vimproc               # Interactive command execution required by ghc-mod-vim
    fzf
    fzf-vim
    vim-autoformat        # Formatting support
    vim-elixir            # Elixir support
    coc-nvim              #
  ];
    # manually loadable by calling `:packadd $plugin-name`
    # opt = [ phpCompletion elm-vim ];
    # To automatically load a plugin when opening a filetype, add vimrc lines like:
    # autocmd FileType php :packadd phpCompletion
  };
}

