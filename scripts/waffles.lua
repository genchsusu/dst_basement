for i, v in ipairs({ "_G", "setmetatable", "rawget" }) do
	env[v] = GLOBAL[v]
end

setmetatable(env,
{
	__index = function(table, key) return rawget(_G, key) end
})

PrefabFiles = {}
Assets = {}

--------------------------------------------------------------------------
--[[ Waffles ]]
--------------------------------------------------------------------------

Waffles = {}

MEMORY = setmetatable({}, { __mode = "v" })

local function getmemkey(...)
	local key = ""
	for i,v in ipairs(arg) do
		key = key .. "[" .. tostring(v) .. "]"
	end
	return key
end

local function findupvalue(fn, name)
	local i = 1
	while true do
		local upvaluename, upvalue = debug.getupvalue(fn, i)
		if upvalue == nil or upvaluename == name then
			return upvalue, i
		end
		i = i + 1
	end
end

local function getupvalue(fn, ...)
	local prevfn, i
	for _, name in ipairs(arg) do
		prevfn = fn
		fn, i = findupvalue(fn, name)
	end
	return fn, i, prevfn
end

require "entityscript"

local function cutpath(path_string)
	local path = {}
	for sub in path_string:gmatch("([^/]+)") do
		local num = tonumber(sub)	
		table.insert(path, num or sub)
	end
	return path
end

local function disablehauntedstate(inst)
	inst.AnimState:SetHaunted(false)
end

