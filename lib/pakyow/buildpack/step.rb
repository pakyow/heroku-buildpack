module Pakyow
  module Buildpack
    class Step
      def self.perform(buildpack)
        new(buildpack).perform
      end

      def initialize(buildpack)
        @buildpack = buildpack
      end

      def perform
        raise NotImplementedError
      end
    end
  end
end
