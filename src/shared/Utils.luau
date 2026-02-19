local Utils = {}

function Utils.FormatNumber(n)
	return tostring(n):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end

return Utils
