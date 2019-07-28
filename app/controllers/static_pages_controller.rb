class StaticPagesController < ApplicationController
  def home
    @blt = []
    Project.all.each do |p|
      p.events.each do |e|
        # Negative lookahead: https://www.oreilly.com/library/view/regular-expressions-cookbook/9780596802837/ch05s05.html
        if /(G (ballot|Ballot|recirc|Recirc)|^Sponsor [bB]allot)\b(?![pP]ool)$/ =~ e.name
          if e.date <= Date.today && e.end_date >= Date.today
            @blt << { event: e, project: p }
          end
        end
      end
    end
  end

  def help
  end

  def status
  	@sts = {}
    Minst.all.each do |m|
  		@sts[m.code] = [ m.name, Item.joins(:minst).where("minsts.code = ?", m.code).count ]
  	end
  end

  def active_ballots
    @blt = []
    Project.all.each do |p|
      p.events.each do |e|
        # Negative lookahead: https://www.oreilly.com/library/view/regular-expressions-cookbook/9780596802837/ch05s05.html
        if /(G (ballot|Ballot|recirc|Recirc)|^Sponsor [bB]allot)\b(?![pP]ool)$/ =~ e.name
          if e.date <= Date.today && e.end_date >= Date.today
            @blt << { event: e, project: p }
          end
        end
      end
    end
  end

end
