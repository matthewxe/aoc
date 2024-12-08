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
			tmp = tmp .. w
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

local total = 0
local x, y, sym = check_guard(input)
if x == nil or y == nil or sym == nil then
	print(total)
	return nil, nil
end

local alts = { ['^'] = 'u', ['>'] = 'r', ['v'] = 'd', ['<'] = 'l' }
while true do
	input[y][x] = 'X'

	local limity = 0 < (y + sym.y) and (y + sym.y) < #input + 1
	local limitx = 0 < (x + sym.x) and (x + sym.x) < #input[1] + 1
	if not (limity and limitx) then
		break
	end

	local future = input[y + sym.y][x + sym.x]
	if future == '#' then
		local limity90 = 0 < (y + sym.y90) and (y + sym.y90) < #input + 1
		local limitx90 = 0 < (x + sym.x90) and (x + sym.x90) < #input[1] + 1
		if not (limity90 and limitx90) then
			break
		end
		input[y + sym.y90][x + sym.x90] = sym.symbol90
		sym.rotate()
	else
		input[y + sym.y][x + sym.x] = sym.symbol
	end
	y = y + sym.y
	x = x + sym.x
end

print_map(input)
print(total)
