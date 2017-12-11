class SearchController < ApplicationController
  authorize_resource
  # respond_to :html

  def index
    respond_with(@search_result = Question.search(search_params))
  end

  private

  def search_params
    params.require(:search)
  end
end
