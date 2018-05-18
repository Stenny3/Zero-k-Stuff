function gadget:GetInfo()
  return {
    name      = "Ayy lmao",
    desc      = "Ayy lmao",
    author    = "_Shaman",
    date      = "c2015",
    license   = "When I show up I'm just a little sectoid ; but later on I become a mechtoid",
    layer     = 5,
    enabled   = true,
  }
end
 
if gadgetHandler:IsSyncedCode() then
 
local debug = true
 
local mapx
local mapy
local gaiaid = 0
local targetnum = 1
local maxweight = 0
local level = 0
local techpointsneeded = 200
--weightdefs--
local baddefs = {}
local kamikazedefs = {}
local weightdefs = {}
--targeting--
local targettable = {}
local myunits = {}
local kamikazetable = {}
local kamikazetableu = {}
local ascensionunits = {}
local otherunits = {}
local immuneunits = {}
--spawning--
local techpoints = 0
local nextoffensive = 0
local abductors =
{
	abductor =
	{
		unitdef = 'abductor',
		spawnrate = 3600, -- number of frames between spawnings
		--spawndecrease = 9000, -- halves the spawnrate every x frames
		minspawnrate = 120, -- fastest spawn rate possible
		unlocked = false, -- first spawn occurs here. (100 seconds)
		max = 35, -- max number of these
		hpbonus = 0.36, -- current hp bonus
		techpoints = 0 -- how many points this has earned the aliens
	},
	genocidedrone = 
	{
		unitdef = 'genocidedrone',
		spawnrate = 9000,
		--spawndecrease = 9000,
		minspawnrate = 1000,
		unlocked = false,
		max = 10,
		hpbonus = 0.25,
		techpoints = 0,
	},
	siegeship = 
	{
		unitdef = 'siegeship',
		spawnrate = 12000,
		--spawndecrease = 3000,
		minspawnrate = 1500,
		unlocked = false,
		max = 20,
		hpbonus = 0.5,
		techpoints = 0,
	},
	flyingcom =
	{
		unitdef = 'flyingcom',
		spawnrate = 6000,
		--spawndecrease = 18000,
		minspawnrate = 600,
		unlocked = false,
		max = 30,
		hpbonus = 0.36,
		techpoints = 0,
	},
	aliengunship =
	{
		unitdef = 'aliengunship',
		spawnrate = 12000,
		minspawnrate = 1000,
		unlocked = false,
		max = 20,
		hpbonus = 0.75,
		techpoints = 0,
	},
	
	storagedrone =
	{
		unitdef = 'storagedrone',
		spawnrate = 6000,
		--spawndecrease = 9000,
		unlocked = false,
		--starttime = 9000,
		max = 20,
		hpbonus = 0.33,
		techpoints = 0,
	},
	pylondrone =
	{
		unitdef = 'pylondrone',
		spawnrate = 6000,
		minspawnrate = 1000,
		unlocked = false,
		max = 20,
		hpbonus = 0.33,
		techpoints = 0,
	},
	alienkoda = 
	{
		unitdef = 'alienkoda',
		spawnrate = 30000,
		minspawnrate = 1000,
		unlocked = false,
		max = 10,
		hpbonus = 0.33,
		techpoints = 0,
	},
	malflyingcom =
	{
		unitdef = 'malflyingcom',
		spawnrate = 99999,
		minspawnrate = 3000,
		unlocked = false,
		max = 99,
		hpbonus = 0.25,
		techpoints = 0,
	}
}
 
--Functions--
local function AiThread()
	local unitqueue
	for unitID,_ in pairs(otherunits) do
		unitqueue = Spring.GetCommandQueue(unitID)
		if #unitqueue == 0 then -- idle unit
			local randx = math.random(0,mapx)
			local randy = math.random(0,mapy)
			Spring.GiveOrderToUnit(unitID,CMD.FIGHT,{ranx,Spring.GetGroundHeight(randx,randy),rany},0)
		end
	end
end
 
local function CanSpawn(abdtype)
  Spring.Echo("CanSpawn:" .. abdtype)
  Spring.Echo(UnitDefNames[abductors[abdtype].unitdef].id)
  if Spring.GetTeamUnitDefCount(gaiaid, UnitDefNames[abductors[abdtype].unitdef].id) > abductors[abdtype].max then
    if debug then Spring.Log("Ayylmao", LOG.NOTICE,"[Ayylmao] Can't spawn any more abductors! Max of " .. abductors[abdtype].max .. " reached!") end
    return false
  else
    return true
  end
