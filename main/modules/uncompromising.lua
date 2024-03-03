-- In order to be compatible with uncompromising, hide the snowover and um_stormover overlays when in basement
AddClassPostConstruct("widgets/snowover", function(self)
    local OriginalOnUpdate = self.OnUpdate
    local OriginalSnowOn = self.SnowOn
    local OriginalToggleUpdating = self.ToggleUpdating

    self.OnUpdate = function(self, dt)
        if self.owner and self.owner:IsInBasement() then
            self:Hide()
            TheFocalPoint.SoundEmitter:KillSound("snowstorm")
            return
        end
        OriginalOnUpdate(self, dt)
    end

    self.SnowOn = function(self)
        if self.owner and self.owner:IsInBasement() or not TheWorld.state.iswinter then
            self:Hide()
            TheFocalPoint.SoundEmitter:KillSound("snowstorm")
            self:StopUpdating()
        else
            OriginalSnowOn(self)
        end
    end

    self.ToggleUpdating = function(self)
        if self.owner and self.owner:IsInBasement() or not TheWorld.state.iswinter then
            self:Hide()
            TheFocalPoint.SoundEmitter:KillSound("snowstorm")
            self:StopUpdating()
        else
            OriginalToggleUpdating(self)
        end
    end
end)

AddClassPostConstruct("widgets/um_stormover", function(self)
    local OriginalOnUpdate = self.OnUpdate
    local OriginalToggleUpdating = self.ToggleUpdating

    self.OnUpdate = function(self, dt)
        if self.owner and self.owner:IsInBasement() then
            self:Hide()
            if TheFocalPoint and TheFocalPoint.SoundEmitter then
                TheFocalPoint.SoundEmitter:KillSound("um_storm_rain")
            end
            return
        end
        OriginalOnUpdate(self, dt)
    end

    self.ToggleUpdating = function(self)
        if self.owner and self.owner:IsInBasement() then
            self:Hide()
            if TheFocalPoint and TheFocalPoint.SoundEmitter then
                TheFocalPoint.SoundEmitter:KillSound("um_storm_rain")
            end
            self:StopUpdating()
        else
            OriginalToggleUpdating(self)
        end
    end
end)