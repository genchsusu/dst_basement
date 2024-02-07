-- No witherable
AddComponentPostInit("witherable", function(self)
	if self.inst then
		self.inst:DoPeriodicTask(1,function(crop)
			local x,y,z = crop.Transform:GetWorldPosition()
			if TheWorld.Map:IsBasementAtPoint(x,y,z) then
				self:Enable(false)
			end
		end)
	end
end)
