class SearchController < ApplicationController
  authorize_resource
  # respond_to :html

  def index
    respond_with(@search_result = Search.find(klass, content))
  end

  private

  def klass
    params.require(:condition)
  end

  def content
    params.require(:search)
  end
end
