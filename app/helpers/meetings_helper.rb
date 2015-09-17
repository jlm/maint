module MeetingsHelper
	def make_meeting_name(mtg)
		return "Unknown" if mtg.nil?
		mtg.date.strftime("%b %Y ") + mtg.meetingtype	# "Jan 2015 Interim"
	end
end
