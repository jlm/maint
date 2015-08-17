module MinutesHelper
	def minute_status_string(status)
		MinutesController::MINUTE_STATUSES[status]
	end
end
