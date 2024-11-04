local function set_contains(table, target)
	-- Iterate over each key in the table and its value
	for _, value in pairs(table) do
		-- Check if the current element matches the target string
		if value == target then
			return true -- Target found; exit early
		end
	end
	return false -- No match found after checking all elements
end

return {
	contains = set_contains,
}