end
 
local function GetUnitTransporting(id)
  local transporting = Spring.GetUnitIsTransporting(id)
  if transporting == nil or #transporting == 0 then
    transporting = false
  else
    transporting = true
  end
  if debug then
    Spring.Log("Ayylmao", LOG.NOTICE,"[Ayylmao] ID " .. id .. " is transporting: " .. tostring(transporting))
  end
  return transporting
end

local function UpgradeBestUnit()
	local bestname = ""
	local bestpoints = -99999
	for name,data in pairs(abductors) do
		if data["techpoints"] > bestpoints and data["unlocked"] then
			bestname = name
			bestpoints = data["techpoints"]
		end
	end
	if bestname ~= "" then
		if level >= 10 then
			if math.random(1,4) > 3 then
				abductors[bestname].hpbonus = abductors[bestname].hpbonus + math.min((level+1)/100, 0.5)
			else
				if abductors[bestname].spawnrate > abductors[bestname].minspawnrate then
					abductors[bestname].spawnrate = math.ceil(abductors[bestname].spawnrate/2)
					if abductors[bestname].spawnrate < abductors[bestname].minspawnrate then
						abductors[bestname].spawnrate = abductors[bestname].minspawnrate
					end
				else
					abductors[bestname].hpbonus = abductors[bestname].hpbonus + math.min((level+1)/100, 0.5)
				end
			end
		else
			abductors[bestname].hpbonus = abductors[bestname].hpbonus + math.min((level+1)/100, 0.5)
		end
	end
end

local function SpawnLimitlessAbductor(abdtype)
  local random = math.random(1,4)
  local unit
  local x,y
  if random == 1 then -- topleft
    x = -5000
    y = math.random(-2000,mapy+2000)
  end
  if random == 2 then -- topright
    x = mapx + 2000
    y = math.random(-2000,mapy+2000)
  end
  if random == 3 then -- bottom
    x = math.random(-2000,mapx+2000)
    y = mapy + 2000
  end
  if random == 4 then -- left
    x = -5000
    y = mapy + 2000
  end
  unit = Spring.CreateUnit(abdtype,x,200,y,0,gaiaid)
  Spring.MoveCtrl.Enable(unit)
  Spring.MoveCtrl.SetPosition(x,0,y)
  Spring.MoveCtrl.Disable(unit)
  Spring.SetUnitMaxHealth(unit, (UnitDefs[abdtype].health*healthbonus))
  Spring.SetUnitHealth(unit,(UnitDefs[abductors[abdtype].unitdef].health*healthbonus))
  if level > 20 and Spring.ValidUnitID(unit) then
    Spring.SetUnitStealth(unit, true)
  end
  if level > 30 and Spring.ValidUnitID(unit) then
    Spring.SetUnitCloak(unit,true,2)
  end
  if level > 40 and Spring.ValidUnitID(unit) then
    Spring.SetUnitCloak(unit,true,3)
  end
  if abdtype == "abductor" then
	myunits[unit] = {task = "none"}
  else otherunits[unit] = unit
  end
  unit,x,y = nil
end
 
local function SpawnAbductor(abdtype)
  local random = math.random(1,4)
  local unit
  local x,y
  if CanSpawn(abdtype) == false then
    return
  end
  if random == 1 then -- topleft
    x = -5000
    y = math.random(-2000,mapy+2000)
  end
  if random == 2 then -- topright
    x = mapx + 2000
    y = math.random(-2000,mapy+2000)
  end
  if random == 3 then -- bottom
    x = math.random(-2000,mapx+2000)
    y = mapy + 2000
  end
  if random == 4 then -- left
    x = -5000
    y = mapy + 2000
  end
  unit = Spring.CreateUnit(UnitDefNames[abductors[abdtype].unitdef].id,x,200,y,0,gaiaid)
  Spring.MoveCtrl.Enable(unit)
  Spring.MoveCtrl.SetPosition(x,0,y)
  Spring.MoveCtrl.Disable(unit)
  Spring.SetUnitMaxHealth(unit, (UnitDefs[abductors[abdtype].unitdef].health*healthbonus))
  Spring.SetUnitHealth(unit,(UnitDefs[abductors[abdtype].unitdef].health*healthbonus))
  if level > 20 and Spring.ValidUnitID(unit) then
    Spring.SetUnitStealth(unit, true)
  end
  if level > 30 and Spring.ValidUnitID(unit) then
    Spring.SetUnitCloak(unit,true,2)
  end
  if level > 40 and Spring.ValidUnitID(unit) then
    Spring.SetUnitCloak(unit,true,3)
  end
  if abdtype == "abductor" then
	myunits[unit] = {task = "none"}
  else otherunits[unit] = unit
  end
  unit,x,y = nil
