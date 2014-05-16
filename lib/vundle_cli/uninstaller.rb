require 'tempfile'
require 'fileutils'

module VundleCli

  class Uninstaller

    attr_reader :options, :vimdir, :settings_dir, :vimrc, :force, :bundle

    def initialize(options, bundle)
      @options = options
      @vimdir = Helpers.file_validate(options.vimdir, true)
      @settings_dir = Helpers.file_validate(options.settings, true)
      @vimrc = Helpers.file_validate(options.vimrc)
      @force = options.force
      @bundle = bundle
    end

    # 1) Remove the line `Bundle bundle` from .vimrc.
    # 2) Look for a file in the settings directory (provided by option --settings)
    #    with name that includes the bundle name. Then ask if the user wants to remove it.
    # 3) Remove the bundle directory if the force switch is on.
    def rm(modify_vimrc = true)

      if modify_vimrc
        tmp = Tempfile.new("vimrc_tmp")
        open(@vimrc, 'r').each { |l| 
          if l.chomp =~ /Bundle .*#{Regexp.quote(@bundle)}.*/
            puts "Found bundle #{@bundle}, removing it from #{@vimrc}..."
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

      Helpers.puts_separator

      puts "Searching for bundle folder..."
      delete_bundle_dir(bundle_name)

      puts "Done!"

    end

    def delete_setting_file(bundle_name)
      Dir.foreach(@settings_dir) do |fname|
        next unless fname.downcase.include?(Helpers.bundle_trim_name(bundle_name).downcase)
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

    def delete_bundle_dir(bundle_name)
      bundle_dir = "#{@vimdir}/bundle/#{bundle_name}"
      if Dir.exists?(bundle_dir)
        input = 'yes'
        unless @force
          puts "Found #{bundle_dir}. Remove it? (yes/no) "
          begin
            input = STDIN.gets.chomp
          rescue Interrupt
            abort("Aborted.")
          end
        end
        if input == 'yes'
          FileUtils.rm_rf(bundle_dir)
          puts "===#{bundle_dir} deleted==="
        end
      end
    end
  end
end
