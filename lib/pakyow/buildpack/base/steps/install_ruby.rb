require "pakyow/buildpack/step"

module Pakyow
  module Buildpack
    class Base
      module Steps
        # Installs Ruby via `ruby-build`, caching it for future builds.
        #
        # TODO: Try to pull from S3 before building or fetching from local cache.
        #
        class InstallRuby < Step
          def perform
            if cached_ruby.exist?
              system "unzip #{cached_ruby} #{ruby_install_path}"
            else
              system "git clone https://github.com/rbenv/ruby-build.git"
              system "PREFIX=#{@buildpack.config.vendor_path.join("ruby-build")} ./ruby-build/install.sh"
              system "rm -r ruby-build"

              system "vendor/ruby-build/bin/ruby-build #{@buildpack.config.ruby_version} #{ruby_install_path}"
              system "zip -r #{cached_ruby} #{ruby_install_path}"
            end
          end

          private def ruby_install_path
            @buildpack.config.vendor_path.join("ruby-#{@buildpack.config.ruby_version}")
          end

          private def cached_ruby
            @buildpack.config.cache_path.join("ruby-#{@buildpack.config.ruby_version}.zip")
          end
        end
      end
    end
  end
end
