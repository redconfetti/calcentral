class User::Academics::Enrollment::Date
  attr_accessor :datetime
  alias :date_time :datetime

  def initialize(options={})
    if options.blank? || (options.to_h[:epoch].blank? && options.to_h[:iso_8601_string].blank?)
      raise RuntimeError, 'Options must specify value for :epoch or :iso_8601_string'
    end
    @datetime = DateTime.strptime(options[:epoch].to_s,'%s') if options.to_h[:epoch]
    @datetime = DateTime.parse(options[:iso_8601_string]).utc.to_datetime if options.to_h[:iso_8601_string]
  end

  def utc
    datetime.iso8601
  end

  def pacific
    datetime.in_time_zone(pacific_timezone).iso8601
  end

  def as_json(options={})
    {
      epoch: @datetime.to_i,
      utc: utc,
      pacific: pacific,
    }
  end

  private

  def pacific_timezone
    ActiveSupport::TimeZone.new('America/Los_Angeles')
  end
end
