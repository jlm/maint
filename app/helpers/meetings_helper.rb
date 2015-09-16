module MeetingsHelper
	def make_meeting_name(mtg)
		if mtg.date.day == 1
			mtg.date.strftime("%b %Y ") + mtg.meetingtype	# "Jan 2015 Interim "
		else
			mtg.date.strftime("%-d %b %Y ") + mtg.meetingtype	# "6 Jan 2015 Interim "
		end
	end
end