end

local function MajorOffense()
	Spring.Echo("game_message: ALIENS planning MAJOR offensive. . .")
	local randomnum = math.random(1,100)
	if randomnum <= 2 then
		local ra = 0
		for i=1, 20 do
			ra = math.random(1,4)
			if ra > 2 then
				SpawnLimitlessAbductor("storagedrone")
			else
				SpawnLimitlessAbductor("pylondrone")
			end
		end
		Spring.Echo("Attack drones!")
	elseif randomnum > 2 and randomnum <= 20 then
		for i=1, 20 do
			SpawnLimitlessAbductor("malflyingcom")
			SpawnLimitlessAbductor("flyingcom")
		end
	elseif randomnum > 20 and randomnum <= 30 then
		for i=1, 10 do
			SpawnAbductor("abductor")
		end
	elseif  randomnum > 30 and randomnum <= 50 then
		UpgradeBestUnit()
	elseif randomnum > 50 and randomnum <= 70 then
		
	elseif randomnum == 89 or randomnum > 98 then
		for i=1, 10 do
			SpawnLimitlessAbductor("alienkoda")
		end
	elseif randomnum == 80 then
		if techpoints < 0 then		
			techpoints = math.ceil(math.abs(techpoints) / 2)
		else
			techpoints = techpoints + math.ceil(math.abs(techpoints) / 2)
		end
	else
		for i=1, 20 do
			SpawnLimitlessAbductor("abductor")
			SpawnLimitlessAbductor("storagedrone")
			SpawnLimitlessAbductor("pylondrone")
			SpawnLimitlessAbductor("alienkoda")
		end
	end
end

