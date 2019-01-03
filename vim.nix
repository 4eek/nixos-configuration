with import <nixpkgs> {};

vim_configurable.customize {
    # Specifies the vim binary name.
    # E.g. set this to "my-vim" and you need to type "my-vim" to open this vim
    # This allows to have multiple vim packages installed (e.g. with a different set of plugins)
    name = "vim";
    vimrcConfig.customRC = ''
        filetype plugin indent on
	set nocompatible
	syntax enable
	set background=dark
	colorscheme solarized
	set nostartofline
	" and some more stuff...
    '';
    # Use the default plugin list shipped with nixpkgs
    vimrcConfig.vam.knownPlugins = pkgs.vimPlugins;
    vimrcConfig.vam.pluginDictionaries = [ 
	{ names = [ 
            # Here you can place all your vim plugins
            # They are installed managed by `vam` (a vim plugin manager)
	    "Syntastic" 
	    "ctrlp" 
            "colors-solarized" 
            "supertab" 
            "nerdtree" 
            "vim-closetag" 
        ]; } 
    ];
}
