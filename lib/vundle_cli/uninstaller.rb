require 'tempfile'
require 'fileutils'

module VundleCli

  class Uninstaller

    attr_reader :options, :vimdir, :settings_dir, :vimrc, :force, :bundle

    def initialize(options, bundle = nil)
      @options = options
      @vimdir = Helpers.file_validate(options.vimdir, true)
      @settings_dir = Helpers.file_validate(options.settings, true)
      @vimrc = Helpers.file_validate(options.vimrc)
      @force = options.force
      unless bundle.nil?
        @bundle = bundle
        abort("Bundle name too ambiguous.") if ambiguous?(bundle)
      end
    end

    def ambiguous?(bundle)
      bundle_name = Helpers.bundle_base_name(bundle)
      Helpers.bundle_trim_name(bundle_name).empty?
    end

    # 1) Remove the line `Bundle bundle` from .vimrc.
    # 2) Look for a file in the settings directory (provided by option --settings)
    #    with name that includes the bundle name. Then ask if the user wants to remove it.
    # 3) Remove the bundle directory.
    def rm(modify_vimrc = true)

      if modify_vimrc
        tmp = Tempfile.new("vimrc_tmp")
        open(@vimrc, 'r').each { |l| 
          if l.chomp =~ /Bundle .*#{Regexp.quote(@bundle)}.*/
            puts "Found #{l.chomp}, removing it from #{@vimrc}..."
            Helpers.puts_separator
          else
            tmp << l
          end
        }
        tmp.close
        FileUtils.mv(tmp.path, @vimrc)
      end

      bundle_name = Helpers.bundle_base_name(@bundle)

      puts "Searching for setting file..."
      delete_setting_file(bundle_name)

      puts "Searching for bundle folder..."
      delete_bundle_dir(bundle_name)
    end

    def delete_setting_file(bundle_name)
      trimmed_name = Helpers.bundle_trim_name(bundle_name)
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
        Helpers.puts_separator
      end
    end

    def delete_bundle_dir(bundle_name)
      bundle_dir = "#{@vimdir}/bundle/#{bundle_name}"
      dirs =
        # If the user uses the exact name of the plugin, remove it.
        if Dir.exists?(bundle_dir)
          [bundle_dir]
        # else, search for bundle folders with substring bundle_name.
        else
          Dir["#{@vimdir}/bundle/*#{bundle_name}*"]
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
        Helpers.puts_separator
      }
    end
  end
end
