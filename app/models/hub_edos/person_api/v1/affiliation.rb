module HubEdos
  module PersonApi
    module V1
      class Affiliation
        MATRICULATED_TYPE_CODE = 'APPLICANT'
        MATRICULATED_DETAILS_TO_EXCLUDE = [
          'SIR Completed',
          'Deposit Pending'
        ]

        def initialize(data)
          @data = data || {}
        end

        def as_json(options={})
          {
            type: type,
            detail: detail,
            status: status,
            fromDate: from_date.to_s,
          }.compact
        end

        # a more detailed description for state of the affiliation, such as admitted or retired	string
        def detail
          @data['detail']
        end

        # the date this affiliation became effective
        def from_date
          Date.parse(@data['fromDate']) if @data['fromDate']
        end

        def is_active?
          status.code == 'ACT'
        end

        def is_inactive?
          status.code == 'INA'
        end

        def is_admit_ux?
          type.code == 'ADMT_UX'
        end

        def is_advisor?
          type.code == 'ADVISOR'
        end

        def is_applicant?
          type.code == 'APPLICANT' && detail == 'Applied'
        end

        def is_law?
          type.code == 'LAW'
        end

        def is_graduate?
          type.code == 'GRADUATE'
        end

        def is_pre_sir?
          type.code == 'APPLICANT' && detail == 'Admitted'
        end

        def is_student?
          type.code == 'STUDENT'
        end

        def is_uc_extension?
          type.code == 'EXTENSION'
        end

        def is_undergraduate?
          type.code == 'UNDERGRAD'
        end

        def matriculated_but_excluded?
          type.code == MATRICULATED_TYPE_CODE && MATRICULATED_DETAILS_TO_EXCLUDE.include?(detail)
        end

        # a short descriptor representing the state of the affiliation, such as active or inactive, etc.
        def status
          HubEdos::Common::Reference::Descriptor.new(@data['status']) if @data['status']
        end

        # a short descriptor representing the kind of affiation, such as student or employee, etc.
        def type
          HubEdos::Common::Reference::Descriptor.new(@data['type']) if @data['type']
        end

      end
    end
  end
end
