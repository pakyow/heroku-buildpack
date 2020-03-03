require "fileutils"

require "pakyow/buildpack/step"

module Pakyow
  module Buildpack
    class Base
      module Steps
        class SetupProfiled < Step
          def perform
            FileUtils.mkdir_p(profiled_path)

            add_default "LANG", "en_US.UTF-8"

            add_override "PATH", paths
            add_override "LD_LIBRARY_PATH", ld_library_paths

            ENV["PATH"] = paths(@buildpack.config.build_path)
            ENV["LD_LIBRARY_PATH"] = ld_library_paths(@buildpack.config.build_path)
          end

          private def paths(prefix = "$HOME")
            [
              File.join(prefix, "bin"),
              File.join(prefix, "vendor/bundle/bin"),
              File.join(prefix, "vendor/bundle/ruby/#{@buildpack.config.ruby_version}/bin"),
              File.join(prefix, "vendor/ruby-#{@buildpack.config.ruby_version}/bin"),
              "/usr/local/bin:/usr/bin:/bin"
            ].join(":")
          end

          private def ld_library_paths(prefix = "$HOME")
            [
              File.join(prefix, "vendor/ruby-#{@buildpack.config.ruby_version}/lib")
            ].join(":")
          end

          private def add_default(key, value)
            add "export #{key}=${#{key}:-#{value}}"
          end

          private def add_override(key, value)
            add "export #{key}=\"#{value.gsub('"', '\"')}\""
          end

          private def profiled_path
            @buildpack.config.build_path.join(".profile.d")
          end

          private def profiled_pakyow_path
            profiled_path.join("pakyow.sh")
          end

          private def add(string)
            File.open(profiled_pakyow_path, "a") do |file|
              file.puts string
            end
          end
        end
      end
    end
  end
end
