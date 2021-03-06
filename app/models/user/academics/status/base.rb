module User
  module Academics
    module Status
      class Base < SimpleDelegator
        include ::User::Academics::Status::Messages
        include ::User::Academics::Status::Severity

        def as_json(options={})
          {
            message: message,
            severity: severity,
            detailedMessageHTML: detailed_message_html,
            inPopover: in_popover?,
            badgeCount: badge_count
          }
        end

        def message
        end

        def in_popover?
          false
        end

        def badge_count
          0
        end

        def message_catalog(key)
          CampusSolutions::MessageCatalog.get_message(key)[:descrlong]
        end
      end
    end
  end
end
