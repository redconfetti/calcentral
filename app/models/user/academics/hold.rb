module User
  module Academics
    class Hold
      attr_reader :hold

      delegate :type, :reason, :type_code, :type_description, to: :hold

      def initialize(hold)
        @hold = hold
      end

      def calgrant?
        type_code == 'F06'
      end

      def formal_description
        hold.reason_formal_description
      rescue NoMethodError
      end

      def term_id
        hold.from_term_id
      rescue NoMethodError
      end
    end
  end
end
