module Pakyow
  module Buildpack
    class Base
      require "pakyow/buildpack/base/steps/install_ruby"
      require "pakyow/buildpack/base/steps/setup_profiled"
      require "pakyow/buildpack/base/steps/bundle_install"

      attr_reader :config

      def initialize(config)
        @config = config
      end

      def compile
        # Look at buildpack/ruby.rb for more, but essentially follow the steps in #compile.
        # https://github.com/heroku/heroku-buildpack-ruby

        work_at @config.build_path do
          Steps::InstallRuby.perform(self)
          Steps::SetupProfiled.perform(self)
          Steps::BundleInstall.perform(self)

          # cache the compiled ruby for future builds (might cache the entire vendor dir)
          system "cd #{@config.ruby_install_path} && tar -zcf #{@config.cached_ruby} *"

          # move the vendor directory into the build directory
          FileUtils.mkdir_p("vendor")
          system "cp -r /app/vendor/* vendor"

          FileUtils.rm_r(".bundle")
          FileUtils.mkdir_p(".bundle")
          system "cp -r /app/.bundle/* .bundle"

          # cleanup
          #   - remove git dirs (see post_bundler)
        end
      end

      private def work_at(path)
        original_path = Dir.pwd
        Dir.chdir(@config.build_path)
        yield
      ensure
        Dir.chdir(original_path)
      end
    end
  end
end
