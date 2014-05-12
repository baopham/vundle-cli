require 'tempfile'

module VundleCli

  class Uninstaller

    attr_reader :options

    attr_reader :vimdir

    attr_reader :settings_dir

    attr_reader :vimrc

    attr_reader :bundle

    def initialize(options, bundle)
      @options = options
      @vimdir = Helpers.file_validate(options.vimdir, true)
      @settings_dir = Helpers.file_validate(options.settings, true)
      @vimrc = Helpers.file_validate(options.vimrc)
      @bundle = bundle
    end

    # 1) Remove the line `Bundle bundle` from .vimrc.
    # 2) Look for a file in the settings directory (provided by option --settings)
    #    with name that includes the bundle name. Then ask if the user wants to remove it.
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

      # Get the bundle's main name.
      # (the provided @bundle usually looks like baopham/trailertrash.vim,
      # so we trim it down to get "trailertrash" only).
      bundle_name = @bundle
      if @bundle.include?("/")
        bundle_name = @bundle.split("/")[1].sub(/\.vim/, '')
      end

      Dir.foreach(@settings_dir) do |fname|
        next unless fname.include? bundle_name
        puts "Found #{@settings_dir}/#{fname} setting file. Remove it? (yes/no) "
        input = STDIN.gets.chomp
        if input == 'yes'
          File.delete("#{@settings_dir}/#{fname}")
          puts "File deleted."
        end
      end
    end

  end
end
