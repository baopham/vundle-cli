module VundleCli
  class Finder

    attr_reader :options, :vimrc, :plugin

    def initialize(options, plugin = '')
      @options = options
      @vimrc = file_validate(options.vimrc)
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
      enable_paging
      say get_list.join("\n")
    end

    def find
      say "Searching..."
      found=false
      open(@vimrc, 'r').each { |l| 
        matches = l.chomp.match(/^(Bundle|Plugin) (\S*)/)
        if matches
          plugin = matches[2].gsub(/[',]/, '')
          if plugin.downcase.include?(@plugin.downcase)
            say_ok "Found "
            say plugin
            found=true
          end
        end
      }
      found
    end

  end
end
