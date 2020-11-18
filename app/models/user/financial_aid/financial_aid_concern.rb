module User
  module FinancialAid
    module FinancialAidConcern
      extend ActiveSupport::Concern

      included do
        def aid_years
          @aid_years ||= User::FinancialAid::AidYears.new(self)
        end

        def award_comparison
          @award_comparison ||= User::FinancialAid::AwardComparison.new(self)
        end

        def award_comparison_for_aid_year_and_date(aid_year, effective_date)
          @award_comparison_data ||= User::FinancialAid::AwardComparisonData.new(self, aid_year, effective_date)
        end
      end
    end
  end
end
