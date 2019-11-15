module MyClasses::ClassesModule
  extend self

  def initialize(uid)
    @uid = uid
  end

  def current_term
    @current_term ||= Berkeley::Terms.fetch.current
  end

  def grading_in_progress_term
    @grading_in_progress_term ||= Berkeley::Terms.fetch.grading_in_progress
  end
end
