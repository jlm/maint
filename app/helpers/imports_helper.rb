module ImportsHelper
	# translate a Ruby Spreadsheet column number to an Excel column name
	def num2alpha(n)
		r = ""
		while n >= 0 do
			r = ('A'..'Z').to_a[n%26] + r
			n = (n/26) - 1
		end
		r
	end
end
