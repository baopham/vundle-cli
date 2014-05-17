# Vundle CLI

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

    $ bundle

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
	

## Contributing

1. Fork it ( http://github.com/baopham/vundle-cli/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
