require "pakyow/buildpack/step"

module Pakyow
  module Buildpack
    class Base
      module Steps
        class Cleanup < Step
          def perform
            system "rm -rf .git"
          end
        end
      end
    end
  end
end
