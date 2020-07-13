require "fileutils"

require "pakyow/buildpack/step"

module Pakyow
  module Buildpack
    class Base
      module Steps
        class BundleInstall < Step
          def perform
            system "gem install bundler -v #{@buildpack.config.bundler_version} -f --no-doc"

            write_bundle_shim

            if cached?
              @buildpack.work_at @buildpack.config.vendor_path do
                system "tar -zxf #{cache_path}"
              end
            end

            system "HOME=#{@buildpack.config.build_path} bundle config without 'development:test'"
            system "HOME=#{@buildpack.config.build_path} bundle config deployment true"
            system "HOME=#{@buildpack.config.build_path} bundle config path vendor/bundle"
            system "HOME=#{@buildpack.config.build_path} bundle install"

            @buildpack.work_at @buildpack.config.vendor_path do
              system "tar -zcf #{cache_path} bundle"
            end
          end

          private def cached?
            cache_path.exist?
          end

          private def cache_path
            @buildpack.config.cache_path.join("bundler.tar.gz")
          end

          private def write_bundle_shim
            ruby_bin_path = @buildpack.config.ruby_install_path.join("bin")
            bundle_shim_path = ruby_bin_path.join("bundle")
            FileUtils.mkdir_p(ruby_bin_path)

            File.open(bundle_shim_path, "w") do |file|
              file.print <<~BUNDLE
                #!/usr/bin/env ruby
                require 'rubygems'

                version = "#{@buildpack.config.bundler_version}"

                if ARGV.first
                  str = ARGV.first
                  str = str.dup.force_encoding("BINARY") if str.respond_to? :force_encoding
                  if str =~ /\A_(.*)_\z/ and Gem::Version.correct?($1) then
                    version = $1
                    ARGV.shift
                  end
                end

                if Gem.respond_to?(:activate_bin_path)
                load Gem.activate_bin_path('bundler', 'bundle', version)
                else
                gem "bundler", version
                load Gem.bin_path("bundler", "bundle", version)
                end
              BUNDLE
            end

            FileUtils.chmod(0755, bundle_shim_path)
          end
        end
      end
    end
  end
end
