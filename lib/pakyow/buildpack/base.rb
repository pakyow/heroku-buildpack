module Pakyow
  module Buildpack
    class Base
      require "pakyow/buildpack/base/steps/install_ruby"

      attr_reader :config

      def initialize(config)
        @config = config
      end

      def compile
        # Look at buildpack/ruby.rb for more, but essentially follow the steps in #compile.
        # https://github.com/heroku/heroku-buildpack-ruby

        work_at @config.build_path do
          Steps::InstallRuby.perform(self)
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
