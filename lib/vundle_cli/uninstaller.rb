require 'tempfile'
require 'fileutils'

module VundleCli

  class Uninstaller

    attr_reader :options

    attr_reader :vimdir

    attr_reader :settings_dir

    attr_reader :vimrc

    attr_reader :force

    attr_reader :bundle

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
    def rm
      tmp = Tempfile.new("vimrc_tmp")
      open(@vimrc, 'r').each { |l| 
        if l.chomp =~ /Bundle .*#{Regexp.quote(@bundle)}.*/
          puts "Found bundle #{@bundle}, removing it from #{@vimrc}..."
        else
          tmp << l
        end
      }
      tmp.close
      FileUtils.mv(tmp.path, @vimrc)

      puts "Searching for setting file..."

      bundle_name = Helpers.bundle_base_name(@bundle)

      Dir.foreach(@settings_dir) do |fname|
        next unless fname.downcase.include?(bundle_name.sub(/\.vim/, '').downcase)
        puts "Found #{@settings_dir}/#{fname} setting file. Remove it? (yes/no) "
        input = STDIN.gets.chomp
        if input == 'yes'
          File.delete("#{@settings_dir}/#{fname}")
          puts "===#{@settings_dir}/#{fname} deleted==="
        end
        puts "\n"
      end

      puts "Searching for bundle folder..."

      bundle_dir = "#{@vimdir}/bundle/#{bundle_name}"
      if Dir.exists?(bundle_dir)
        puts "Found #{bundle_dir}. Remove it? (yes/no) "
        begin
          input = STDIN.gets.chomp
          if input == 'yes'
            FileUtils.rm_rf(bundle_dir)
            puts "===#{bundle_dir} deleted==="
          end
        rescue Interrupt
          abort("Aborted.")
        end
      end

      puts "Done."

    end

  end
end
