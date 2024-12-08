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
	local input_line = {}
	for i in string.gmatch(line, '.') do
		table.insert(input_line, i)
	end
	table.insert(input, input_line)
end

function print_map(map)
	for _, l in ipairs(map) do
		local tmp = ''
		for _, w in ipairs(l) do
			if type(w) == 'table' then
				if w['O'] ~= nil then
					tmp = tmp .. 'O'
				elseif ((w['^'] ~= nil) or (w['v'] ~= nil)) and ((w['<'] ~= nil) or (w['>'] ~= nil)) then
					tmp = tmp .. '+'
				elseif (w['^'] ~= nil) or (w['v'] ~= nil) then
					tmp = tmp .. '|'
				elseif (w['<'] ~= nil) or (w['>'] ~= nil) then
					tmp = tmp .. '-'
				else
					tmp = tmp .. 'X'
				end
			else
				tmp = tmp .. w
			end
		end
		print(tmp)
	end
end

-- Find the direction and location of the guard
function check_line(line)
	local directions = { '^', '>', 'v', '<' }
	local move = { ['^'] = { 0, -1 }, ['>'] = { 1, 0 }, ['v'] = { 0, 1 }, ['<'] = { -1, 0 } }
	local ninetys = { ['^'] = '>', ['>'] = 'v', ['v'] = '<', ['<'] = '^' }
	for i, v in ipairs(line) do
		for _, s in ipairs(directions) do
			if v == s then
				local guard = {
					symbol = s,
					symbol90 = ninetys[s],
					x = move[s][1],
					y = move[s][2],
					x90 = move[ninetys[s]][1],
					y90 = move[ninetys[s]][2],
				}
				function guard.rotate()
					guard.symbol = guard.symbol90
					guard.symbol90 = ninetys[guard.symbol90]
					guard.x = guard.x90
					guard.y = guard.y90
					guard.x90 = move[ninetys[guard.symbol]][1]
					guard.y90 = move[ninetys[guard.symbol]][2]
				end
				return i, guard
			end
		end
	end
	return nil, nil
end

-- Give info of guard
-- Returns nil if there is no guard
function check_guard(map)
	for y, line in ipairs(map) do
		local x, symbol = check_line(line)
		if x ~= nil then
			return x, y, symbol
		end
	end

	return nil, nil, nil
end

local function simulate(map, x, y, sym)
	while true do
		if type(map[y][x]) == 'string' then
			map[y][x] = { [sym.symbol] = true }
		elseif type(map[y][x]) == 'table' then
			if map[y][x][sym.symbol] ~= nil then
				-- print('loop!')
				-- print_map(map)
				return false
			end
			map[y][x][sym.symbol] = true
		end

		local limity = 0 < (y + sym.y) and (y + sym.y) < #map + 1
		local limitx = 0 < (x + sym.x) and (x + sym.x) < #map[1] + 1
		if not (limity and limitx) then
			return true
		end

		local future = map[y + sym.y][x + sym.x]
		if future == '#' or future == 'O' then
			local limity90 = 0 < (y + sym.y90) and (y + sym.y90) < #map + 1
			local limitx90 = 0 < (x + sym.x90) and (x + sym.x90) < #map[1] + 1
			if not (limity90 and limitx90) then
				return true
			end
			sym.rotate()

			local future90 = map[y + sym.y][x + sym.x]
			if future90 == '#' or future90 == 'O' then
				local limity180 = 0 < (y + sym.y90) and (y + sym.y90) < #map + 1
				local limitx180 = 0 < (x + sym.x90) and (x + sym.x90) < #map[1] + 1
				if not (limity180 and limitx180) then
					return true
				end
				sym.rotate()
			end
		end
		y = y + sym.y
		x = x + sym.x
	end
end

function test(map, i, j)
	-- if map[i][j] ~= '.' then
	-- 	return false
	-- end

	local blocked = {}
	for l = 1, #map do
		blocked[l] = {}
		for m = 1, #map[i] do
			blocked[l][m] = map[l][m]
		end
	end

	local x, y, sym = check_guard(map)
	if x == nil or y == nil or sym == nil then
		return false
	end

	blocked[i][j] = 'O'
	-- print('---------------------------------------------------------------------------------------------------')
	-- print_map(blocked)
	-- print('---------------------------------------------------------------------------------------------------')

	if simulate(blocked, x, y, sym) == false then
		return true
	end

	return false
end

local total = 0
for i = 1, #input do
	for j = 1, #input[i] do
		if test(input, i, j) == true then
			total = total + 1
		end
	end
end

print(total)
-- 1631

-- local shit, map = simulate(input, x, y, sym)
-- if map == nil then
-- 	return
-- end
--
-- local total2 = 0
-- for _, l in ipairs(map) do
-- 	for _, s in ipairs(l) do
-- 		if type(s) == 'table' then
-- 			total2 = total2 + 1
-- 		end
-- 	end
-- end
--
-- print_map(map)
--
-- print(total2)
