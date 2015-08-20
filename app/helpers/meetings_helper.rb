module MeetingsHelper
	def make_meeting_name(mtg)
		mtg.date.strftime("%b %Y ") + mtg.meetingtype + " meeting"
	end
end
