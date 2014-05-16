module VundleCli

  class Cleaner

    attr_reader :options, :vimdir, :settings_dir, :vimrc, :all, :force, :bundle

    def initialize(options, bundle)
      @options = options
      @vimdir = Helpers.file_validate(options.vimdir, true)
      @settings_dir = Helpers.file_validate(options.settings, true)
      @vimrc = Helpers.file_validate(options.vimrc)
      @all = options.all
      @force = options.force
      @bundle = bundle
    end

    def clean
      if @all
        # Get a list of bundle directories (basenames only).
        all_bundles = Array.new
        all_bundles = Dir["#{@vimdir}/bundle/*/"].map { |b|
          File.basename(b)
        }

        # Get a list of installed bundles.
        finder = Finder.new(@options)
        installed_bundles = Array.new
        installed_bundles = finder.get_list.map { |b|
          Helpers.bundle_base_name(b)
        }

        unused_bundles = bundle_dirs - installed_bundles

        puts "Cleaning..."
        uninstaller = Uninstaller.new(@options)
        unused_bundles.each do |bundle_name| 
          uninstaller.delete_setting_file(bundle_name)
          uninstaller.delete_bundle_dir(bundle_name)
        end
      else
        # Only clean up unused bundle.
        open(@vimrc, 'r').each { |l| 
          next unless l.chomp =~ /Bundle .*#{Regexp.quote(@bundle)}.*/
          puts "Can't clean this bundle since it's installed in your .vimrc. Please use command `rm` to uninstall it."
          return
        }

        uninstaller = Uninstaller.new(@options, @bundle)
        uninstaller.rm(false)
      end
    end

  end

end