local function TechHandler()
	if Spring.GetGameFrame()%300 == 0 then
		Spring.Echo("Tech Handler: " .. "\nPoints: " .. techpoints .. "/" .. nextlevel .. "(Level " .. level .. ")")
	end
	if techpoints > nextlevel then
		Spring.Echo("New level: " .. level)
		if level == 0 then
			Spring.Echo("game_message: Reports of unidentified flying objects have come in all across France. Beware.. we may not be alone out there.")
			abductors["abductor"].unlocked = true
		elseif level == 1 then
			Spring.Echo("game_message: Reports of a new lethal unit have come in. Reports describe a flying brick that launches rockets. Only a mad man would create such a weapon.")
			abductors["siegeship"].unlocked = true
			abductors["abductor"].hpbonus = abductors["abductor"].hpbonus + .1
		elseif level == 6 then
			Spring.Echo("game_message: Reports of a new lethal unit have come in. Reports describe a modified attack drone. Details unknown.")
			abductors["genocidedrone"].unlocked = true
			abductors["abductor"].hpbonus = abductors["abductor"].hpbonus + 0.25
			abductors["siegeship"].hpbonus = abductors["siegeship"].hpbonus + 0.06
		elseif level == 7 then
			local randomnum = math.random(1,100)
			if randomnum <= 25 then
				abductors["genocidedrone"].hpbonus = abductors["genocidedrone"].hpbonus + 0.25
				abductors["abductor"].hpbonus = abductors["abductor"].hpbonus + 0.25
				abductors["siegeship"].hpbonus = abductors["siegeship"].hpbonus + 0.25
				Spring.Echo("game_message: Aliens have had a breakthrough in explosive reactive armor alloys based on our alloys! Intel suggests they'll have 25% increase in unit survivability.")
			elseif randomnum >= 51 then
				abductors["genocidedrone"].hpbonus = abductors["genocidedrone"].hpbonus + 0.1
				abductors["abductor"].hpbonus = abductors["abductor"].hpbonus + 0.1
				abductors["siegeship"].hpbonus = abductors["siegeship"].hpbonus + 0.1
				Spring.Echo("game_message: Aliens have had a breakthrough in composite armor. Expect a 10% increase in unit survivability.")
			else
				UpgradeBestUnit()
			end
		elseif level == 12 then
			Spring.Echo("game_message: Latest Intelligence bulletin: ALIENS are absorbing health from their kills! THIS IS BAD!")
			UpgradeBestUnit()
			UpgradeBestUnit()
		elseif level == 14 then
			abductors["flyingcom"].unlocked = true
			Spring.Echo("game_message: Latest intelligence bulletin: ALIENS have studied our commanders and created their own version. This can only be bad.")
			UpgradeBestUnit()
		elseif level == 16 then
			abductors["storagedrone"].unlocked = true
			abductors["pylondrone"].unlocked = true
			Spring.Echo("game_message: Latest intelligence bulletin: ALIENS have deployed suicide units based on some of our designs.")
		elseif level == 18 then
			abductors["aliengunship"].unlocked = true
			Spring.Echo("game_message: Newest intelligence has shown another flying unit.. this one looks... dangerous.")
		elseif level == 20 then
			abductors["malflyingcom"].unlocked = true
			Spring.Echo("game_message: We've just got reports of ALIEN units disappearing from radar. It seems they've employed some sort of stealth armor.")
			UpgradeBestUnit()
		elseif level == 22 then
			abductors["alienkoda"].unlocked = true
			Spring.Echo("game_message: We've received reports of kodachis being released from the aliens. Something is going on...")
			UpgradeBestUnit()
			UpgradeBestUnit()
		elseif level == 30 then
			Spring.Echo("game_message: Aliens have deployed active cloaking technology!")
			MajorOffense()
		elseif level == 40 then
			Spring.Echo("game_message: Aliens have improved their active cloaking technology.. This could be bad!")
		elseif level > 30 and level%5 == 3 then
			UpgradeBestUnit()
			MajorOffense()
		else
			UpgradeBestUnit()
		end
		techpoints = techpoints - techpointsneeded
		techpointsneeded = ((level+1) * 200)
		level = level + 1
	end
	if level < 1 and Spring.GetGameFrame()%30 == 0 then
		techpoints = techpoints + 1
	end
	if techpoints < -500 and Spring.GetGameFrame() > nextoffensive then
		nextoffensive = math.max(Spring.GetGameFrame() + (1800*(50/level)),1800)
		MajorOffense()
	end
end
 
local function GetRandomWeightedChanceID()
  local hops = math.random(1,math.ceil(maxweight/6))
  if hops < 5 then hops = 5 end
  if debug then Spring.Log("Ayylmao", LOG.NOTICE,"Hop Count: " .. hops) end
  if #targettable == 1 then
    return targettable[1].id
  else
    if #targettable == 0 then
      return false
    end
    repeat
      if #targettable == 1 then
        return targettable[1].id
      end
      if #targettable == 0 or targettable == nil then
        return false
      end
      targetnum = targetnum + 1
      if hops >= 1 and targetnum >= #targettable then
        targetnum = 1
      end
      if Spring.ValidUnitID(targettable[targetnum].id) then
        hops = hops - targettable[targetnum].weight
      else
        if debug then Spring.Log("Ayylmao", LOG.NOTICE,"[Ayylmao] ID " .. targettable[targetnum].id .. " is invalid. Removing.") end
        table.remove(targettable[targetnum])
      end
    until hops < 1
    hops = nil
    if debug then Spring.Log("Ayylmao", LOG.NOTICE,"[Ayylmao] Target ID Got: " .. targetnum .. " (ID: "  .. targettable[targetnum].id .. ").") end
    return targettable[targetnum].id
  end
end
 
 
local function AssignOrder(ID)
  local targetid = GetRandomWeightedChanceID()
  if targetid == false then
    return
  end
  if kamikazetableu[targetid] then
    myunits[ID].task = "Kamikaze"
    myunits[ID].target = {id = targetid, x=0, y=0}
    local x,y,z = Spring.GetUnitPosition(targetid)
    Spring.GiveOrderToUnit(ID,CMD.MOVE,{x,y,z},0)
    x,y,z,targetid = nil
  else
    myunits[ID].task = "Abduct"
    myunits[ID].target = targetid
    Spring.GiveOrderToUnit(ID,CMD.LOAD_UNITS,{targetid},0)
    targetid = nil
  end
end
 
