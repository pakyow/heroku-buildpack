require "pakyow/buildpack/step"

module Pakyow
  module Buildpack
    class Base
      module Steps
        class BundleInstall < Step
          def perform
            system "gem install bundler -v #{@buildpack.config.bundler_version} -f --no-doc"

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
        end
      end
    end
  end
end
