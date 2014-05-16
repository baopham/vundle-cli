module VundleCli
  class Finder

    attr_reader :options, :vimrc, :bundle

    def initialize(options, bundle = '')
      @options = options
      @vimrc = Helpers.file_validate(options.vimrc)
      @bundle = bundle
    end

    def get_list
      bundles = Array.new
      open(@vimrc, 'r').each { |l| 
        matches = l.chomp.match(/^Bundle (\S*)/)
        if matches
          bundles << matches[1].gsub(/[',]/, '')
        end
      }
      bundles
    end

    def list
      bundles = get_list
      bundles.each { |b| puts b }
    end

    def find
      puts "Searching..."
      open(@vimrc, 'r').each { |l| 
        matches = l.chomp.match(/^Bundle (\S*)/)
        if matches
          bundle = matches[1].gsub(/[',]/, '')
          puts "Found #{bundle}" if bundle.downcase.include?(@bundle.downcase)
        end
      }
    end

  end
end
