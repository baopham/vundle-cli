# Vundle CLI [![Gem Version](https://badge.fury.io/rb/vundle-cli.svg)](http://badge.fury.io/rb/vundle-cli) [![GitHub version](https://badge.fury.io/gh/baopham%2Fvundle-cli.svg)](http://badge.fury.io/gh/baopham%2Fvundle-cli)

A (tiny) CLI for Vim plugin manager [Vundle](https://github.com/gmarik/Vundle.vim)  

Available commands:

* `rm` remove a plugin
* `list` list all installed plugins
* `find` find an installed plugin
* `clean` clean up unused plugin related files

`rm` will remove the line `Bundle plugin_name` or `Plugin plugin_name` in your `.vimrc`, 
delete the configuration file for this plugin in the specified settings directory, 
and the plugin folder. Before anything is deleted, the command will prompt you 
for confirmation unless the `--force` switch is on.

I built this so that it's quicker to uninstall a plugin with my particular 
[vim setup](https://github.com/baopham/vim)

## Installation

Add this line to your application's Gemfile:

    gem 'vundle-cli'

And then execute:

    $ vundle

Or install it yourself as:

    $ gem install vundle-cli

## Usage

  **NAME**:

    vundle

  **DESCRIPTION**:

    A (tiny) CLI for Vim plugin manager Vundle

  **COMMANDS**:
	
    clean                Clean up unused plugin related files
    find                 Search for an installed plugin  
    help                 Display global or [command] help documentation  
    list                 List all installed plugins  
    rm                   Remove a plugin  

  **GLOBAL OPTIONS**:
	
    -h, --help  
        Display help documentation
	
    -v, --version  
        Display version information
	
    -t, --trace  
        Display backtrace when an error occurs

### Commands

  **NAME**:

    rm

  **SYNOPSIS**:

    vundle rm <plugin> [options]

  **DESCRIPTION**:

    Uninstall a plugin. 
    The command will remove the line ``Bundle plugin_name'' or ``Plugin plugin_name'' in your ``.vimrc'', 
    delete the configuration file for this plugin in the specified settings directory, and the plugin folder. 
    Before anything is deleted, the command will prompt you for confirmation unless the ``--force'' switch is on.

  **EXAMPLES**:
	
    # Remove plugin kien/ctrlp.vim
    vundle rm kien/ctrlp.vim
	
    # Or, remove any plugin that has ``ctrlp'' in its name (not recommended, it can be too ambiguous)
    vundle rm ctrlp
	
  **OPTIONS**:
	
    --vimdir vimdir 
        Vim directory. Default to ~/.vim.
	
    --settings settings_dir 
        Vim settings directory (where you configure your plugins). Default to ~/.vim/settings.
	
    --vimrc vimrc 
        .vimrc path. Default to ~/.vimrc.
	
    -f, --force 
        Force delete without confirmation. Disabled by default.
	

	

- - -

  **NAME**:

    list

  **SYNOPSIS**:

    vundle list [options]

  **DESCRIPTION**:

    List all installed plugins

  **EXAMPLES**:
	
    # List all installed plugins
    vundle list --vimrc ~/.vimrc
	
  **OPTIONS**:
	
    --vimrc vimrc 
        .vimrc path. Default to ~/.vimrc.
	

- - -

  **NAME**:

    find

  **SYNOPSIS**:

    vundle find <plugin> [options]

  **DESCRIPTION**:

    Search for an installed plugin

  **EXAMPLES**:
	
    # Find a plugin that has substring ``gist''
    vundle find gist
	
  **OPTIONS**:
	
    --vimrc vimrc 
        .vimrc path. Default to ~/.vimrc.
	

- - -

  **NAME**:

    clean

  **SYNOPSIS**:

    vundle clean [plugin] [options]

  **DESCRIPTION**:

    Clean up unused plugin related files (such as plugin folder and config file).
    It will prompt you for confirmation before deleting anything (unless force switch is on). 
    For option ``--all'', the command gets a list of the plugins in your bundle folder (e.g: ~/.vim/bundle) 
    and compare them with the plugins in your vimrc in order to determine which plugins need to be cleaned up.

  **EXAMPLES**:
	
    # Clean all unused plugins
    vundle clean --all
	
    # Clean plugin vim-signify
    vundle clean vim-signify
	
    # Clean any plugins with names that have substring ``dirty''
    vundle clean dirty
	
  **OPTIONS**:
	
    --vimdir vimdir 
        Vim directory. Default to ~/.vim.
	
    --settings settings_dir 
        Vim settings directory (where you configure your plugins). Default to ~/.vim/settings.
	
    --vimrc vimrc 
        .vimrc path. Default to ~/.vimrc.
	
    -a, --all 
        Delete everything that is not installed in your vimrc. Disabled by default.
	
    -l, --list 
        List all unused plugins.
	
    -f, --force 
        Force delete files without prompt. Disabled by default.
	

## Contributing

1. Fork it ( http://github.com/baopham/vundle-cli/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
