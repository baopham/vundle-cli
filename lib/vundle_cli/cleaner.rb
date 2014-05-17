module VundleCli

  class Cleaner

    attr_reader :options, :vimdir, :settings_dir, :vimrc, :all, :force, :plugin

    def initialize(options, plugin)
      @options = options
      @vimdir = Helpers.file_validate(options.vimdir, true)
      @settings_dir = Helpers.file_validate(options.settings, true)
      @vimrc = Helpers.file_validate(options.vimrc)
      @all = options.all
      @force = options.force
      @plugin = plugin
    end

    def clean
      if @all
        # Get a list of plugin directories (basenames only).
        all_plugins = Array.new
        all_plugins = Dir["#{@vimdir}/bundle/*/"].map { |b|
          File.basename(b)
        }

        # Get a list of installed plugins.
        finder = Finder.new(@options)
        installed_plugins = Array.new
        installed_plugins = finder.get_list.map { |b|
          Helpers.plugin_base_name(b)
        }

        unused_plugins = all_plugins - installed_plugins

        uninstaller = Uninstaller.new(@options)
        unused_plugins.each do |plugin_name| 
          puts "Cleaning #{plugin_name}..."
          uninstaller.delete_setting_file(plugin_name)
          uninstaller.delete_plugin_dir(plugin_name)
        end
      else
        # Only clean up unused plugin.
        open(@vimrc, 'r').each { |l| 
          next unless l.chomp =~ /(Bundle|Plugin) .*#{Regexp.quote(@plugin)}.*/
          puts "Can't clean this plugin since it's installed in your .vimrc. Please use command `rm` to uninstall it."
          return
        }

        uninstaller = Uninstaller.new(@options, @plugin)
        uninstaller.rm(false)
      end
    end

  end

end
