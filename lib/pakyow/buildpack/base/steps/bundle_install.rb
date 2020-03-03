require "pakyow/buildpack/step"

module Pakyow
  module Buildpack
    class Base
      module Steps
        class BundleInstall < Step
          def perform
            # TODO: For tomorrow...
            #
            # * finish the below
            # * see if the whole moving vendor thing is necessary
            #   * hopefully because of below we're now installing to build path
            #   * also check the .bundle/config move... that should be in the build path now?
            # * figure out the correct cache strategy
            # * move on to release
            #   * emit other addons (postgres, redis)
            #   * run the prelaunch stuff


            system "vendor/ruby-#{@buildpack.config.ruby_version}/bin/gem install bundler -v #{@buildpack.config.bundler_version} -f --no-doc"

            system "vendor/ruby-#{@buildpack.config.ruby_version}/bin/bundle config without 'development:test'"
            system "vendor/ruby-#{@buildpack.config.ruby_version}/bin/bundle config deployment true"
            system "vendor/ruby-#{@buildpack.config.ruby_version}/bin/bundle config path vendor/bundle"

            # TODO: Noticing binstubs in vendor/bundle/bin and app/bin... what gives?
            #
            system "vendor/ruby-#{@buildpack.config.ruby_version}/bin/bundle config binstubs vendor/bundle/bin"

            # TODO: Why we gotta set the gemfile explicitly?
            #
            system "vendor/ruby-#{@buildpack.config.ruby_version}/bin/bundle install --gemfile #{@buildpack.config.build_path.join("Gemfile")}"

            # TODO: Make sure this goes in vendor/bundle/bin.
            #
            # system "bundle binstubs"

            # TODO: Try to avoid deprecations:
            #   * bundle config set without 'development:test'
            #   * bundle binstubs (maybe set the binstubs path)
            #   * bundle config deployment true (maybe set config)
            #
            # system "bundle install --without development:test --path #{@buildpack.config.bundler_path} --binstubs #{@buildpack.config.bundler_binstubs_path}"
          end
        end
      end
    end
  end
end
