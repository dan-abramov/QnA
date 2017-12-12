class Search < ApplicationRecord
  def self.find(where_to_search, what_to_search)
    if where_to_search == 'Everywhere'
      ThinkingSphinx.search(what_to_search)
    else
      where_to_search.chop.constantize.search(what_to_search)
    end
  end
end
