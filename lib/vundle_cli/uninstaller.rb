require 'fileutils'
require 'tempfile'

module VundleCli
  class Uninstaller

    attr_reader :options

    attr_reader :vimdir

    attr_reader :settings_dir

    attr_reader :vimrc

    attr_reader :bundle

    def initialize(options, bundle)
      # TODO: validate file input
      @options = options
      @vimdir = File.expand_path(options.vimdir)
      @settings_dir = File.expand_path(options.settings)
      @vimrc = File.expand_path(options.vimrc)
      @vimrc = File.readlink(@vimrc) if File.symlink?(@vimrc)
      @bundle = bundle
    end

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
      bundle_name = @bundle
      if @bundle.include? "/"
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
