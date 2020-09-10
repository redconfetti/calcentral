module HubEdos
  module PersonApi
    module V1
      class Affiliation
        STATUS_ACTIVE = 'ACT'
        STATUS_INACTIVE = 'INA'
        STATUS_ERROR = 'ERR'

        TYPE_ADMIT_UX = 'ADMT_UX'
        TYPE_ADVISOR = 'ADVISOR'
        TYPE_APPLICANT = 'APPLICANT'
        TYPE_EXTENSION = 'EXTENSION'
        TYPE_LAW = 'LAW'
        TYPE_GRADUATE = 'GRADUATE'
        TYPE_STUDENT = 'STUDENT'
        TYPE_UNDERGRADUATE = 'UNDERGRAD'

        TYPE_DETAIL_APPLICANT = 'Applied'
        TYPE_DETAIL_PRE_SIR = 'Admitted'

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
            fromDate: from_date,
          }
        end

        # a more detailed description for state of the affiliation, such as admitted or retired	string
        def detail
          @data['detail']
        end

        # the date this affiliation became effective
        def from_date
          Date.parse(@data['fromDate']) if @data['fromDate']
        end

        def active?
          status.code == STATUS_ACTIVE
        end

        def inactive?
          !active?
        end

        def admit_ux?
          type.code == TYPE_ADMIT_UX
        end

        def advisor?
          type.code == TYPE_ADVISOR
        end

        def applicant?
          type.code == TYPE_APPLICANT && detail == TYPE_DETAIL_APPLICANT
        end

        def law?
          type.code == TYPE_LAW
        end

        def graduate?
          type.code == TYPE_GRADUATE
        end

        def pre_sir?
          type.code == TYPE_APPLICANT && detail == TYPE_DETAIL_PRE_SIR
        end

        def student?
          type.code == TYPE_STUDENT
        end

        def uc_extension?
          type.code == TYPE_EXTENSION
        end

        def undergraduate?
          type.code == TYPE_UNDERGRADUATE
        end

        def matriculated_but_excluded?
          type.code == TYPE_APPLICANT && MATRICULATED_DETAILS_TO_EXCLUDE.include?(detail)
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
