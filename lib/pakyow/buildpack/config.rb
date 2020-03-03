require "pathname"

module Pakyow
  module Buildpack
    class Config
      BLACKLIST = %w(PATH GEM_PATH GEM_HOME GIT_DIR JRUBY_OPTS JAVA_OPTS JAVA_TOOL_OPTIONS).freeze

      DEFAULT_RUBY = "2.6.5"
      DEFAULT_BUNDLER = "2.1.4"

      attr_reader :build_path, :cache_path, :vendor_path

      def initialize(build_path, cache_path, env_path)
        @build_path = Pathname.new(build_path)
        @cache_path = Pathname.new(cache_path)
        @vendor_path = @build_path.join("vendor")
        @env = load_env(env_path)
      end

      def stack
        ENV["STACK"]
      end

      def ruby_version
        # TODO: Use .ruby-version if present. If not, pull from:
        #
        #   Bundler::LockfileParser.new(File.read("Gemfile.lock")).ruby_version
        #
        DEFAULT_RUBY
      end

      def ruby_install_path
        # Pathname.new("/app/vendor/ruby-#{ruby_version}")
        @vendor_path.join("ruby-#{ruby_version}")
      end

      def cached_ruby
        cache_path.join("ruby-#{ruby_version}.tar.gz")
      end

      def bundler_version
        # if bundled?
        #   bundler_options.bundler_version || DEFAULT_BUNDLER
        # else
        #   DEFAULT_BUNDLER
        # end

        DEFAULT_BUNDLER
      end

      def bundler_path
        @vendor_path.join("bundle")
      end

      def bundler_binstubs_path
        bundler_path.join("bin")
      end

      private def load_env(path)
        path = Pathname.new(path.to_s)

        if path.exist? && path.directory?
          path.each_child.each_with_object({}) { |file, env|
            key = file.basename.to_s

            unless blacklisted?(key)
              env[key] = file.read.strip
            end
          }
        else
          {}
        end
      end

      private def blacklisted?(key)
        BLACKLIST.include?(key.to_s)
      end

      # private def bundled?
      #   gemfile_lock_path.exist?
      # end

      # private def bundler_options
      #   require "bundler"

      #   Bundler::LockfileParser.new(gemfile_lock_path.read)
      # end

      # private def gemfile_lock_path
      #   @build_path.join("Gemfile.lock")
      # end
    end
  end
end
