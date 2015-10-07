class StaticPagesController < ApplicationController
  def home
  end

  def help
  end

  def status
  	@sts = {}
    Minst.all.each do |m|
  		@sts[m.code] = [ m.name, Item.joins(:minst).where("minsts.code = ?", m.code).count ]
  	end
  end
end
