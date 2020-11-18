# Serves 'Class Enrollment' card on 'My Academics' page
class Api::EnrollmentResources
  attr_accessor :user

  def initialize(user_id)
    @user = User::Current.new(user_id)
  end

  delegate :enrollment_term_instructions, :enrollment_presentations,
    :enrollment_messages, :enrollment_links, :has_holds?, to: :user

  def as_json(options={})
    {
      presentations: enrollment_presentations,
      termInstructions: enrollment_term_instructions,
      links: enrollment_links,
      messages: enrollment_messages,
      hasHolds: has_holds?,
    }
  end
end
