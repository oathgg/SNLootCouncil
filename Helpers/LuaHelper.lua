LuaHelper = {}

function LuaHelper:Print(tableObj)
    for key, value in pairs(tableObj) do
        print(key, value)
    end
end

function LuaHelper:Dump(tableObj)
    LuaHelper:Print(tableObj)
end

-- From HonorSpy
local colors = {
	["ORANGE"] = "ff7f00",
	["GREY"] = "aaaaaa",
	["RED"] = "C41F3B",
	["GREEN"] = "00FF96",
	["SHAMAN"] = "0070DE",
	["nil"] = "FFFFFF",
    ["NORMAL"] = "f2ca45",
    ["CYAN"] = "00FFFF"
}

-- From HonorSpy
function LuaHelper:ColorizeStr(str, colorOrClass)
	if (not colorOrClass) then -- some guys have nil class for an unknown reason
		colorOrClass = "nil"
	end
	
	if (not colors[colorOrClass] and RAID_CLASS_COLORS and RAID_CLASS_COLORS[colorOrClass]) then
		colors[colorOrClass] = format("%02x%02x%02x", RAID_CLASS_COLORS[colorOrClass].r * 255, RAID_CLASS_COLORS[colorOrClass].g * 255, RAID_CLASS_COLORS[colorOrClass].b * 255)
	end
	if (not colors[colorOrClass]) then
		colorOrClass = "nil"
	end

	return format("|cff%s%s|r", colors[colorOrClass], str)
end

function LuaHelper:RandomString(length)
	local res = ""
	for i = 1, length do
		res = res .. string.char(math.random(97, 122))
	end
	return res
end

function LuaHelper:RandomNumber(length)
	local res = 0
	local power = 1
	-- if the first number is 0 then it will most likely be ignored by IDs, 
	--   hence we set the first number to at least 1.
	local minNumber = 1
	for i = 1, length do
		if i > 1 then 
			minNumber = 0 
		end

		res = res + (math.random(minNumber, 9) * power)
		power = power * 10
	end
	return res
end

function LuaHelper:RandomNumberBetween(minNum, maxNum)
	return math.random(minNum, maxNum)
end