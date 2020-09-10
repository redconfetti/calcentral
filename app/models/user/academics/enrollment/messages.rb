# Provides enrollment messages that are NOT user, term, career, or design specific
class User::Academics::Enrollment::Messages
  def as_json(options={})
    {
      waitlistedUnitsWarning: waitlisted_units_warning
    }
  end

  def waitlisted_units_warning
    msg = CampusSolutions::MessageCatalog.get_message_collection([:waitlisted_units_warning])
    msg.to_h[:waitlisted_units_warning]
  end
end
