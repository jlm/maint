class StaticPagesController < ApplicationController
  def home
  end

  def help
  end

  def status
  	@sts = {}
  	MinutesController::MINUTE_STATUSES.each do |code, name|
  		@sts[code] = [ name, Item.where(latest_status: code).count ]
  	end
  end
end
