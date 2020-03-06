require "pakyow/buildpack/step"

module Pakyow
  module Buildpack
    class Base
      module Steps
        class Prelaunch < Step
          def perform
            system "pakyow prelaunch:build -e production"
          end
        end
      end
    end
  end
end
