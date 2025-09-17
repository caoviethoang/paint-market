# frozen_string_literal: true

module SolidusAdmin
  module Properties
    class IndexComponent < SolidusAdmin::BaseComponent
      def initialize(properties:, search:)
        @properties = properties
        @search = search
      end

      private

      attr_reader :properties, :search
    end
  end
end
