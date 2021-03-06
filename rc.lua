-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
-- tyrannical dynamic tagging
--local tyrannical = require("tyrannical")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local vicious = require("vicious")
local statusbox = require("statsbox")

-- Load Debian menu entries
local debian_menu = require("debian_menu")

function run_once(prg,arg_string,pname,screen)
    if not prg then
        do return nil end
    end

    if not pname then
       pname = prg
    end

    if not arg_string then 
        awful.util.spawn_with_shell("pgrep -f -u $USER -x '" .. pname .. "' || (" .. prg .. ")",screen)
    else
        awful.util.spawn_with_shell("pgrep -f -u $USER -x '" .. pname .. " ".. arg_string .."' || (" .. prg .. " " .. arg_string .. ")",screen)
    end
end

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

--local home = os.getenv("HOME")
local confdir = awful.util.getdir("config")
local icondir = confdir .. "/icons"


-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
--beautiful.init("/usr/share/awesome/themes/default/theme.lua")
beautiful.init(confdir .. "/current_theme/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "x-terminal-emulator"
--editor = os.getenv("EDITOR") or "editor"
--editor_cmd = terminal .. " -e " .. editor
editor_cmd = "geany"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
--tags = {}


--for s = 1, screen.count() do
    ---- Each screen has its own tag table.
    --tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
--end

local tagDescriptors = {
    { "1:☁", awful.layout.suit.tile, },-- "network-cloud.png" },
    { "2:▒", awful.layout.suit.tile, },--"terminal.png" },
    { "3:✎", awful.layout.suit.tile, },--"document-text.png" },
    { "4:↟", awful.layout.suit.tile, },-- "folder-horizontal-open.png" },
    { "5:☣", awful.layout.suit.tile, }, --"wrench-screwdriver.png" },
    { "6:☹", awful.layout.suit.tile, }, --"wrench-screwdriver.png" },
    { "7:⚒", awful.layout.suit.tile, }, --"wrench-screwdriver.png" },
    { "8:☠", awful.layout.suit.tile, }, --"wrench-screwdriver.png" },
    { "9:☠", awful.layout.suit.tile, }, --"wrench-screwdriver.png" },
    { "0:✉", awful.layout.suit.tile.bottom, }, --"wrench-screwdriver.png" },
}

local tags = {}

