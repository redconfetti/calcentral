class Term
  attr_accessor :id
  attr_accessor :type
  attr_accessor :year
  attr_accessor :code
  attr_accessor :descr
  attr_accessor :career_code
  attr_accessor :begin_date
  attr_accessor :end_date
  attr_accessor :class_begin_date
  attr_accessor :class_end_date
  attr_accessor :instruction_end_date
  attr_accessor :grades_entered_date
  attr_accessor :end_drop_add_date
  attr_accessor :is_summer

  def initialize(attrs={})
    attrs.each do |key, value|
      method = "#{key.to_s.underscore}="
      self.send(method, value) if respond_to?(method)
    end
  end

  def semester_name
    @type
  end

  def summer?
    is_summer == 'Y'
  end
end
