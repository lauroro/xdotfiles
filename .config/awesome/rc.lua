os.setlocale(os.getenv("LANG"))

-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")

local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")

local hotkeys_popup = require("awful.hotkeys_popup")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

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
    text = tostring(err) })
    in_error = false
  end)
end
-- }}}



-- Init
awful.spawn.with_shell("bash ~/.config/awesome/scripts/autorun.sh")

naughty.config.defaults.border_width = beautiful.notification_border_width
naughty.config.defaults.bg = beautiful.notification_bg
naughty.config.defaults.fg = beautiful.notification_fg


-- {{{ Variable definitions
local function set_wallpaper(s)
  -- Wallpaper
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    -- If wallpaper is a function, call it with the screen
    if type(wallpaper) == "function" then
      wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)
  end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)


-- Themes define colours, icons, font and wallpapers.
beautiful.init("~/.config/awesome/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "alacritty"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
  -- awful.layout.suit.floating,
  awful.layout.suit.tile,
  -- awful.layout.suit.tile.left,
  -- awful.layout.suit.tile.bottom,
  -- awful.layout.suit.tile.top,
  -- awful.layout.suit.fair,
  -- awful.layout.suit.fair.horizontal,
  -- awful.layout.suit.spiral,
  -- awful.layout.suit.spiral.dwindle,
  -- awful.layout.suit.max,
  -- awful.layout.suit.max.fullscreen,
  -- awful.layout.suit.magnifier,
  -- awful.layout.suit.corner.nw,
  -- awful.layout.suit.corner.ne,
  -- awful.layout.suit.corner.sw,
  -- awful.layout.suit.corner.se,
}
-- }}}




-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock( "%a %b %d [%R]" )

-- Memory Widget
local memory = wibox.widget{
  widget = wibox.widget.textbox,
}
awful.widget.watch('bash -c "free -m | grep Mem: | awk \'{ print $3 }\'"', 3, function(self, stdout)
  memory:set_text(tonumber(stdout))
end)

-- Brightness Widget
local brightness = wibox.widget{
  widget = wibox.widget.textbox,
}
local update_brightness = function()
  awful.spawn.easy_async("brightnessctl get", function(stdout)
    brightness:set_text(tostring(stdout))
  end)
end
update_brightness() -- for init

-- Audio Widget
local audio = wibox.widget{
  widget = wibox.widget.textbox,
}
local update_audio = function()
  awful.spawn.easy_async_with_shell("bash ~/.config/awesome/scripts/volume --get", function(stdout)
    audio:set_text(tostring(stdout))
  end)
end
update_audio() -- for init

-- Battery Widget
local battery = wibox.widget{
  widget = wibox.widget.textbox
}
awful.widget.watch("echo donothing", 3, function(self, stdout)
  awful.spawn.easy_async_with_shell("bash ~/.config/awesome/scripts/battery", function(stdout)
    battery:set_text(tostring(stdout))
  end)
end)

-- Network Widget
local network = wibox.widget{
  widget = wibox.widget.textbox
}
network:set_text("󰤯 ...") -- for init
awful.widget.watch("echo donothing", 4, function(self, stdout)
  awful.spawn.easy_async_with_shell("bash ~/.config/awesome/scripts/network", function(stdout)
    network:set_text(tostring(stdout))
  end)
end)


-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
awful.button({ }, 1, function(t) t:view_only() end),
awful.button({ modkey }, 1, function(t)
  if client.focus then
    client.focus:move_to_tag(t)
  end
end),
awful.button({ }, 3, awful.tag.viewtoggle),
awful.button({ modkey }, 3, function(t)
  if client.focus then
    client.focus:toggle_tag(t)
  end
end),
awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)



