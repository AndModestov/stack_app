class Search
  TYPES = %w(all questions answers comments users).freeze

  def self.request(content, context)
    query = Riddle::Query.escape(content)

    return [] unless TYPES.include? context

    if context == 'all'
      ThinkingSphinx.search query
    else
      model = context.singularize.classify.constantize
      model.search query
    end
  end
end
