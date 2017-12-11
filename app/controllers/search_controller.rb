class SearchController < ApplicationController
  authorize_resource

  def index
    @search_result = Question.search(search_params)
    redirect_to search_index_path
  end

  private

  def search_params
    params.permit(:search)
  end
end
