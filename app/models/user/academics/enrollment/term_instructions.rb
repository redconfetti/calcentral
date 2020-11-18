class User::Academics::Enrollment::TermInstructions
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def all
    @all ||= term_ids.collect do |term_id|
      ::User::Academics::Enrollment::TermInstruction.new(user, term_id)
    end
  end

  def find_by_term_id(term_id)
    all.select do |term_instruction|
      term_instruction.term_id == term_id
    end.first
  end

  def as_json(options={})
    all.map(&:as_json)
  end

  private

  def term_ids
    @term_ids ||= begin
      enrollment_terms = User::Academics::Enrollment::Terms.new(user)
      enrollment_terms.all.collect(&:term_id).uniq
    end
  end
end
