class SearchController < ApplicationController
  authorize_resource

  def index
    @search_list = Search.request(params[:search_content], params[:search_context])
  end
end
