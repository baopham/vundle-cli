module VundleCli
  module Helpers
    module_function

    def file_validate(fpath, check_dir = false)
      fpath = File.expand_path(fpath)

      unless File.exist?(fpath)
        raise ArgumentError.new("#{fpath} does not exist")
      end

      fpath = File.readlink(fpath) if File.symlink?(fpath)

      if check_dir
        unless File.directory?(fpath)
          raise ArgumentError.new("#{fpath} is not a directory")
        end
      else
        unless File.file?(fpath)
          raise ArgumentError.new("#{fpath} is not a valid file")
        end
      end

      fpath
    end

    # Get the bundle's main name.
    # (the provided @bundle usually looks like baopham/trailertrash.vim,
    # so we trim it down to get "trailertrash.vim" only).
    def bundle_base_name(bundle)
      bundle_name = bundle
      if bundle.include?("/")
        bundle_name = bundle.split("/")[1]
      end
      bundle_name
    end

    def puts_separator
      puts "-----------------------------"
    end
  end
end
