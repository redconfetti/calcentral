module Cached
  class Terms
    extend Cache::Cacheable

    def get
      self.class.fetch_from_cache do
        EdoOracle::Queries.get_terms
      end
    end
  end
end
