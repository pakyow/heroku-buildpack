module Pakyow
  module Buildpack
    class Base
      def initialize(config)
        @config = config
      end

      def compile
        puts "compiling with config #{@config.inspect}"

        # Look at buildpack/ruby.rb for more, but essentially follow the steps in #compile.
        # https://github.com/heroku/heroku-buildpack-ruby
      end
    end
  end
end
