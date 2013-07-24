class LadderController < ApplicationController
  def bounty
    i = 0
    ladder_array = Bounty.top_bounty(0).each do |row|
      i += 1
      row.merge!({ :pos => i })
    end
    p ladder_array
    @ladder = ladder_array.paginate(:page => params[:page], :per_page => 10)
    render :ladder
  end

  def incursion
    i = 0
    ladder_array = Incursion.top_incursion(0).each do |row|
      i += 1
      row.merge!({ :pos => i })
    end
    p ladder_array
    @ladder = ladder_array.paginate(:page => params[:page], :per_page => 10)    
    render :ladder
  end
end
