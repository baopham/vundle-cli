module VundleCli
  class Finder

    attr_reader :options

    attr_reader :vimrc

    attr_reader :bundle

    def initialize(options, bundle = '')
      @options = options
      @vimrc = Helpers.file_validate(options.vimrc)
      @bundle = bundle
    end

    def list
      open(@vimrc, 'r').each { |l| 
        matches = l.chomp.match(/^Bundle (\S*)/)
        if matches
          puts matches[1].gsub("'", '')
        end
      }
    end

    def find
      puts "Searching..."
      open(@vimrc, 'r').each { |l| 
        matches = l.chomp.match(/^Bundle (\S*)/)
        if matches
          bundle = matches[1].gsub("'", '')
          puts "Found #{bundle}" if bundle.include?(@bundle)
        end
      }
    end

  end
end
