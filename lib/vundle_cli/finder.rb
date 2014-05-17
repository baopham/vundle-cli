module VundleCli
  class Finder

    attr_reader :options, :vimrc, :plugin

    def initialize(options, plugin = '')
      @options = options
      @vimrc = Helpers.file_validate(options.vimrc)
      @plugin = plugin
    end

    def get_list
      plugins = Array.new
      open(@vimrc, 'r').each { |l| 
        matches = l.chomp.match(/^(Bundle|Plugin) (\S*)/)
        if matches
          plugins << matches[2].gsub(/[',]/, '')
        end
      }
      plugins
    end

    def list
      plugins = get_list
      plugins.each { |b| puts b }
    end

    def find
      puts "Searching..."
      open(@vimrc, 'r').each { |l| 
        matches = l.chomp.match(/^(Bundle|Plugin) (\S*)/)
        if matches
          plugin = matches[2].gsub(/[',]/, '')
          puts "Found #{plugin}" if plugin.downcase.include?(@plugin.downcase)
        end
      }
    end

  end
end
