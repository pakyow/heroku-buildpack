require "pakyow/buildpack/step"

module Pakyow
  module Buildpack
    class Base
      module Steps
        class BundleInstall < Step
          def perform
            # TODO: I haven't tried this (things are sort of working now), but I'd like to see if we
            # can avoid interacting with anything in `/app` once the compiled ruby is moved back.
            #
            # once installing bundler like below, see if we can run it through bin/bundler or something...
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
