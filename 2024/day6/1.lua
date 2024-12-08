if #arg ~= 1 then
	error('Incorrect amount of arguments.')
end

file = io.open(arg[1], 'r')
if file == nil then
	error('Incorrect file path.')
end

io.input(file)

local input = {}
for line in io.lines() do
	table.insert(input, line)
end

-- Find the direction and location of the guard
function Line_check(line)
	local directions = { '%^', '>', 'v', '<' }
	for _, symbol in ipairs(directions) do
		local loc, _ = string.find(line, symbol)
		if loc ~= nil then
			return loc, symbol
		end
	end
	return nil, nil
end

function Find(map)
	for y, line in ipairs(map) do
		local x, symbol = Line_check(line)
		if x ~= nil then
			return x, y, symbol
		end
	end

	return nil, nil, nil
end

function PrintMap(map)
	for _, l in ipairs(map) do
		print(l)
	end
end

-- Change lines
function Step(map)
	local x, y, direction = Find(map)
	if x == nil or y == nil or direction == nil then
		return nil
	end

	-- Replacement
	map[y] = string.gsub(map[y], direction, 'X')

	-- New guy
	if direction == '%^' then
		if y == 1 then
			return map
		end

		if string.sub(map[y - 1], x, x) == '#' then
			if x == #map then
				return map
			end
			map[y] = ReplaceChar(map[y], x + 1, '>')
		else
			map[y - 1] = ReplaceChar(map[y - 1], x, '^')
		end
	elseif direction == '>' then
		if x == #map then
			return map
		end

		if string.sub(map[y], x + 1, x + 1) == '#' then
			if y == #map then
				return map
			end
			map[y + 1] = ReplaceChar(map[y + 1], x, 'v')
		else
			map[y] = ReplaceChar(map[y], x + 1, '>')
		end
	elseif direction == 'v' then
		if y == #map then
			return map
		end

		if string.sub(map[y + 1], x, x) == '#' then
			if x == 1 then
				return map
			end
			map[y] = ReplaceChar(map[y], x - 1, '<')
		else
			map[y + 1] = ReplaceChar(map[y + 1], x, 'v')
		end
	elseif direction == '<' then
		if x == 1 then
			return map
		end

		if string.sub(map[y], x - 1, x - 1) == '#' then
			if y == 1 then
				return map
			end
			map[y - 1] = ReplaceChar(map[y - 1], x, '^')
		else
			map[y] = ReplaceChar(map[y], x - 1, '<')
		end
	end

	return map
end

function ReplaceChar(str, idx, char)
	return string.sub(str, 1, idx - 1) .. char .. string.sub(str, idx + 1)
end

-- Counts how many X are there in the 2D map
function Count(map)
	local total = 0
	for _, line in ipairs(map) do
		local _, count = string.gsub(line, 'X', 'X')
		total = total + count
	end
	return total
end

while true do
	local next = Step(input)
	if next == nil then
		break
	end
	input = next
end

print(Count(input))
