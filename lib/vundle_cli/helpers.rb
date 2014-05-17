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

    def bundle_base_name(bundle)
      File.basename(bundle)
    end

    # Get the trimmed name of the bundle,
    # e.g. remove prefix, suffix "vim-", "-vim", ".vim".
    def bundle_trim_name(bundle_name)
      bundle_name.gsub(/(vim|-|\.)/, '')
    end

    def puts_separator
      puts "-----------------------------"
    end
  end
end
