class Searchof < ApplicationRecord
  SEARCH = %w(all question answer comment user)

  def self.query(request, search_type)
    # search_type = SEARCH
    request = ThinkingSphinx::Query.escape(request)
    return [] unless SEARCH.include? search_type
    if search_type == 'all'
      ThinkingSphinx.search request
    else
      search_type.classify.constantize.search request
    end
  end

end