file = io.open(arg[1], 'r')

-- sets the default input file as test.lua
io.input(file)

x = 0
y = 0

-- prints the first line of the file
local lines = {}
-- read the lines in table 'lines'
for line in io.lines() do
	table.insert(lines, line)
end
-- sort
-- write all the lines
for i, l in ipairs(lines) do
	io.write(l, '\n')
end
print(lines[1])
