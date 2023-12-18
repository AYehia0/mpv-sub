-- endpoints for the opensubtitles api
package.path = "/usr/local/share/lua/5.4/?.lua"

local http = require("http.request")
local env = require("tils.env")

local endpoints = {
	search = "https://api.opensubtitles.com/api/v1/subtitles",
}

local params = {
	user_agent = "mpv-sub" .. " v0.1",
}

-- call the search api endpoint and return the response
local function search_subtitles()
	-- query params for the search api
	local query_params = {
		query = "The longest ride",
		type = "movie",
		years = "2015",
		languages = "en,ar",
	}

	-- use the query params to build the url
	local url = endpoints.search .. "?" .. http.encode_query(query_params)
	local response = http.request({
		url = url,
		method = "GET",
		headers = {
			["User-Agent"] = params.user_agent,
			["Content-Type"] = "application/json",
			["Api-Key"] = env.get_api_key(),
		},
	})
	-- parse the response json
	local response_json = json.decode(response)
	Log(response_json)
	return response
end

return {
	search_subtitles = search_subtitles,
}
