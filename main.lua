local mp = require("mp") -- isn't actually required, mp still gonna be defined

-- require utils.movie module
local utils = require("utils.movie")

local opts = {
	strip_cmd_at = 120,
	sort_commands_by = "priority",
	toggle_menu_binding = "b",
	pause_on_open = true,
	resume_on_exit = "only-if-was-paused",
};

(require("mp.options")).read_options(opts, mp.get_script_name())

-- movie info table
local MOVIE_INFO = {
	name = "",
	year = "",
	quality = "", -- 720p, 1080p, 2160p
	type = "", -- BluRay, WEB-DL, WEBRip, HDRip, DVDRip, DVDScr, R5, TS, CAMbl
}

local mx = {
	list = {}, -- list of all subs (tables)
	lines = {}, -- command tables brought to pango markup strings concat with '\n'
	was_paused = false, -- flag that indicates that vid was paused by this script
}

function mx:init()
	-- keybind to launch menu
	mp.add_key_binding(opts.toggle_menu_binding, "Subs", function()
		self:handler()
	end)

	setmetatable({}, self)
	self.__index = self

	self:get_subs_list()
	self:form_lines()
end

function mx:get_subs_list()
	-- TODO: get subs from opensubtitles.org, subscene.com, yifysubtitles.com, subdl.com, subh
	-- Download the subs from the internet
	-- The subs data
	local subs = {
		MOVIE_INFO.name,
	}
	self.list = subs
end

function mx:form_lines()
	for _, v in ipairs(self.list) do
		table.insert(self.lines, self:get_line(v))
	end
end

function mx:get_line(v)
	return v
end

function mx:handler()
	-- set flag 'was_paused' only if vid wasn't paused before EM init
	if opts.pause_on_open and not mp.get_property_bool("pause", false) then
		mp.set_property_bool("pause", true)
		self.was_paused = true
	end

	self:register_script_message()

	local sub, status = self:get_rofi_choice()
	if status then
		Log(sub .. status)
	end

	self:unregister_script_message()

	if opts.resume_on_exit == true or (opts.resume_on_exit == "only-if-was-paused" and self.was_paused) then
		mp.set_property_bool("pause", false)
	end

	collectgarbage()
end

function mx:get_rofi_choice()
	local rofi = mp.command_native({
		name = "subprocess",
		args = {
			"rofi",
			"-dmenu",
			"-i",
			"-markup-rows",
			"-theme",
			-- use the arg var $RICETHEME in the path to the theme file
			"~/.config/bspwm/rices/pamela/launcher.rasi",
		},
		capture_stdout = true,
		playback_only = false,
		stdin_data = table.concat(self.lines, "\n"),
	})
	return rofi.stdout, rofi.status
end

function mx:register_script_message()
	mp.register_script_message("get_sub", function()
		self:get_subs_list()
	end)
end

function mx:unregister_script_message()
	mp.unregister_script_message("get_sub")
end

-- Log function: log to both terminal and MPV OSD (On-Screen Display)
function Log(string, secs)
	secs = secs or 2.5 -- secs defaults to 2.5 when secs parameter is absent
	mp.msg.warn(string) -- This logs to the terminal
	mp.osd_message(string, secs) -- This logs to MPV screen
end

mp.register_event("file-loaded", function()
	local movie_name, year, quality, type = utils.get_movie_details()
	MOVIE_INFO.name = movie_name
	MOVIE_INFO.year = year
	MOVIE_INFO.quality = quality
	MOVIE_INFO.type = type

	Log("Movie name: " .. movie_name .. "\nYear: " .. year .. "\nQuality: " .. quality .. "\nType: " .. type)
	mx:init()
end)
