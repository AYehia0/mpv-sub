-- read the environment variables in the project root dir called .env
local function read_env()
	local env = {}
	local env_file = io.open(".env", "r")
	if env_file then
		for line in env_file:lines() do
			local key, value = line:match("^([^=]+)=(.+)$")
			if key and value then
				env[key] = value
			end
		end
		env_file:close()
	end
	return env
end

local function get_api_key()
	local env = read_env()
	return env["API_KEY"]
end

return {
	get_api_key = get_api_key,
}
