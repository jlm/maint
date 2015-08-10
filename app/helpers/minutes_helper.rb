module MinutesHelper
	def minute_status_string(minute)
		MinutesController::MINUTE_STATUSES[minute.status]
	end
end
