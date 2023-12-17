local mp = require("mp")

-- extract movie details from filename which looks like this : The.Longest.Ride.2015.720p.BluRay.x264.YIFY
-- get movie_name (The Longest Ride), year (2015), quality (720p) and type (BluRay).
-- @param filename: movie filename
-- @return: movie name, year, quality and type
-- @usage: local name, year, quality, type = utils.movie.get_details(filename)
local function get_movie_details()
	local filename = mp.get_property("filename/no-ext")
	-- extract movie name without special characters like dots, dashes, etc
	local name, year, quality, type = filename:match("(.+)%.(%d%d%d%d).(%d+p).(%w+)")

	name = name:gsub("%.", " ")
	return name, year, quality, type
end

return {
	get_movie_details = get_movie_details,
}
