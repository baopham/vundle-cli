require 'tempfile'
require 'fileutils'

module VundleCli

  class Uninstaller

    attr_reader :options, :vimdir, :settings_dir, :vimrc, :force, :plugin

    def initialize(options, plugin = nil)
      @options = options
      @vimdir = Helpers.file_validate(options.vimdir, true)
      @settings_dir = Helpers.file_validate(options.settings, true)
      @vimrc = Helpers.file_validate(options.vimrc)
      @force = options.force
      unless plugin.nil?
        @plugin = plugin
        abort("Plugin name too ambiguous.") if ambiguous?(plugin)
      end
    end

    def ambiguous?(plugin)
      plugin_name = Helpers.plugin_base_name(plugin)
      Helpers.plugin_trim_name(plugin_name).empty?
    end

    # 1) Remove the line `Bundle plugin_name` or `Plugin plugin_name` from .vimrc.
    # 2) Look for a file in the settings directory (provided by option --settings)
    #    with name that includes the plugin name. Then ask if the user wants to remove it.
    # 3) Remove the plugin directory.
    def rm(modify_vimrc = true)

      if modify_vimrc
        puts "Searching plugin in #{@vimrc}..."
        tmp = Tempfile.new("vimrc_tmp")
        open(@vimrc, 'r').each { |l| 
          if l.chomp =~ /(Bundle|Plugin) .*#{Regexp.quote(@plugin)}.*/
            puts "Found #{l.chomp}, uninstalling it from vimrc..."
          else
            tmp << l
          end
        }
        tmp.close
        FileUtils.mv(tmp.path, @vimrc)
        Helpers.puts_separator
      end

      plugin_name = Helpers.plugin_base_name(@plugin)

      puts "Searching for setting file..."
      delete_setting_file(plugin_name)
      Helpers.puts_separator
      puts "Searching for plugin folder..."
      delete_plugin_dir(plugin_name)
    end

    def delete_setting_file(plugin_name)
      trimmed_name = Helpers.plugin_trim_name(plugin_name)
      Dir.foreach(@settings_dir) do |fname|
        next if fname == '.' or fname == '..'
        next unless fname.downcase.include?(trimmed_name.downcase)
        input = 'yes'
        unless @force
          puts "Found #{@settings_dir}/#{fname} setting file. Remove it? (yes/no) "
          begin
            input = STDIN.gets.chomp
          rescue Interrupt
            abort("Aborted.")
          end
        end
        if input == 'yes'
          File.delete("#{@settings_dir}/#{fname}")
          puts "===#{@settings_dir}/#{fname} deleted==="
        end
      end
    end

    def delete_plugin_dir(plugin_name)
      plugin_dir = "#{@vimdir}/bundle/#{plugin_name}"
      dirs =
        # If the user uses the exact name of the plugin, remove it.
        if Dir.exists?(plugin_dir)
          [plugin_dir]
        # else, search for plugin folders with substring plugin_name.
        else
          Dir["#{@vimdir}/bundle/*#{plugin_name}*"]
        end

      dirs.each { |b|
        input = 'yes'
        unless @force
          puts "Found #{b}. Remove it? (yes/no) "
          begin
            input = STDIN.gets.chomp
          rescue Interrupt
            abort("Aborted.")
          end
        end
        if input == 'yes'
          FileUtils.rm_rf(b)
          puts "===#{b} deleted==="
        end
      }
    end
  end
end
