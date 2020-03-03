require "fileutils"

require "pakyow/buildpack/step"

module Pakyow
  module Buildpack
    class Base
      module Steps
        class InstallRuby < Step
          def perform
            FileUtils.mkdir_p @buildpack.config.ruby_install_path

            @buildpack.work_at @buildpack.config.ruby_install_path do
              system "wget -q #{ruby_url}"
              system "tar -xzf ruby-#{@buildpack.config.ruby_version}.tgz"
              system "rm ruby-#{@buildpack.config.ruby_version}.tgz"
            end
          end

          private def ruby_url
            "https://s3-external-1.amazonaws.com/heroku-buildpack-ruby/#{@buildpack.config.stack}/ruby-#{@buildpack.config.ruby_version}.tgz"
          end

          # def perform
          #   if @buildpack.config.cached_ruby.exist?
          #     FileUtils.mkdir_p("vendor/ruby-#{@buildpack.config.ruby_version}")
          #     system "cd vendor/ruby-#{@buildpack.config.ruby_version} && tar -zxf #{@buildpack.config.cached_ruby}"
          #   else
          #     system "git clone https://github.com/rbenv/ruby-build.git"
          #     system "PREFIX=#{@buildpack.config.vendor_path.join("ruby-build")} ./ruby-build/install.sh"
          #     system "rm -r ruby-build"

          #     system "#{ruby_build_options} vendor/ruby-build/bin/ruby-build #{@buildpack.config.ruby_version} #{@buildpack.config.ruby_install_path}"
          #     system "rm -r vendor/ruby-build"
          #   end
          # end

          # private def ruby_build_options
          #   [
          #     "RUBY_CONFIGURE_OPTS='--disable-install-doc'",
          #   ].join(" ")
          # end
        end
      end
    end
  end
end