Waffles =
{	
	Load = function(...) return MEMORY[getmemkey(...)] end,
	Save = function(value, ...) MEMORY[getmemkey(...)] = value end,
    FindUpvalue = findupvalue,
	GetUpvalue = getupvalue,
	Dummy = function() end,		
	Valid = function(inst) return type(inst) == "table" and inst:IsValid() end,
	
	Browse = function(table, ...)
		for i, v in ipairs(arg) do
			if type(table) ~= "table" then
				return
			end
			table = table[v]
		end
		return table
	end,
					
	BrowseIn = function(table, ...)		
		if type(table) == "table" then
			for i, v in ipairs(arg) do
				if type(table[v]) ~= "table" then
					table[v] = {}
				end
				table = table[v]
			end
			return table
		end
	end,
	
	Merge = function(receiver, sender, submerger)
		for k, v in pairs(sender) do
			local istable = type(v) == "table"
			if istable and type(receiver[k]) == "table" then
				Waffles.Merge(receiver[k], v, submerger)
			else
				if istable
					and submerger ~= nil
					and v[submerger] == nil
					and receiver[k] ~= nil then
					
					v[submerger] = receiver[k]
				end
				receiver[k] = v
			end
		end
	end,
		
	GetRandom = function(data)
		return data[math.random(#data)]
	end,
	
	Announce = function(...)
		local announce = ""
		local strings = {}
		for i, v in ipairs(arg) do
			table.insert(strings, tostring(v))
		end
		announce = table.concat(strings, " ")
		if #announce > 0 then
			TheNet:Announce(announce)
			print('[Waffles] ' .. announce)
		end
	end,
	
	Parallel = function(root, key, exp, lowpriority)
		if type(root) ~= "table" then
			return
		end
		local old = root[key]
		local fn = old and Waffles.Load("Parallel", old, exp, lowpriority)		
		if old == nil or fn ~= nil then
			root[key] = fn or exp
		else
			if lowpriority then
				root[key] = function(...)
					old(...)
					return exp(...)
				end
			else
				root[key] = function(...)
					exp(...)
					return old(...)
				end
			end
			Waffles.Save(root[key], "Parallel", old, exp, lowpriority)
		end		
		return root[key]
	end,
	
	Sequence = function(root, key, exp, includeall)
		if type(root) ~= "table" then
			return
		end
		local old = root[key] or Waffles.Dummy
		local fn = Waffles.Load("Sequence", old, exp, includeall)		
		if fn ~= nil then
			root[key] = fn
		else
			if includeall then
				root[key] = function(...)
					local data = { old(...) }
					for i, v in ipairs({ exp(data, ...) }) do
						data[i] = v
					end
					return unpack(data)
				end
			else
				root[key] = function(...)
					local data = { old(...) }
					for i, v in ipairs({ exp(data[1], ...) }) do
						data[i] = v
					end
					return unpack(data) 
				end			
			end
			Waffles.Save(root[key], "Sequence", old, exp, includeall)
		end		
		return root[key]
	end,
	
	Branch = function(root, key, exp)
		if type(root) ~= "table" then
			return
		end		
		local old = root[key]
		if old == nil then
			return
		end		
		local fn = Waffles.Load("Branch", old, exp)		
		if fn ~= nil then
			root[key] = fn
		else
			root[key] = function(...)
				return exp(old, ...)
			end
			Waffles.Save(root[key], "Branch", old, exp)
		end		
		return root[key]
	end,
	
	Replace = function(root, key, replace)
		if type(root) ~= "table" then
			return
		end
		
		if replace ~= nil then
			if rawget(root, "__" .. key) == nil then
				rawset(root, "__" .. key, root[key])
			end
			root[key] = replace
		elseif rawget(root, "__" .. key) ~= nil then
			root[key] = root["__" .. key]
			root["__" .. key] = nil
		end
	end,
	
	CreatePositions = function(grid, centered, getall, step)
		local positions = Waffles.Load("Positions", grid, not not centered, not not getall, step)
		
		if not positions then
			local _x, _z = grid:match("(%d+)x(%d+)")
			_x, _z = _x - 1, _z - 1
			local data = { _x, _z }			
							
			table.insert(data, 0)
			data = table.invert(data)
				
			positions = {}
			if step == nil then
				step = 1
			end
				
			local offset = { x = 0, z = 0 }
			if centered then
				offset.x = (_x + 1) / 2
				offset.z = (_z + 1) / 2
			end
				
			for x = 0, _x, step do
				for z = 0, _z, step do
					if getall or data[x] or data[z] then
						table.insert(positions, { x = x - offset.x, z = z - offset.z })
					end
				end
			end
				
			Waffles.Save(positions, "Positions", grid, not not centered, not not getall, step)
		end	
			
		return positions
	end,
		
	Reset = function(inst)
		if inst.userid and #inst.userid > 0 then
			SerializeUserSession(inst)
			inst:Remove()
		else			
			local data = inst:GetSaveRecord()
			
			local x, y, z = data.x, data.y or 0, data.z
			--override position to prevent possible SoundEmitter events playing twice
			data.x, data.y, data.z = 0, 0, 0
			local isexists = table.invert(Waffles.FindNewEntities(x, y, z, 10))
						
			inst:Remove()
			
			--remove other prefabs that might be spawned by removal events
			for i,v in ipairs(Waffles.FindNewEntities(x, y, z, 10)) do
				if not isexists[v] then
					v:Remove()
				end
			end
			
			inst = SpawnSaveRecord(data)
			inst.Transform:SetPosition(x, y, z)
			return inst
		end
	end,
	
	PushFakeShadow = function(inst, ...)		
		if type(inst.DynamicShadow) ~= "userdata" then
			return
		end
		SpawnPrefab("fakedynamicshadow"):StartFX(inst, ...)
	end,
	
	DoHauntFlick = function(inst, time)
		inst.AnimState:SetHaunted(true)
		inst:DoTaskInTime(time or 1, disablehauntedstate)
	end,
		
	GetWorldStateWatchers = function(inst)
		if ALL_WORLDSTATE_WATCHERS == nil then
			ALL_WORLDSTATE_WATCHERS = Waffles.GetUpvalue(TheWorld.components.worldstate.AddWatcher, "_watchers")
		end
		
		local allinstwatchers = {}
		if ALL_WORLDSTATE_WATCHERS ~= nil then
			local istarget = { [inst] = true }
			for k,v in pairs(inst.components) do
				istarget[v] = true
			end	
			
			for var, varwatchers in pairs(ALL_WORLDSTATE_WATCHERS) do
				for target, watchers in pairs(varwatchers) do
					if istarget[target] then
						Waffles.BrowseIn(allinstwatchers, var)[target] = watchers
					end
				end
			end
		end
	
		return allinstwatchers
	end,
	
	GetDistanceDelay = function(inst, target, min, max, low, high)
		return Remap(math.sqrt(inst:GetDistanceSqToInst(target)), min, max, low or 0, high or 1)
	end,
		
	FindAnyPlayerInRange = function(inst, range)
		for i, v in ipairs(AllPlayers) do
			if v:IsNear(inst, range) then
				return v
			end
		end
	end,
	
	NegateWorkableFX = function(inst, ignore)
		local x, y, z = inst.Transform:GetWorldPosition()
		for _,v in ipairs(Waffles.FindNewEntities(x, y, z, 0, { "FX" }, { "INLIMBO" })) do
			if v ~= ignore then
				v:Remove()
				return
			end
		end
	end,	
				
	FindNewEntities = function(...)
		local ents = {}
		local time = GetTime()
		for _,v in ipairs(TheSim:FindEntities(...)) do
			if v.spawntime == time then
				v.spawntime = v.spawntime - FRAMES
				table.insert(ents, v)
			end
		end
		return ents
	end,
	
	StackEntities = function(ents, mult)
		local prefabs = {}
		local stackingents = {}
		
		local insert = table.insert
		local remove = table.remove
		
		for i,v in ipairs(ents) do
			if v:HasTag("_stackable") then
				local data = prefabs[v.prefab]
				if data == nil then
					data = { stacksize = 0, pos = v:GetPosition() }
					prefabs[v.prefab] = data
				end
				
				data.stacksize = data.stacksize + 1
				
				if stackingents[v.prefab] == nil then
					stackingents[v.prefab] = {}
				end
				insert(stackingents[v.prefab], v)
			end
		end
				
		local stackedents = {} 
		for prefab, data in pairs(prefabs) do			
			local samestackedents = {}
			local stackingprefabs = stackingents[prefab]
			local newent = remove(stackingprefabs)
			insert(stackedents, newent)
			insert(samestackedents, newent)
			while #stackingprefabs > 1 and data.stacksize > 0 do
				local stackable = newent.components.stackable
				local roomleft = stackable ~= nil and stackable:RoomLeft() or 0 
				local delta = math.min(1 + roomleft, data.stacksize)
				
				data.stacksize = data.stacksize - delta
				
				if stackable ~= nil then
					while #stackingprefabs > 0 and roomleft > 0 do
						stackable:Put(remove(stackingprefabs), data.pos)
						roomleft = stackable ~= nil and stackable:RoomLeft() or 0
					end
				end
				
				if #stackingprefabs >= 1 and data.stacksize > 0 and roomleft <= 0 then
					newent = remove(stackingprefabs)
					insert(stackedents, newent)
					insert(samestackedents, newent)
				end
			end
			
			for i,v in ipairs(samestackedents) do
				v.Transform:SetPosition((data.pos + Point(math.random() * 2 - 1, 0, math.random() * 2 - 1)):Get())
			end
		end
		
		for _,t in ipairs(stackingents) do
			for i,v in ipairs(t) do
				if v:IsValid() then
					v:Remove()
				end
			end
		end
						
		return stackedents
	end,
	
	DespawnRecipe = function(inst, mult, dontstack)
		if not Waffles.Browse(inst, "prefab") then
			return
		end
		
		local staff = SpawnPrefab("greenstaff")
		staff.persists = false
		
		local ingredients = nil
		
		local despawnfn = Waffles.Browse(staff, "components", "spellcaster", "spell")
		if despawnfn ~= nil then		
			local x, y, z = inst.Transform:GetWorldPosition()
			local time = GetTime()
			
			if AllRecipes[inst.prefab] == nil
			and AllRecipes[inst.prefab .. "_builder"] ~= nil then
				inst.prefab = inst.prefab .. "_builder"
			end
			despawnfn(staff, inst)

			ingredients = Waffles.FindNewEntities(x, y, z, 5, { "_stackable" })
			if not dontstack and #ingredients > 0 then
				ingredients = Waffles.StackEntities(ingredients, mult)
				if mult ~= nil and mult > 0 and mult < 1 then
					for i,v in ipairs(ingredients) do
						local stackable = v.components.stackable
						if stackable ~= nil then
							stackable:SetStackSize(math.ceil(stackable:StackSize() * mult))
						end
					end
				end
			end
		end
		
		if Waffles.Valid(staff) then
			staff:Remove()
		end
		
		return ingredients
	end,
}

if rawget(_G, "Waffles") ~= nil then
	for name, data in pairs(Waffles) do
		_G["Waffles"][name] = data
	end
else
	rawset(_G, "Waffles", Waffles)
end

Waffles = _G["Waffles"]