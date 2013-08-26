
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local vicious = require("vicious")
--local blingbling = require("blingbling")


statsbox = wibox.layout.fixed.horizontal()

local home = os.getenv("HOME")
local confdir = home .. "/.config/awesome"
local icondir = confdir .. "/icons"


local graph_width = 40
local widget_height = 20
local prog_width = 4
local perc_width = 28


-- / bar
local rootfsbar = awful.widget.progressbar()
rootfsbar:set_vertical(true):set_width(prog_width):set_height(widget_height)
rootfsbar:set_ticks(false):set_ticks_size(2)
rootfsbar:set_border_color(nil)
--rootfsbar:set_background_color(beautiful.bg_widget)
rootfsbar:set_background_color("#494B4F")
rootfsbar:set_color({
	type = "linear",
	from = { 0, 0 },
	to = { 0, widget_height },
	stops = {
		{ 0, "#FF5656" },
		{ 0.5, "#88A175" },
		{ 1, "#AECF96" } } })
vicious.register(rootfsbar, vicious.widgets.fs, "${/ used_p}", 30)

-- /home bar
local homefsbar = awful.widget.progressbar()
homefsbar:set_vertical(true):set_width(prog_width):set_height(widget_height)
homefsbar:set_ticks(false):set_ticks_size(2)
homefsbar:set_border_color(nil)
--rootfsbar:set_background_color(beautiful.bg_widget)
homefsbar:set_background_color("#494B4F")
homefsbar:set_color({
	type = "linear",
	from = { 0, 0 },
	to = { 0, widget_height },
	stops = {
		{ 0, "#FF5656" },
		{ 0.5, "#88A175" },
		{ 1, "#AECF96" } } })
vicious.register(homefsbar, vicious.widgets.fs, "${/home used_p}", 30)


-- Root %
--local rootfspct = wibox.widget.textbox()
--rootfspct.width = perc_width
--vicious.register(rootfspct, vicious.widgets.fs, "${/ used_p}%", 10)


-- / used
local rootfsused = wibox.widget.textbox()
rootfsused:set_align("right")
vicious.register(rootfsused, vicious.widgets.fs, "<span size='6000'>/\n${/ avail_gb}GB</span>", 30)

-- /home used
local homefsused = wibox.widget.textbox()
homefsused:set_align("right")
vicious.register(homefsused, vicious.widgets.fs, "<span size='6000'>/home\n${/home avail_gb}GB</span>", 30)


-- / label
--local rootlable = wibox.widget.textbox()
--rootlable:set_text("/")
--rootlable:set_markup("<span size='6000'>/</span>")
--local homelable = wibox.widget.textbox()
--rootlable:set_text("/")
--homelable:set_markup("<span size='6000'>/home</span>")


-- Icons
local cpuimage = wibox.widget.imagebox()
cpuimage:set_image(icondir .. "/processor.png")
local memimage = wibox.widget.imagebox()
memimage:set_image(icondir .. "/memory.png")
local diskimage = wibox.widget.imagebox()
diskimage:set_image(icondir .. "/drive.png")

-- Mem Used %
vicious.cache(vicious.widgets.mem)


local mempwidget = wibox.widget.textbox()
vicious.register(mempwidget, vicious.widgets.mem, "$1%", 5)

-- Mem Bar
local memwidget = awful.widget.progressbar()
memwidget:set_vertical(true):set_width(prog_width):set_height(widget_height)
memwidget:set_background_color("#494B4F")
memwidget:set_border_color(nil)
memwidget:set_color({
	type = "linear",
	from = { 0, 0 },
	to = { 0, widget_height },
	stops = { {0, "#FF5656"}, {0.5, "#88A175"}, {1, "#AECF96" }}})
vicious.register(memwidget, vicious.widgets.mem, "$1", 5)

-- Cpu Graph
vicious.cache(vicious.widgets.cpu)

local cpuwidget = awful.widget.graph()
cpuwidget:set_width(graph_width):set_height(widget_height)
cpuwidget:set_background_color("#494B4F")
cpuwidget:set_color({
	type = "linear",
	from = { 0, 0 },
	to = { 0, widget_height },
	stops = { {0, "#FF5656"}, {0.5, "#88A175"}, {1, "#AECF96" }}})
vicious.register(cpuwidget, vicious.widgets.cpu, "$1", 2)	

-- Cpu %
local cpupwidget = wibox.widget.textbox()
cpupwidget.fit =
  function(box, w, h)
    local w, h = wibox.widget.textbox.fit(box, w, h)
    return math.max(perc_width, w), h
  end