local function SpawnThread()
	for abdtype,data in pairs(abductors) do
		Spring.Echo("Spawnthread:" .. tostring(abdtype))
		if Spring.GetGameFrame()%data["spawnrate"] == 0 and CanSpawn(abdtype) and data.unlocked == true then
			Spring.Echo("Spawning abductor. type: " .. abdtype)
			SpawnAbductor(abdtype)
		end
		--[[if Spring.GetGameFrame()%data["spawndecrease"] == 0 and Spring.GetGameFrame() > data["starttime"] then
			data["spawnrate"] = math.ceil(data["spawnrate"]/2)
			if data["spawnrate"] < data["minspawnrate"] then
				data["spawnrate"] = data["minspawnrate"]
			end
			Spring.Echo("Performing spawndecrease on " .. abdtype .. ":\n new data: " .. tostring(data["spawnrate"]))
		end]]
	end
end
 
function gadget:Initialize()
  mapx = Game.mapSizeX
  mapy = Game.mapSizeZ
  gaiaid = Spring.GetGaiaTeamID()
  --Build weight tables--
  for id,data in pairs(UnitDefs) do
    if data.isAirUnit or ((data.isBuilding or data.isFactory or data.isStaticBuilder or data.isImmobile) and (data.health > 4500 or math.floor((math.floor(data.health/100) + math.floor(data.energyCost/60))/1.75) == 0)) or math.floor(data.health/100) + math.floor(data.energyCost/60) == 0 then
      baddefs[id] = true
      if debug then Spring.Echo("[Ayylmao] " .. id .. "(" .. data.humanName .. ") result: bad def") end
    else
      if (data.isBuilding or data.isFactory or data.isStaticBuilder or data.isImmobile) and data.health < 4999 then
        kamikazedefs[id] = math.floor((math.floor(data.health/100) + math.floor(data.energyCost/60))/1.75)
        if debug then Spring.Echo("[Ayylmao] " .. id .. "(" .. data.humanName .. ") result: kamikaze (" .. kamikazedefs[id] .. ")") end
      else
        if data.cantBeTransported == true then
           baddefs[id] = true
           if debug then Spring.Echo("[Ayylmao] " .. id .. "(" .. data.humanName .. ") result: bad def (Can't Transport)") end
        else
           weightdefs[id] = math.floor(data.health/100) + math.floor(data.energyCost/60)
           if UnitDefs[id].customParams.commtype or UnitDefs[id].customParams.iscommander then
              weightdefs[id] = weightdefs[id] * (((data.customParams.level or 1) + 1) * 2)
           end
        if debug then Spring.Echo("[Ayylmao] " .. id .. "(" .. data.humanName .. ") result: " .. weightdefs[id]) end
       end
      end
    end
  end
end
 
