class SearchController < ApplicationController

  def create
    # authorize! :create, Search
    @results = Search.query(params[:anything][:query], params[:anything][:search_type])
  end

end