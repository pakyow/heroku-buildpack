require "fileutils"

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
            if @buildpack.config.cached_ruby.exist?
              FileUtils.mkdir_p("vendor/ruby-#{@buildpack.config.ruby_version}")
              system "cd vendor/ruby-#{@buildpack.config.ruby_version} && tar -zxf #{@buildpack.config.cached_ruby}"
            else
              system "git clone https://github.com/rbenv/ruby-build.git"
              system "PREFIX=#{@buildpack.config.vendor_path.join("ruby-build")} ./ruby-build/install.sh"
              system "rm -r ruby-build"

              system "#{ruby_build_options} vendor/ruby-build/bin/ruby-build #{@buildpack.config.ruby_version} #{@buildpack.config.ruby_install_path}"
              system "rm -r vendor/ruby-build"
            end
          end

          private def ruby_build_options
            [
              "RUBY_CONFIGURE_OPTS='--disable-install-doc'",
            ].join(" ")
          end
        end
      end
    end
  end
end
