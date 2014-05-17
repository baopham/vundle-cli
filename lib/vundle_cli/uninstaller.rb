require 'tempfile'
require 'fileutils'

module VundleCli

  class Uninstaller

    attr_reader :options, :vimdir, :settings_dir, :vimrc, :force, :plugin

    def initialize(options, plugin = nil)
      @options = options
      @vimdir = file_validate(options.vimdir, true)
      @settings_dir = file_validate(options.settings, true)
      @vimrc = file_validate(options.vimrc)
      @force = options.force
      unless plugin.nil?
        @plugin = plugin
        abort("Plugin name too ambiguous.") if ambiguous?(plugin)
      end
    end

    def ambiguous?(plugin)
      plugin_name = plugin_base_name(plugin)
      plugin_trim_name(plugin_name).empty?
    end

    # 1) Remove the line `Bundle plugin_name` or `Plugin plugin_name` from .vimrc.
    # 2) Look for a file in the settings directory (provided by option --settings)
    #    with name that includes the plugin name. Then ask if the user wants to remove it.
    # 3) Remove the plugin directory.
    def rm(modify_vimrc = true)

      if modify_vimrc
        say "Searching plugin in #{@vimrc}..."
        tmp = Tempfile.new("vimrc_tmp")
        open(@vimrc, 'r').each { |l| 
          if l.chomp =~ /(Bundle|Plugin) .*#{Regexp.quote(@plugin)}.*/
            say_ok "Uninstalling "
            say l.chomp
          else
            tmp << l
          end
        }
        tmp.close
        FileUtils.mv(tmp.path, @vimrc)
        puts_separator
      end

      plugin_name = plugin_base_name(@plugin)

      say "Searching for setting file..."
      delete_setting_file(plugin_name)
      puts_separator
      say "Searching for plugin folder..."
      delete_plugin_dir(plugin_name)
    end

    def delete_setting_file(plugin_name)
      trimmed_name = plugin_trim_name(plugin_name)
      Dir.foreach(@settings_dir) do |fname|
        next if fname == '.' or fname == '..'
        next unless fname.downcase.include?(trimmed_name.downcase)
        input = 'yes'
        unless @force
          say_warning "Found #{@settings_dir}/#{fname} setting file. Remove it? (yes/no) "
          begin
            input = STDIN.gets.chomp
          rescue Interrupt
            abort("Aborted.")
          end
        end
        if input == 'yes'
          File.delete("#{@settings_dir}/#{fname}")
          say_ok "===#{@settings_dir}/#{fname} deleted==="
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
          say_warning "Found #{b}. Remove it? (yes/no) "
          begin
            input = STDIN.gets.chomp
          rescue Interrupt
            abort("Aborted.")
          end
        end
        if input == 'yes'
          FileUtils.rm_rf(b)
          say_ok "===#{b} deleted==="
        end
      }
    end
  end
end