awful.screen.connect_for_each_screen(function(s)
  -- Wallpaper
  set_wallpaper(s)

  -- Each screen has its own tag table.
  awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

  -- -- Create an imagebox widget which will contain an icon indicating which layout we're using.
  -- -- We need one layoutbox per screen.
  -- s.mylayoutbox = awful.widget.layoutbox(s)
  -- s.mylayoutbox:buttons(gears.table.join(
  --                        awful.button({ }, 1, function () awful.layout.inc( 1) end),
  --                        awful.button({ }, 3, function () awful.layout.inc(-1) end),
  --                        awful.button({ }, 4, function () awful.layout.inc( 1) end),
  --                        awful.button({ }, 5, function () awful.layout.inc(-1) end)))

  -- Create a taglist widget
  s.mytaglist = awful.widget.taglist {
    screen  = s,
    filter  = awful.widget.taglist.filter.all,
    buttons = taglist_buttons
  }


  -- Create the wibox
  s.mywibox = awful.wibar({ position = "top", screen = s })

  -- Add widgets to the wibox
  s.mywibox:setup {
    layout = wibox.layout.align.horizontal,
    { -- Left widgets
    layout = wibox.layout.fixed.horizontal,
    s.mytaglist,
  },
  s.mytasklist, -- Middle widget
  { -- Right widgets
  layout = wibox.layout.fixed.horizontal,
  wibox.widget.systray(),
  wibox.widget.textbox(' | '),
  network,
  wibox.widget.textbox(' |  '),
  memory,
  wibox.widget.textbox('M |  '),
  brightness,
  wibox.widget.textbox(' | '),
  audio,
  wibox.widget.textbox(' | '),
  battery,
  wibox.widget.textbox(' | '),
  mytextclock,
  wibox.widget.textbox(' '),
},
    }
  end)
  -- }}}



  -- {{{ Key bindings
  globalkeys = gears.table.join(
  awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
  {description="show help", group="awesome"}),
  awful.key({  }, "Print", function()
    awful.util.spawn_with_shell("maim $HOME/$(date)")
  end, {description="screenshot", group="awesome"}),
  awful.key({ modkey,           }, "h",   awful.tag.viewprev,
  {description = "view previous", group = "tag"}),
  awful.key({ modkey,           }, "l",  awful.tag.viewnext,
  {description = "view next", group = "tag"}),
  -- Multimedia    
  awful.key({}, "XF86AudioLowerVolume",  function ()
    awful.util.spawn_with_shell("bash ~/.config/awesome/scripts/volume --down") 
    update_audio() end,{description = "volume down", group = "multimedia"}),
    awful.key({}, "XF86AudioRaiseVolume",  function ()
      awful.util.spawn_with_shell("bash ~/.config/awesome/scripts/volume --up") 
      update_audio() end, {description = "volume up", group = "multimedia"}),
      awful.key({}, "XF86AudioMute",  function ()
        awful.util.spawn_with_shell("pactl set-sink-mute @DEFAULT_SINK@ toggle")
        update_audio() end, {description = "volume mute toggle", group = "multimedia"}),
        awful.key({}, "XF86AudioMicMute",  function ()
          awful.util.spawn_with_shell("pactl set-source-mute @DEFAULT_SOURCE@ toggle") end,
          {description = "mic mute toggle", group = "multimedia"}),
          awful.key({}, "XF86MonBrightnessUp",  function ()
            awful.util.spawn_with_shell("brightnessctl s 10%+")
            update_brightness() end, {description = "brightness up", group = "multimedia"}),
            awful.key({}, "XF86MonBrightnessDown",  function () 
              awful.util.spawn_with_shell("brightnessctl s 10%-") 
              update_brightness() end, {description = "brightness down", group = "multimedia"}),

              awful.key({ modkey,           }, "Right",
              function ()
                awful.client.focus.byidx( 1)
              end,
              {description = "focus next by index", group = "client"}
              ),
              awful.key({ modkey,           }, "Left",
              function ()
                awful.client.focus.byidx(-1)
              end,
              {description = "focus previous by index", group = "client"}
              ),

              -- Layout manipulation
              awful.key({ modkey, "Shift"   }, "Right", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
              awful.key({ modkey, "Shift"   }, "Left", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),

              -- Standard program
              awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),

              awful.key({ modkey, }, "space", function () awful.util.spawn_with_shell("bash ~/.config/rofi/launcher.sh") end,
              {description = "rofi applauncher", group = "launcher"}),

              awful.key({ modkey, }, "p", function () awful.util.spawn_with_shell("bash ~/.config/rofi/powermenu.sh") end,
              {description = "rofi powermenu", group = "launcher"}),

              awful.key({ modkey, }, "t", function () awful.util.spawn("thunar") end,
              {description = "file manager", group = "launcher"}),

              awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
              awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

              awful.key({ modkey, "Shift" }, "l",     function () awful.tag.incmwfact( 0.01) end,
              {description = "increase master width factor", group = "layout"}),
              awful.key({ modkey, "Shift" }, "h",     function () awful.tag.incmwfact(-0.01) end,
              {description = "decrease master width factor", group = "layout"}),
              awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true) end,
              {description = "increase the number of columns", group = "layout"}),
              awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true) end,
              {description = "decrease the number of columns", group = "layout"})

              -- awful.key({ modkey, "Shift" }, "space", function () awful.layout.inc( 1) end,
              -- {description = "select next", group = "layout"})
              )

              clientkeys = gears.table.join(
              awful.key({ modkey,           }, "m",
              function (c)
                c.fullscreen = not c.fullscreen
                c:raise()
              end,
              {description = "toggle fullscreen", group = "client"}),
              awful.key({ modkey,   }, "q",      function (c) c:kill() end,
              {description = "close", group = "client"}),
              awful.key({ modkey, }, "f",  awful.client.floating.toggle,
              {description = "toggle floating", group = "client"}),
              awful.key({ modkey, "Control" }, "Left", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"})
              )

              -- Bind all key numbers to tags.
              -- Be careful: we use keycodes to make it work on any keyboard layout.
              -- This should map on the top row of your keyboard, usually 1 to 9.
              for i = 1, 9 do
                globalkeys = gears.table.join(globalkeys,
                -- View tag only.
                awful.key({ modkey }, "#" .. i + 9,
                function ()
                  local screen = awful.screen.focused()
                  local tag = screen.tags[i]
                  if tag then
                    tag:view_only()
                  end
                end,
                {description = "view tag #"..i, group = "tag"}),
                -- Move client to tag.
                awful.key({ modkey, "Shift" }, "#" .. i + 9,
                function ()
                  if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                      client.focus:move_to_tag(tag)
                    end
                  end
                end,
                {description = "move focused client to tag #"..i, group = "tag"})
                )
              end

              clientbuttons = gears.table.join(
              awful.button({ }, 1, function (c)
                c:emit_signal("request::activate", "mouse_click", {raise = true})
              end),
              awful.button({ modkey }, 1, function (c)
                c:emit_signal("request::activate", "mouse_click", {raise = true})
                awful.mouse.client.move(c)
              end),
              awful.button({ modkey }, 3, function (c)
                c:emit_signal("request::activate", "mouse_click", {raise = true})
                awful.mouse.client.resize(c)
              end)
              )

              -- Set keys
              root.keys(globalkeys)
              -- }}}

              -- {{{ Rules
              -- Rules to apply to new clients (through the "manage" signal).
              awful.rules.rules = {
                -- All clients will match this rule.
                { 
                  rule = { },
                  properties = { border_width = beautiful.border_width,
                  border_color = beautiful.border_normal,
                  focus = awful.client.focus.filter,
                  raise = true,
                  keys = clientkeys,
                  buttons = clientbuttons,
                  screen = awful.screen.preferred,
                  placement = awful.placement.no_overlap+awful.placement.no_offscreen
                }
              },
            }
            -- }}}



            -- {{{ Signals
            -- Signal function to execute when a new client appears.
            client.connect_signal("manage", function (c)
              -- Set the windows at the slave,
              -- i.e. put it at the end of others instead of setting it master.
              -- if not awesome.startup then awful.client.setslave(c) end

              if awesome.startup
                and not c.size_hints.user_position
                and not c.size_hints.program_position then
                -- Prevent clients from being unreachable after screen count changes.
                awful.placement.no_offscreen(c)
              end
              -- Put new clients at the end of slave stack
              awful.client.cycle()
            end)
            -- On client floating
            client.connect_signal("property::floating", function(c)
              if c.floating then
                c:geometry( { width = 900, height = 600 } )
                awful.placement.centered(c)
                c.ontop = true
              else
                c.ontop = false
              end
            end)


            -- Enable sloppy focus, so that focus follows mouse.
            client.connect_signal("mouse::enter", function(c)
              c:emit_signal("request::activate", "mouse_enter", {raise = false})
            end)

            client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
            client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
            -- }}}
