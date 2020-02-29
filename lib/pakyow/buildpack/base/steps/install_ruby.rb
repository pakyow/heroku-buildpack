require "pakyow/buildpack/step"

module Pakyow
  module Buildpack
    class Base
      module Steps
        class InstallRuby < Step
          "https://s3-external-1.amazonaws.com/heroku-buildpack-ruby"

          def perform
            puts "performing install ruby"
          end
        end
      end
    end
  end
end
