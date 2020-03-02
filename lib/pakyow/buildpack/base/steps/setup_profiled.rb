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

            # TODO: Figure out what these need to be after bundling into vendor.
            #
            # ENV["GEM_PATH"] = slug_vendor_base
            # ENV["GEM_HOME"] = slug_vendor_base

            # TODO: Figure this out once we're setting above:
            #
            # add_override "GEM_PATH", ENV["GEM_PATH"]

            add_override "PATH", paths.join(":")
          end

          private def paths
            [
              "$HOME/bin",
              "$HOME/vendor/bundle/bin",
              "$HOME/vendor/bundle/ruby/#{@buildpack.config.ruby_version}/bin",
              "$HOME/vendor/ruby-#{@buildpack.config.ruby_version}/bin",
              "$PATH"
            ]
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
