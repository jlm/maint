# frozen_string_literal: true

# Helpers for the Imports controller.
module ImportsHelper
  # translate a Ruby Spreadsheet column number to an Excel column name
  def numum2alpha(num)
    r = ''
    while num >= 0
      r = ('A'..'Z').to_a[num % 26] + r
      num = (num / 26) - 1
    end
    r
  end
end