vicious.register(cpupwidget, vicious.widgets.cpu, "$1%", 2)


local cpucount = 4
local cpubars = {}
for c = 1, cpucount do
	cpubars[c] = awful.widget.progressbar()
	cpubars[c]:set_vertical(true):set_width(prog_width):set_height(widget_height)
	cpubars[c]:set_background_color("#494B4F")
	cpubars[c]:set_border_color(nil)
	cpubars[c]:set_color({
		type = "linear",
		from = { 0, 0 },
		to = { 0, widget_height },
		stops = { {0, "#FF5656"}, {0.5, "#88A175"}, {1, "#AECF96" }}})
	vicious.register(cpubars[c], vicious.widgets.cpu, "$".. 1 + c, 2)
end


---- Cpu 1 Bar
--local cpu1bar = awful.widget.progressbar()
--cpu1bar:set_vertical(true):set_width(prog_width):set_height(widget_height)
--cpu1bar:set_background_color("#494B4F")
--cpu1bar:set_border_color(nil)
--cpu1bar:set_color({
	--type = "linear",
	--from = { 0, 0 },
	--to = { 0, widget_height },
	--stops = { {0, "#FF5656"}, {0.5, "#88A175"}, {1, "#AECF96" }}})
--vicious.register(cpu1bar, vicious.widgets.cpu, "$2", 2)

---- Cpu 2 Bar
--local cpu2bar = awful.widget.progressbar()
--cpu2bar:set_vertical(true):set_width(prog_width):set_height(widget_height)
--cpu2bar:set_background_color("#494B4F")
--cpu2bar:set_border_color(nil)
--cpu2bar:set_color({
	--type = "linear",
	--from = { 0, 0 },
	--to = { 0, widget_height },
	--stops = { {0, "#FF5656"}, {0.5, "#88A175"}, {1, "#AECF96" }}})
--vicious.register(cpu2bar, vicious.widgets.cpu, "$3", 2)


-- Blingbling CPU graph
--cpu_graph = blingbling.line_graph({ height = 18,
                                        --width = 200,
                                        --show_text = true,
                                        --label = "Load: $percent %",
                                        --rounded_size = 0.3,
                                        --graph_background_color = "#00000033"
                                      --})
--cpu_graph:set_height(18)
--cpu_graph:set_width(200)
--cpu_graph:set_show_text(true)
--cpu_graph:set_label("Load: $percent %")
--cpu_graph:set_rounded_size(0.3)
--cpu_graph:set_graph_background_color("#00000033")
--vicious.register(cpu_graph, vicious.widgets.cpu,'$1')


local diskinfo = wibox.layout.fixed.horizontal()
diskinfo:add(wibox.layout.margin(diskimage, 1, 1))
--diskinfo:add(wibox.layout.margin(rootlable, 1, 1))
diskinfo:add(wibox.layout.margin(rootfsused, 1, 1))
diskinfo:add(wibox.layout.margin(rootfsbar, 1, 5, 1, 1))
--diskinfo:add(wibox.layout.margin(homelable, 1, 1))
diskinfo:add(wibox.layout.margin(homefsused, 1, 1))
diskinfo:add(wibox.layout.margin(homefsbar, 1, 1, 1, 1))
statsbox:add(wibox.layout.margin(diskinfo, 0, 10))

local meminfo = wibox.layout.fixed.horizontal()
meminfo:add(wibox.layout.margin(memimage, 1, 1))
meminfo:add(wibox.layout.margin(memwidget, 1, 1, 1, 1))
meminfo:add(wibox.layout.margin(mempwidget, 1, 1))
statsbox:add(wibox.layout.margin(meminfo, 0, 10))

local cpuinfo = wibox.layout.fixed.horizontal()
cpuinfo:add(wibox.layout.margin(cpuimage, 1, 1))
cpuinfo:add(wibox.layout.margin(wibox.layout.mirror(cpuwidget, {vertical = true}), 1, 1, 1, 1))
for c = 1, cpucount do
	cpuinfo:add(wibox.layout.margin(cpubars[c], 1, 1, 1, 1))
end
--cpuinfo:add(wibox.layout.margin(cpu1bar, 1, 1, 1, 1))
--cpuinfo:add(wibox.layout.margin(cpu2bar, 1, 1, 1, 1))
cpuinfo:add(wibox.layout.margin(cpupwidget, 1, 1))
statsbox:add(wibox.layout.margin(cpuinfo, 0, 10))
