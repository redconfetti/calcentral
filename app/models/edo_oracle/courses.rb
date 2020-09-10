class EdoOracle::Courses < EdoOracle::Connection
  include ActiveRecordHelper

  def self.all_by_display_name(display_name)
    safe_query <<-SQL
      SELECT * FROM SISEDO.API_COURSEV01_MVW
      WHERE "displayName" = '#{display_name}'
      ORDER BY "fromDate"
    SQL
  end
end
