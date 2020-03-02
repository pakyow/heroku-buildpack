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
          DEFAULT_RUBY = "2.6.5"

          def perform
            if cached_ruby.exist?
              system "tar -zxf #{cached_ruby}"
            else
              system "git clone https://github.com/rbenv/ruby-build.git"
              system "PREFIX=#{@buildpack.config.vendor_path.join("ruby-build")} ./ruby-build/install.sh"
              system "rm -r ruby-build"

              system "vendor/ruby-build/bin/ruby-build #{ruby_version} #{ruby_install_path}"
              system "tar -zcf #{cached_ruby} #{ruby_install_path}"
            end
          end

          private def ruby_version
            # TODO: Use .ruby-version if present.
            #
            DEFAULT_RUBY
          end

          private def ruby_install_path
            @buildpack.config.vendor_path.join("ruby-#{ruby_version}")
          end

          private def cached_ruby
            @buildpack.config.cache_path.join("ruby-#{ruby_version}.tar.gz")
          end
        end
      end
    end
  end
end
