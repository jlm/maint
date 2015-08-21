module MeetingsHelper
	def make_meeting_name(mtg)
		mtg.date.strftime("%b %Y ") + mtg.meetingtype	# "Jan 2015 Interim"
	end
end
