---@class EncounterStage
---@field encounter Encounter
---@field start function
---@field tick function
---@field finish function
EncounterStage = {}

setmetatable(EncounterStage, {
	---@param self EncounterStage
	---@param config table
	__call = function(self, config)
		return setmetatable({
			encounter = config.encounter,
			start = config.start,
			tick = config.tick,
			finish = config.finish,
		}, { __index = EncounterStage })
	end,
})

---Automatically advances to the next stage after the given delay
---@param delay number|string The delay time to advance to the next stage
function EncounterStage:autoAdvance(delay)
	local originalStart = self.start
	function self.start()
		delay = delay or 50 -- 50ms is minimum delay; used here for close to instant advance
		originalStart()
		self.encounter:debug("Encounter[{}]:autoAdvance | next stage in: {}", self.encounter.name, delay == 50 and "instant" or delay)
		self.encounter:addEvent(function()
			self.encounter:nextStage()
		end, delay)
	end
end

---@class Encounter
---@field name string
---@field protected zone Zone
---@field protected spawnZone Zone
---@field protected stages EncounterStage[]
---@field protected currentStage number
---@field protected events table
---@field protected registered boolean
---@field protected global boolean
---@field protected timeToSpawnMonsters number|string
---@field onReset function
Encounter = {
	registry = {},
	unstarted = 0,
	enableDebug = true,
}

setmetatable(Encounter, {
	---@param self Encounter
	---@param name string
	---@param config table
	__call = function(self, name, config)
		if not name then
			error("Encounter: name is required")
		end
		local encounter
		if Encounter.registry[name] then
			encounter = Encounter.registry[name]
		else
			encounter = setmetatable({
				name = name,
			}, { __index = Encounter })
		end
		if config then
			encounter:resetConfig(config)
		end
		return encounter
	end,
})

---@alias EncounterConfig { zone: Zone, spawnZone: Zone, global: boolean, timeToSpawnMonsters: number }
---Resets the encounter configuration
---@param config EncounterConfig The new configuration
function Encounter:resetConfig(config)
	self.zone = config.zone
	self.spawnZone = config.spawnZone or config.zone
	self.stages = {}
	self.currentStage = Encounter.unstarted
	self.registered = false
	self.global = config.global or false
	self.timeToSpawnMonsters = ParseDuration(config.timeToSpawnMonsters or "3s")
	self.events = {}
end

---@param callable function The callable function for the event
---@param delay number The delay time for the event
function Encounter:addEvent(callable, delay, ...)
	local index = #self.events + 1
	local event = addEvent(function(callable, ...)
		pcall(callable, ...)
		table.remove(self.events, index)
	end, ParseDuration(delay), callable, ...)
	table.insert(self.events, index, event)
end

---Cancels all the events associated with the encounter
function Encounter:cancelEvents()
	for _, event in ipairs(self.events) do
		stopEvent(event)
	end
	self.events = {}
end

---Returns the stage of the encounter by the given stage number
---@param stageNumber number? The number of the stage. Optional.
---@return EncounterStage The stage of the encounter
function Encounter:getStage(stageNumber)
	return self.stages[stageNumber or self.currentStage]
end

---Enters a new stage in the encounter
---@param stageNumber number The number of the stage to enter
---@param abort boolean? A flag to determine whether to abort the current stage without calling the finish function. Optional.
---@return boolean True if the stage is entered successfully, false otherwise
function Encounter:enterStage(stageNumber, abort)
	self:debug("Encounter[{}]:enterStage | stageNumber: {} | abort: {}", self.name, stageNumber, abort)
	if not abort then
		local currentStage = self:getStage(self.currentStage)
		if currentStage and currentStage.finish then
			currentStage:finish()
		end
	end

	self:cancelEvents()

	if stageNumber == Encounter.unstarted then
		self.currentStage = Encounter.unstarted
		return true
	end

	local stage = self:getStage(stageNumber)
	if not stage then
		logger.error("Encounter:enterStage - stage {} not found", stageNumber)
		return false
	end

	self.currentStage = stageNumber
	if stage.start then
		stage:start()
	end

	return true
end

---@alias SpawnMonsterConfig { name: string, amount: number, event: string?, timeLimit: number?, position: Position|table?, positions: Position|table[]?, spawn: function? }

---Spawns monsters based on the given configuration
---@param config SpawnMonsterConfig The configuration for spawning monsters
function Encounter:spawnMonsters(config)
	local positions = config.positions
	local amount = config.amount
	if positions and config.position then
		error("You can't use both 'position' and 'positions' in the same config.")
	end
	if positions and amount then
		error("You can't use both 'amount' and 'positions' in the same config.")
	end
	if amount and amount > 0 then
		positions = {}
		for _ = 1, amount do
			if config.position then
				table.insert(positions, config.position)
			else
				table.insert(positions, self.spawnZone:randomPosition())
			end
		end
	end
	for _, position in ipairs(positions) do
		for i = 1, self.timeToSpawnMonsters / 1000 do
			self:addEvent(function(position)
				position:sendMagicEffect(CONST_ME_TELEPORT)
			end, i * 1000, position)
		end
		self:addEvent(function(name, position, event, spawn, timeLimit)
			local monster = Game.createMonster(name, position)
			if not monster then
				return false
			end
			if spawn then
				spawn(monster)
			end
			if event then
				if type(event) == "string" then
					event = { event }
				end
				for _, event in ipairs(event) do
					monster:registerEvent(event)
				end
			end
			if timeLimit then
				self:addEvent(function(monsterId)
					local monster = Monster(monsterId)
					if not monster then
						return
					end
					monster:remove()
				end, config.timeLimit, monster:getID())
			end
		end, self.timeToSpawnMonsters, config.name, position, config.event, config.spawn, config.timeLimit)
	end
