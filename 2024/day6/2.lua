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
	local norm = { ['^'] = { 0, 1 }, ['>'] = { 1, 0 }, ['v'] = { 0, -1 }, ['<'] = { -1, 0 } }
	local ninetys = { ['^'] = norm['>'], ['>'] = norm['v'], ['v'] = '<', ['<'] = '^' }
	for i, v in ipairs(line) do
		for _, s in ipairs(directions) do
			if v == s then
				return i,
					{
						symbol = s,
						x = norm[s][1],
						y = norm[s][2],
						x90 = ninetys[s][1],
						y90 = ninetys[s][2],
					}
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

print(check_guard(input))
print_map(input)

local total = 0
local x, y, sym = check_guard(input)
if x == nil or y == nil or sym == nil then
	print(total)
	return nil, nil
end

local alts = { ['^'] = 'u', ['>'] = 'r', ['v'] = 'd', ['<'] = 'l' }
while true do
	print(input[y][x])

	print(sym.x)
	print(input[y + sym.y][x + sym.x])

	local limity = 0 < (y + sym.y) and (y + sym.y) < #input
	local limitx = 0 < (x + sym.x) and (x + sym.x) < #input[1]
	if not (limity and limitx) then
		break
	end

	-- printnorm[direction][0]

	-- if direction == '%^' then
	-- 	if y == 1 then
	-- 		break
	-- 	end
	--
	-- 	local future = string.sub(input[y - 1], x, x)
	-- 	if future == '#' then
	-- 		if x == #input then
	-- 			break
	-- 		end
	-- 		input[y] = ReplaceChar(input[y], x + 1, '>')
	-- 	else
	-- 		if future == 'r' then
	-- 			total = total + 1
	-- 		end
	-- 		input[y - 1] = ReplaceChar(input[y - 1], x, '^')
	-- 	end
	-- elseif direction == '>' then
	-- 	if x == #input then
	-- 		break
	-- 	end
	--
	-- 	local future = string.sub(input[y], x + 1, x + 1)
	-- 	if future == '#' then
	-- 		if y == #input then
	-- 			break
	-- 		end
	-- 		input[y + 1] = ReplaceChar(input[y + 1], x, 'v')
	-- 	else
	-- 		if future == 'd' then
	-- 			total = total + 1
	-- 		end
	-- 		input[y] = ReplaceChar(input[y], x + 1, '>')
	-- 	end
	-- elseif direction == 'v' then
	-- 	if y == #input then
	-- 		break
	-- 	end
	--
	-- 	local future = string.sub(input[y + 1], x, x)
	-- 	if future == '#' then
	-- 		if x == 1 then
	-- 			break
	-- 		end
	-- 		input[y] = ReplaceChar(input[y], x - 1, '<')
	-- 	else
	-- 		if future == 'l' then
	-- 			total = total + 1
	-- 		end
	-- 		input[y + 1] = ReplaceChar(input[y + 1], x, 'v')
	-- 	end
	-- elseif direction == '<' then
	-- 	if x == 1 then
	-- 		break
	-- 	end
	--
	-- 	local future = string.sub(input[y], x - 1, x - 1)
	-- 	if future == '#' then
	-- 		if y == 1 then
	-- 			break
	-- 		end
	-- 		input[y - 1] = ReplaceChar(input[y - 1], x, '^')
	-- 	else
	-- 		if future == 'u' then
	-- 			total = total + 1
	-- 		end
	-- 		input[y] = ReplaceChar(input[y], x - 1, '<')
	-- 	end
	-- end
end

print(total)
