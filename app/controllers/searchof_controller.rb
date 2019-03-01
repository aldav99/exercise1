class SearchofController < ApplicationController

  def create
    puts "---------#{params[:anything][:query]}"
    puts "---------#{params[:anything][:search_type]}"
    puts "---------------------------------------"

    @results = Searchof.query(params[:anything][:query], params[:anything][:search_type])
  end

end