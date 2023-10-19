# frozen_string_literal: true
def find_mismatched_minsts_items
  dufflist = []
  Item.all.each do |item|
    calculated = item.minutes.date_valid.order(:date, :id).last.minst
    if item.minst.code != calculated.code
      print "#{item.number}: current minsts #{item.minst.code} should be #{calculated.code}"
      dufflist << [ item.number, item.minst.name, calculated.name ]
      item.save!
      abort "Item #{item.number} was not fixed!" unless item.minst.code == calculated.code
    end
  end
  p dufflist
end
