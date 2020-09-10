class User::Academics::Enrollment::Date
  attr_accessor :datetime
  alias :date_time :datetime
  alias :date_time= :datetime=

  PACIFIC_TIMEZONE = ActiveSupport::TimeZone.new('America/Los_Angeles')

  def self.from_unix_timestamp(unix_timestamp)
    new.tap {|d| d.datetime = DateTime.strptime(unix_timestamp.to_s,'%s') }
  end

  def self.from_iso_8601(iso_8601_string)
    new.tap {|d| d.datetime = DateTime.parse(iso_8601_string).utc.to_datetime }
  end

  def initialize(datetime: nil)
    @datetime = datetime
  end

  def unix_timestamp
    datetime.to_i
  end

  def utc
    datetime.iso8601
  end

  def pacific
    datetime.in_time_zone(PACIFIC_TIMEZONE).iso8601
  end

  def as_json(options={})
    {
      unixTimestamp: unix_timestamp,
      utc: utc,
      pacific: pacific,
    }
  end
end
