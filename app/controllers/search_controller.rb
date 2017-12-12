class SearchController < ApplicationController
  authorize_resource
  # respond_to :html

  def index
    @search_result = ThinkingSphinx.search(search_params)
    respond_with(@search_result)
  end

  private

  def search_params
    params.require(:search)
  end
end
