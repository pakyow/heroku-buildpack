module Pakyow
  module Buildpack
    class Base
      require "pakyow/buildpack/base/steps/install_ruby"
      require "pakyow/buildpack/base/steps/setup_profiled"
      require "pakyow/buildpack/base/steps/bundle_install"
      require "pakyow/buildpack/base/steps/prelaunch"
      require "pakyow/buildpack/base/steps/cleanup"

      attr_reader :config

      def initialize(config)
        @config = config
      end

      def compile
        work_at @config.build_path do
          Steps::InstallRuby.perform(self)
          Steps::SetupProfiled.perform(self)
          Steps::BundleInstall.perform(self)
          Steps::Prelaunch.perform(self)
          Steps::Cleanup.perform(self)
        end
      end

      def work_at(path, &block)
        Dir.chdir(path, &block)
      end
    end
  end
end
