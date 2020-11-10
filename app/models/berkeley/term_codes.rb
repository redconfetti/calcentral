module Berkeley
  module TermCodes
    extend self

    SUMMER_SESSIONS = {
      '6W1' => 'A',
      '10W' => 'B',
      '8W' => 'C',
      '6W2' => 'D',
      '3W' => 'E'
    }

    def codes
      # UC Berkeley only offers Spring, Summer, and Fall courses. Before 1982, however, it was on the
      # same quarterly system as other UC campuses.
      @codes ||= {
        :A => 'Winter',
        :B => 'Spring',
        :C => 'Summer',
        :D => 'Fall'
      }
    end

    def names
      @names ||= init_names
    end

    def to_edo_id(term_yr, term_cd)
      term_yr = term_yr.to_s
      edo_year = term_yr[0] + term_yr[2..3]
      season_code = legacy_to_edo_code.fetch(term_cd)
      edo_year + season_code
    end

    def from_edo_id(edo_term_id)
      # CS term ID is a compressed 4 digit representation of the year and term.
      # This ID compresses the year by removing the hundreds place in the year number.
      # For example, year 2017 would be compassed to "217" and year 1965 would be compressed to "165"
      # Finally, the term code is appended to the end. For example fall 1965 would be compressed to "1658"
      # because fall term code is "8"

      edo_term_id = edo_term_id.to_s
      # To reverse out the year from the CS term ID, the hundreds place digit needs to be added back
      hundreds_digit =  edo_term_id >= '2000' ? '0' : '9'
      legacy_term_cd = edo_to_legacy_code.fetch(edo_term_id[3])
      legacy_term_yr = edo_term_id[0] + hundreds_digit + edo_term_id[1..2]
      {:term_yr => legacy_term_yr, :term_cd => legacy_term_cd}
    end

    # TODO: Deprecated. Use Term#code.
    def edo_id_to_code(edo_term_id)
      self.from_edo_id(edo_term_id).values_at(:term_yr, :term_cd).join '-'
    end

    def edo_id_is_summer?(edo_term_id)
      return self.from_edo_id(edo_term_id)[:term_cd] == 'C'
    end

    def slug_to_edo_id(slug)
      code = self.from_slug slug
      self.to_edo_id(code[:term_yr], code[:term_cd])
    end

    # Campus Solutions tends to call terms '2016 Fall' instead of the more idiomatic 'Fall 2016'.
    def normalized_english(term_name)
      if term_name.present? && (m = term_name.strip.match /\A(\d{4})\s(\w+)\Z/)
        "#{m[2]} #{m[1]}"
      else
        term_name
      end
    end

    def to_english(term_yr, term_cd)
      term = codes[term_cd.to_sym]
      unless term
        raise ArgumentError, "No such term code: #{term_cd}"
      end
      "#{term} #{term_yr}"
    end

    def to_abbreviation(term_yr, term_cd)
      # 'fa14', 'sp15'
      term = codes[term_cd.to_sym]
      unless term
        raise ArgumentError, "No such term code: #{term_cd}"
      end
      "#{term.downcase[0,2]}#{term_yr[-2,2]}"
    end

    def to_slug(term_yr, term_cd)
      term = codes[term_cd.to_sym]
      unless term
        raise ArgumentError, "No such term code: #{term_cd}"
      end
      "#{term.downcase}-#{term_yr}"
    end

    def to_code(name)
      name = names[name.downcase]
      unless name
        raise ArgumentError, "No such term code: #{name}"
      end
      name
    end

    def from_english(str)
      if (parsed = /(?<term_name>[[:alpha:]]+) (?<term_yr>\d+)/.match(str)) && (term_cd = to_code(parsed[:term_name]))
        {
          term_yr: parsed[:term_yr],
          term_cd: term_cd
        }
      else
        nil
      end
    end

    def from_slug(slug)
      if (parsed = /(?<term_name>[[:alpha:]]+)-(?<term_yr>\d+)/.match(slug)) && (term_cd = to_code(parsed[:term_name]))
        {
          term_yr: parsed[:term_yr],
          term_cd: term_cd
        }
      else
        nil
      end
    end

    def legacy?(term_yr, term_cd)
      to_edo_id(term_yr, term_cd) <= slug_to_edo_id(Settings.terms.legacy_cutoff)
    end

    private

    def init_names
      names = {}
      codes.keys.each do |key|
        name = codes[key]
        names[name.downcase] = key.to_s
      end
      names
    end

    def legacy_to_edo_code
      @edo_year_codes ||= {
        'B' => '2',
        'C' => '5',
        'D' => '8',
        'A' => '0',
      }
    end

    def edo_to_legacy_code
      legacy_to_edo_code.invert
    end
  end
end
