class Search
  TYPES = %w(all questions answers comments users).freeze

  def self.request(content, context)
    query = Riddle::Query.escape(content)

    if context == 'all'
      ThinkingSphinx.search content
    else
      model = context.singularize.classify.constantize
      model.search query
    end
  end
end
