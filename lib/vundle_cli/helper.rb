module VundleCli
  module Helper
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

    def plugin_base_name(plugin)
      File.basename(plugin)
    end

    # Get the trimmed name of the plugin,
    # e.g. remove prefix, suffix "vim-", "-vim", ".vim".
    def plugin_trim_name(plugin_name)
      plugin_name.gsub(/(vim-|-vim|\.vim)/, '')
    end

    def puts_separator
      say "-----------------------------"
    end
  end
end
