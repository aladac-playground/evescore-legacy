class SearchController < ApplicationController
  def ajax
    @q1 = Rat.search(params[:q])
    @q2 = Char.where("anon <> 1").search(params[:q])
    rats = @q1.result
    chars = @q2.result
    
    @search = []
    rats.each do |rat|
      tmp = {
        name: rat.name,
        id: rat.id,
        kind: "Rat",
        image: "Type",
        image_type: "png"
      }
      @search.push tmp
    end
    chars.each do |char|
      tmp = {
        name: char.name,
        id: char.id,
        kind: "Character",
        image: "Character",
        image_type: "jpg"
      }
      @search.push tmp
    end

    respond_to do |format|
      format.json { render :json => @search }
    end
  end

  def ajax_rats
    @q1 = Rat.search(params[:q])
    rats = @q1.result
    
    @search = []
    rats.each do |rat|
      tmp = {
        name: rat.name,
        id: rat.id,
        kind: "Rat",
        image: "Type",
        image_type: "png"
      }
      @search.push tmp
    end

    respond_to do |format|
      format.json { render :json => @search }
    end
  end


  def result
    redirect_to root_path if params[:q].nil?
    @q1 = Rat.search(params[:q])
    @q2 = Char.search(params[:q])
    @rat_result = @q1.result
    @char_result = @q2.result
    
    if @char_result.length == 1
      redirect_to @char_result.first
    elsif @rat_result.length == 1
      redirect_to @rat_result.first
    elsif @rat_result.length == 0 and @char_result.length == 0
      redirect_to root_path
    end 
  end
end
