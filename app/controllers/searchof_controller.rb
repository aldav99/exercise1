class SearchofController < ApplicationController

  def create
    authorize! :create, Searchof
    @results = Searchof.query(params[:anything][:query], params[:anything][:search_type])
  end

end