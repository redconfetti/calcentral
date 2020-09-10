module User
  module Finances
    module FinancesConcern
      extend ActiveSupport::Concern

      included do
        def billing_items
          @billing_items ||= User::Finances::BillingItems.new(self)
        end

        def billing_summary
          @billing_summary ||= User::Finances::BillingSummary.new(self)
        end
      end
    end
  end
end