function gadget:GameFrame(f)
  -- spawns --
  SpawnThread()
  AiThread()
  -- AI --
  if f%90 == 0 then -- update unit orders.
    -- update abductor orders
    for id,data in pairs(myunits) do
      if data.target == nil and data.task ~= "Kamikaze" then
        AssignOrder(id)
      elseif data.task == "Abduct" then -- unit was/is abducting something
        if Spring.ValidUnitID(data.target) == false then -- switch to kamikaze
          data.task = "Kamikaze"
		  immuneunits[id] = true
          data.target = {id = Spring.GetUnitNearestEnemy(id,20000,false),x=0,y=0}
          data.target.x, _, data.target.y = Spring.GetUnitPosition(data.target.id)
          if Spring.ValidUnitID(data.target) then Spring.GiveOrderToUnit(id,CMD.MOVE,{data.target.x,Spring.GetGroundHeight(data.target.x,data.target.y),data.target.y},0) else data.task = "none" end
        end
        if GetUnitTransporting(id) and (data.task ~= "Carry" and data.task ~= "drop") then -- abduction successful
          data.task = "Carry"
          if math.random(1,8) > 7 then
            data.task = "drop"
            data.target = {id = kamikazetable[math.random(1,#kamikazetable)].id,x=0,y=0}
            data.target.x,_,data.target.y = Spring.GetUnitPosition(data.target.id)
          else
            data.target = {x=(mapx/2 + 100) - math.random(1,mapx/2),y=(mapy/2 +100) - math.random(1,mapy/2)}
          end
          Spring.GiveOrderToUnit(id,CMD.MOVE,{data.target.x,Spring.GetGroundHeight(data.target.x,data.target.y),data.target.y},0)
          if debug then Spring.Log("Ayylmao", LOG.NOTICE,"[Ayylmao] AI: Ordering " .. id .. " to move to (" .. data.target.x .. "," .. data.target.y .. ").") end
        end
        if data.task == "Carry" or data.task == "drop" then
          Spring.GiveOrderToUnit(id,CMD.MOVE,{data.target.x,Spring.GetGroundHeight(data.target.x,data.target.y),data.target.y},0) -- make sure it is moving towards its goal
        end
        if data.task == "Kamikaze" then
          local x,y,z = Spring.GetUnitPosition(id)
          if (x-data.target.x)*(x-data.target.x)+ (z -data.target.y)* (z -data.target.y) < 150*150 then
            Spring.AddUnitImpulse(id,0,-60,0)
            Spring.GiveOrderToUnit(id,CMD.SELFD,{},0)
          end
        end
      end
      if GetUnitTransporting(id) and (data.task == "Carry" or data.task == "drop") then
        local x,y,z = Spring.GetUnitPosition(id)
         if (x-data.target.x)*(x-data.target.x)+ (z -data.target.y)* (z -data.target.y) < 100*100 then -- time to begin our ascent
          if debug then Spring.Log("Ayylmao", LOG.NOTICE,"[Ayylmao] AI: arrived at (" .. x .. "," .. y .. "). Begining ascent loop.") end
          local id2 = id
          --table.insert(ascensionunits,{myid = id2,x=x,y=y,z=z,xpo=1,ro=0,movectrl = false})
          ascensionunits[id] = {x=x,y=y,z=z,xpo=1,ro=0,movectrl = false}
          x,y,z,id2 = nil
        end
      end
    end
  end
  -- Ascension --
  if f%5 == 0 and ascensionunits then
    for id,data in pairs(ascensionunits) do
      if ascensionunits[id] then
        if Spring.ValidUnitID(id) and data.movectrl == false then
          --Spring.MoveCtrl.Enable(ascensionunits[i].myid)
          Spring.GiveOrderToUnit(id, CMD.MOVE_STATE, {0}, 0)
          if debug then Spring.Log("Ayylmao", LOG.NOTICE,"[Ayylmao] Ascent[" .. id .. "]: setting movestate to hold position.") end
          data.movectrl = true
        end
        if Spring.ValidUnitID(id) == false then -- prevents breaking the next bit of code
          if debug then Spring.Log("Ayylmao", LOG.NOTICE,"[Ayylmao] Ascent[" .. id .. "]: Invalid unitid, removing.") end
          ascensionunits[id] = nil
        else
          data.xpo = data.xpo + 1
          --ascensionunits[i].ro = ascensionunits[i].ro + 0.02 * ascensionunits[i].xpo
          _,data.y,_ = Spring.GetUnitPosition(id)
          if data.y < 5000 and Spring.ValidUnitID(id) then
            if debug then Spring.Log("Ayylmao", LOG.NOTICE,"[Ayylmao] Ascent[" .. id .. "]: Adding " .. data.xpo*2 .. "  impulse to unit.") end
            Spring.AddUnitImpulse(id,0,data.xpo,0)
          end
          --Spring.SetUnitPosition(ascensionunits[i].myid,ascensionunits[i].x,ascensionunits[i].y,ascensionunits[i].z)
          --Spring.MoveCtrl.SetRotationVelocity(ascensionunits[i].myid,ascensionunits[i].ro,0,0)
          if data.y > 3000 and Spring.ValidUnitID(id) then
            if debug then Spring.Log("Ayylmao", LOG.NOTICE,"[Ayylmao] Ascent[" .. id .. "]: reached y > 3000..") end
			local transported = Spring.GetUnitIsTransporting(id)
            if myunits[id].task ~= "Drop" and transported[1] ~= nil then
              if debug then Spring.Log("Ayylmao", LOG.NOTICE,"[Ayylmao] Ascent[" .. id .. "]: Issueing self destruct.") end
              Spring.GiveOrderToUnit(id,CMD.SELFD,{},0)
              ascensionunits[id] = nil
			  immuneunits[id] = true
			  Spring.Echo("Abduction Successful! Gained " .. math.ceil(UnitDefs[Spring.GetUnitDefID(transported[1])].metalCost/25))
			  abductors["abductor"].techpoints = abductors["abductor"].techpoints + math.ceil(UnitDefs[Spring.GetUnitDefID(transported[1])].metalCost/25)
			  techpoints = techpoints + math.ceil(UnitDefs[Spring.GetUnitDefID(transported[1])].metalCost/25)
            elseif transported[1] ~= nil then
              if debug then Spring.Log("Ayylmao", LOG.NOTICE,"[Ayylmao] Ascent[" .. id .. "]: Issueing drop order.") end
              Spring.GiveOrderToUnit(id,35000,{},0)
              Spring.AddUnitImpulse(id,0,data.xpo*-2,0)
			  techpoints = techpoints + math.ceil(UnitDefs[Spring.GetUnitDefID(transported[1])].metalCost/100)
			  abductors["abductor"].techpoints = abductors["abductor"].techpoints + math.ceil(UnitDefs[Spring.GetUnitDefID(transported[1])].metalCost/100) -- earned by "probing".
              myunits[id].task = "None"
              --Spring.MoveCtrl.Disable(ascensionunits[i].myid)
              myunits[id].target = nil -- throw unit back into the pool
              ascensionunits[id] = nil
			else
				ascensionunits[id] = nil
				myunits[id].task = "None"
            end
          end
        end
      end
    end
  end
end
 
function gadget:UnitFinished(unitID, unitDefID, unitTeam)
  if Spring.GetUnitTeam(unitID) ~= gaiaid then -- it's not my unit
    
    if baddefs[unitDefID] == nil then -- this is a valid unit
      if weightdefs[unitDefID] then
        table.insert(targettable,{id = unitID,weight = weightdefs[unitDefID]})
        maxweight = maxweight + weightdefs[unitDefID]
        if debug then Spring.Log("Ayylmao", LOG.NOTICE,"[Ayylmao] New total weight: " .. maxweight) end
      else
        table.insert(targettable,{id = unitID,weight = kamikazedefs[unitDefID]})
        table.insert(kamikazetable,{id = unitID, weight = kamikazedefs[unitDefID]})
        kamikazetableu[unitID] = #kamikazetable
        maxweight = maxweight + kamikazedefs[unitDefID]
        if debug then Spring.Log("Ayylmao", LOG.NOTICE,"[Ayylmao] New total weight: " .. maxweight) end
      end
    end
  end
end
 
function gadget:UnitDestroyed(unitID, unitDefID, teamID, attackerID, attackerDefID, attackerTeamID)
  if weightdefs[unitDefID] or kamikazedefs[unitDefID] then
    maxweight = maxweight - (weightdefs[unitDefID] or kamikazedefs[unitDefID] or 0)
    if kamikazetableu[unitID] then
      table.remove(kamikazetable,kamikazetableu[unitID])
    end
    kamikazetableu[unitID] = nil
    if debug then Spring.Log("Ayylmao", LOG.NOTICE,"[Ayylmao] New total weight: " .. maxweight) end
  end
  if myunits[unitID] then
    myunits[unitID] = nil
  end
  if teamID == gaiaid and immuneunits[unitID] == nil then
		techpoints = techpoints - math.max(math.floor(UnitDefs[unitDefID].metalCost/100),1)
		if abductors[UnitDefs[unitDefID].name] then
			abductors[UnitDefs[unitDefID].name].techpoints = abductors[UnitDefs[unitDefID].name].techpoints - math.max(UnitDefs[unitDefID].metalCost/100,1)
		end
   elseif attackerTeamID == gaiaid then
		if level > 12 then
			if unitDefID ~= UnitDefNames["abductor"] then
				local health,maxhealth,_ = Spring.GetUnitHealth(unitID)
				Spring.SetUnitMaxHealth(unitID, maxhealth + (UnitDefs[unitDefID].health / 10))
				Spring.SetUnitHealth(unitID, health + (UnitDefs[unitDefID].health / 10))
				health,maxhealth = nil
			end
		end
		techpoints = techpoints + math.ceil(UnitDefs[unitDefID].metalCost/100)
		if abductors[UnitDefs[attackerDefID].name] then
			abductors[UnitDefs[attackerDefID].name].techpoints = abductors[UnitDefs[attackerDefID].name].techpoints + math.ceil(UnitDefs[unitDefID].metalCost/100)
		end
	end
	immuneunits[unitID] = nil
end

function gadget:GameStart()
  Spring.SetGlobalLos(select(6,Spring.GetTeamInfo(gaiaid)),true)
end
end