for s = 1, screen.count() do
	for t, tagDesc in ipairs(tagDescriptors) do
		tags[#tags + 1] = awful.tag.add(tagDesc[1], {screen=s, layout=tagDesc[2] })
		if tagDesc[3] ~= nill then
			awful.tag.seticon(confdir .. "/icons/" .. tagDesc[3], tags[#tags])
		end
	end
end

awful.tag.viewonly(tags[1])

-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -x man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { 
                                    { "-----Net-----" },
                                    { "&Firefox", "firefox", awful.util.geticonpath("firefox") },
                                    { "Evolution", "evolution" },
                                    { "Skype", "skype" },
                                    { "----VBox-----" },
                                    { "&VirtualBox", "virtualbox", awful.util.geticonpath("virtualbox") },
                                    { "----Files-----" },
                                    { "Th&unar", "thunar", "/usr/share/pixmaps/Thunar/Thunar-about-logo.png" },
                                    { "PCManfm", "pcmanfm" },
                                    { "&Mc", terminal .. " -x mc", awful.util.geticonpath("mc", {"xpm"}) },
                                    { "----Dev----" },
                                    { "ideaJ", "/home/cody/idea-IC-129.713/bin/idea.sh" },
                                    { "eclipse", "/home/cody/eclipse-4.3/eclipse" },
                                    { "smartSVN", "/home/cody/smartsvn-7_5_5/bin/smartsvn.sh" },
                                    { "----Utils----" },
                                    { "&Terminal", terminal, awful.util.geticonpath("terminator") },
                                    { "&htop", terminal .. " -x htop", awful.util.geticonpath("htop") },
                                    { "&Aptitude", terminal .. " -x aptitude" },
                                    { "-------------" },
                                    { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "Debian", debian_menu.Debian, awful.util.geticonpath("debian-logo") },
                                    { "-------------" },
                                    { "Lock", "xtrlock" },
                                    { "Suspend", "pm-suspend" },
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock("%d/%m %Hh%M")
--myconkybar = {}





-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- cody conkybar
    --myconkybar[s] = awful.wibox({ position = "bottom", screen = 1, ontop = false, width = 1, height = 18 })

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    if s == 1 then right_layout:add(statsbox) end
    if s == 1 then right_layout:add(mytextclock) end
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end),


    awful.key({ modkey, "Control", "Shift" }, "l", function () awful.util.spawn_with_shell("xtrlock") end),
    awful.key({ modkey, "Control", "Shift" }, "p", function () awful.util.spawn_with_shell("scrot '%Y, %B %d, %H:%M:%S @ $wx$h.png' -e 'mv \"$f\" ~/Screenshots/'") end)
    
    
--awful.util.spawn_with_shell("xmodmap /home/cody/.xmodmaprc.tight")    
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
--numKeysOffset = 17 -- tightVNC ???
numKeysOffset = 9 -- Normal
for i = 1, 10 do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + numKeysOffset,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + numKeysOffset,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + numKeysOffset,
                  function ()
                      local tag = awful.tag.gettags(client.focus.screen)[i]
                      if client.focus and tag then
                          awful.client.movetotag(tag)
                     end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + numKeysOffset,
                  function ()
                      local tag = awful.tag.gettags(client.focus.screen)[i]
                      if client.focus and tag then
                          awful.client.toggletag(tag)
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))
--    awful.button({ modkey, "Control" }, 1, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
    { rule = { class = "Firefox" }, except_any = { instance = { "Dialog" }, name = { "Firefox Preferences" } },
--    { rule = { class = "Firefox" }, except = { instance = "Dialog" },
      properties = { tag = tags[1], switchtotag = tags[1] } },
    { rule = { name = "Firefox Preferences" },
      properties = { floating = true } },
    { rule = { name = "DownThemAll!" },
      properties = { floating = true } },
    { rule_any = { class = { "X-terminal-emulator", "terminator" } },
      properties = { tag = tags[2], switchtotag = tags[2] } },
    { rule = { class = "Geany" },
      properties = { tag = tags[3], switchtotag = tags[3] } },
    { rule = { class = "Thunar" },
      properties = { tag = tags[4], switchtotag = tags[4] } },
    { rule = { class = "VirtualBox" }, except_any = { name = { "win7", "Close Virtual Machine" } },
      properties = { tag = tags[5], switchtotag = tags[5] } },
    { rule = { class = "VirtualBox", name = "win7" },
      properties = { tag = tags[6], switchtotag = tags[6] } },
    --{ rule = {}, except = { machine = "cody-axway" },
      --properties = { border_width = 3 } },
    { rule_any = { class = { "Skype", "Pidgin", "Evolution" } },
      properties = { tag = tags[10] }, switchtotag = tags[10] },
    --{ rule = { class = "Skype" },
      --properties = { tag = tags[10] }, switchtotag = tags[10] },
    --{ rule = { class = "Pidgin" },
      --properties = { tag = tags[10] }, switchtotag = tags[10] },
    --{ rule = { class = "Evolution" },
      --properties = { tag = tags[10] }, switchtotag = tags[10] },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

--run_once("xscreensaver","-no-splash")
--run_once("pidgin",nil,nil,2)
--run_once("wicd-client",nil,"/usr/bin/python2 -O /usr/share/wicd/gtk/wicd-client.py")
--run_once("conky","-c /home/cody/.config/awesome/.conkyrc-awesome")
--run_once("xmodmap", "-e \"add mod4 = Super_L\"")
--awful.util.spawn_with_shell("sleep 5s && xmodmap -e 'add mod4 = Super_L'")
--awful.util.spawn_with_shell("xmodmap /home/cody/.xmodmaprc.tight")
--run_once("update-notifier")
--run_once("nm-applet")

-- the volume icon
run_once("volti", nil, "/usr/bin/python /usr/bin/volti")

-- our wallpaper rotater
run_once("/opt/extras.ubuntu.com/variety/bin/variety", nil, "/usr/bin/python /opt/extras.ubuntu.com/variety/bin/variety")

-- screenshot tool
run_once("shutter --min_at_startup", nil, "/usr/bin/perl /usr/bin/shutter --min_at_startup")

-- tell us about needing updates (even if the install now button currently does not work)
run_once("update-notifier")

-- start dropbox
awful.util.spawn_with_shell("dropbox start")

-- start the vnc server (attaches to the current x-session)
run_once("/usr/lib/vino/vino-server")

-- load the keyboard variant for international symbols
awful.util.spawn_with_shell("setxkbmap us -variant altgr-intl")