end

---Broadcasts a message to all players
function Encounter:broadcast(type, message, webhook_title)
	if self.global then
		broadcastMessage(message, type)
		Webhook.sendMessage(webhook_title, message, type)
		return
	end
	self.zone:sendTextMessage(message, type)
end

---Counts the number of monsters with the given name in the encounter zone
---@param name string The name of the monster to count
---@return number The number of monsters with the given name
function Encounter:countMonsters(name)
	return self.zone:countMonsters(name)
end

---Counts the number of players in the encounter zone
---@return number The number of players in the encounter zone
function Encounter:countPlayers()
	return self.zone:countPlayers(IgnoredByMonsters)
end

---Removes all monsters from the encounter zone
function Encounter:removeMonsters()
	self.zone:removeMonsters()
end

---Resets the encounter to its initial state
---@return boolean True if the encounter is reset successfully, false otherwise
function Encounter:reset()
	if self.currentStage == Encounter.unstarted then
		return true
	end
	self:debug("Encounter[{}]:reset", self.name)
	if self.onReset then
		self:onReset()
	end
	return self:enterStage(Encounter.unstarted)
end

---Checks if a position is inside the encounter zone
---@param position Position The position to check
---@return boolean True if the position is inside the encounter zone, false otherwise
function Encounter:isInZone(position)
	return self.zone:isInZone(position)
end

---Enters the previous stage in the encounter
---@return boolean True if the previous stage is entered successfully, false otherwise
function Encounter:previousStage()
	return self:enterStage(self.currentStage - 1, true)
end

---Enters the next stage in the encounter
---@return boolean True if the next stage is entered successfully, false otherwise
function Encounter:nextStage()
	if self.currentStage == #self.stages then
		return self:reset()
	end
	return self:enterStage(self.currentStage + 1)
end

---Starts the encounter
---@return boolean True if the encounter is started successfully, false otherwise
function Encounter:start()
	if self.currentStage ~= Encounter.unstarted then
		return false
	end
	self:debug("Encounter[{}]:start", self.name)
	return self:enterStage(1)
end

---Adds a new stage to the encounter
---@param config table The stage to add
---@return boolean True if the stage is added successfully, false otherwise
function Encounter:addStage(config)
	local stage = EncounterStage(config)
	stage.encounter = self
	table.insert(self.stages, stage)
	return stage
end

---Adds an intermission stage to the encounter
---@param interval number|string The duration of the intermission
---@return boolean True if the intermission stage is added successfully, false otherwise
function Encounter:addIntermission(interval)
	return self:addStage({
		start = function()
			self:addEvent(function()
				self:nextStage()
			end, interval)
		end,
	})
end

---Adds a stage that just sends a message to all players
---@param message string The message to send
---@param webhook_title string The message to send
---@return boolean True if the message stage is added successfully, false otherwise
function Encounter:addBroadcast(message, type, webhook_title)
	type = type or MESSAGE_EVENT_ADVANCE
	return self:addStage({
		start = function()
			self:broadcast(type, message, webhook_title)
		end,
	})
end


---Adds a stage that spawns monsters
---@param configs SpawnMonsterConfig[] The configurations for spawning monsters
---@return boolean True if the spawn monsters stage is added successfully, false otherwise
function Encounter:addSpawnMonsters(configs)
	if not configs then
		return false
	end
	if not configs[1] then
		configs = { configs }
	end -- convert single config to array
	return self:addStage({
		start = function()
			for _, config in ipairs(configs) do
				self:spawnMonsters(config)
			end
		end,
	})
end

---Adds a stage that removes all monsters from the encounter zone
---@return boolean True if the remove monsters stage is added successfully, false otherwise
function Encounter:addRemoveMonsters()
	return self:addStage({
		start = function()
			self:removeMonsters()
		end,
	})
end

---Automatically starts the encounter when players enter the zone
function Encounter:startOnEnter()
	local zoneEvents = ZoneEvent(self.zone)

	function zoneEvents.afterEnter(zone, creature)
		if not self.registered then
			return true
		end
		local player = creature:getPlayer()
		if not player then
			return true
		end
		if player:hasGroupFlag(IgnoredByMonsters) then
			return
		end
		self:start()
	end

	function zoneEvents.afterLeave(zone, creature)
		local player = creature:getPlayer()
		if not player then
			return
		end
		if player:hasGroupFlag(IgnoredByMonsters) then
			return
		end
		-- last player left; reset encounter
		if self:countPlayers() == 1 then
			return
		end
		self:reset()
	end

	zoneEvents:register()
end

---Registers the encounter
--@param self Encounter The encounter to register
---@return boolean True if the encounter is registered successfully, false otherwise
function Encounter:register()
	Encounter.registry[self.name] = self
	self.registered = true
	return true
end

function Encounter:debug(...)
	if not Encounter.enableDebug then
		return
	end
	logger.debug(...)
end
