require 'tempfile'
require 'fileutils'

module VundleCli

  class Installer

    attr_reader :options, :vimdir, :settings_dir, :vimrc, :force, :plugin

    def initialize(options, plugin = nil)
      @options = options
      @vimdir = file_validate(options.vimdir, true)
      @vimrc = file_validate(options.vimrc)
      unless plugin.nil?
        @plugin = plugin
      end
    end


    def install

        say "Writing plugin in #{@vimrc}..."
        tmp = Tempfile.new("vimrc_tmp")
        open(@vimrc, 'r').each { |l| 
          if l.chomp =~ /vundle#begin/
            l<<"\nPlugin '#{@plugin}'"
          end
          tmp << l
        }
        tmp.close
        FileUtils.mv(tmp.path, @vimrc)
        say "Waiting for plugin installing complete..."
        `vim +PluginInstall +qall`
    end
  end
end
