class SearchController < ApplicationController
  authorize_resource
  # respond_to :html

  def index
    @search_result = Search.find(where_to_search, what_to_search)
    respond_with(@search_result)
  end

  private

  def where_to_search
    params.require(:condition)
  end

  def what_to_search
    params.require(:search)
  end
end
