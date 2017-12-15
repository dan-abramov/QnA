class Search < ApplicationRecord
  def self.find(klass, content)
    if klass == 'Everywhere'
      ThinkingSphinx.search(content)
    else
      klass.chop.constantize.search(content)
    end
  end
end
