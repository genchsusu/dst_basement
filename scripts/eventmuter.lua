return
{
	PushEvent = function(PushEvent, self, event, data, ...)
		if self.event_muted ~= nil and self.event_muted[event] then
			event = event .. "_muted"
		end
		return PushEvent(self, event, data, ...)
	end,
	
	SetEventMute = function(self, event, mute)
		if self.event_muted == nil then
			self.event_muted = {}
		end
		self.event_muted[event] = mute and true or nil
	end,
}

