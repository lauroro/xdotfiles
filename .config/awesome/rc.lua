os.setlocale(os.getenv("LANG"))
pcall(require, "luarocks.loader")
require("awful.autofocus")

local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local hotkeys_popup = require("awful.hotkeys_popup")

-- Variables
modkey = "Mod4"
terminal = "alacritty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor


-- Load theme
beautiful.init("~/.config/awesome/theme.lua")


-- {{{ Error handling
if awesome.startup_errors then
  naughty.notify({ preset = naughty.config.presets.critical,
  title = "Oops, there were errors during startup!",
  text = awesome.startup_errors })
end
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


-- Wallpaper
local function set_wallpaper(s)
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    if type(wallpaper) == "function" then
      wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)
  end
end
screen.connect_signal("property::geometry", set_wallpaper)



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




-- {{{ Wibar Widgets
-- Clock
local mytextclock = wibox.widget.textclock( "%a %b %d [%R]" )

-- Calendar
local month_calendar = awful.widget.calendar_popup.month({
  spacing = 5,
  margin = 5,
})
month_calendar:attach( mytextclock, "tr", {on_hover = false} )


-- Brightness
local brightness = wibox.widget{
  widget = wibox.widget.textbox,
}
local update_brightness = function()
  awful.spawn.easy_async_with_shell("bash ~/.config/awesome/scripts/brightness --get", function(stdout)
    brightness:set_text(tostring(stdout))
  end)
end
update_brightness() -- for init
brightness:buttons(
  awful.util.table.join(
    awful.button({}, 4, function ()
      awful.util.spawn_with_shell("bash ~/.config/awesome/scripts/brightness --up")
      update_brightness()
    end),
    awful.button({}, 5, function ()
      awful.util.spawn_with_shell("bash ~/.config/awesome/scripts/brightness --down")
      update_brightness()
    end)
  )
)

-- Audio
local audio = wibox.widget{
  widget = wibox.widget.textbox,
}
local update_audio = function()
  awful.spawn.easy_async_with_shell("bash ~/.config/awesome/scripts/volume --get", function(stdout)
    audio:set_text(tostring(stdout))
  end)
end
update_audio() -- for init
audio:buttons(
  awful.util.table.join(
    awful.button({}, 4, function ()
      awful.util.spawn_with_shell("bash ~/.config/awesome/scripts/volume --up")
      update_audio()
    end),
    awful.button({}, 5, function ()
      awful.util.spawn_with_shell("bash ~/.config/awesome/scripts/volume --down")
      update_audio()
    end),
    awful.button({}, 2, function ()
      awful.util.spawn_with_shell("pactl set-sink-mute @DEFAULT_SINK@ toggle")
      update_audio()
    end)
  )
)

-- Battery
local battery = wibox.widget{
  widget = wibox.widget.textbox
}
awful.widget.watch("echo donothing", 3, function(self, stdout)
  awful.spawn.easy_async_with_shell("bash ~/.config/awesome/scripts/battery", function(stdout)
    battery:set_text(tostring(stdout))
  end)
end)

-- Network
local network = wibox.widget{
  widget = wibox.widget.textbox
}
network:set_text("󰤯 ...") -- for init
awful.widget.watch("echo donothing", 4, function(self, stdout)
  awful.spawn.easy_async_with_shell("bash ~/.config/awesome/scripts/network", function(stdout)
    network:set_text(tostring(stdout))
  end)
end)


-- Taglist mouse buttons
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


-- Setup
awful.screen.connect_for_each_screen(function(s)
  set_wallpaper(s)
  awful.tag({ " 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 " }, s, awful.layout.layouts[1])

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
    buttons = taglist_buttons,
    style = {
      shape = function (cr, width, height)
        gears.shape.rounded_rect(cr, width, height, 3)
      end
    }
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
    -- Middle widget
    s.mytasklist,
    { -- Right widgets
      layout = wibox.layout.fixed.horizontal,
      wibox.widget.systray(),
      wibox.widget.textbox(' | '),
      network,
      wibox.widget.textbox(' |  '),
      brightness,
      wibox.widget.textbox('% | '),
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
  update_audio() 
end,{description = "volume down", group = "multimedia"}),
awful.key({}, "XF86AudioRaiseVolume",  function ()
  awful.util.spawn_with_shell("bash ~/.config/awesome/scripts/volume --up")
  update_audio()
end, {description = "volume up", group = "multimedia"}),
awful.key({}, "XF86AudioMute",  function ()
  awful.util.spawn_with_shell("pactl set-sink-mute @DEFAULT_SINK@ toggle")
  update_audio() 
end, {description = "volume mute toggle", group = "multimedia"}),
awful.key({}, "XF86AudioMicMute",  function ()
  awful.util.spawn_with_shell("pactl set-source-mute @DEFAULT_SOURCE@ toggle")
end, {description = "mic mute toggle", group = "multimedia"}),
awful.key({}, "XF86MonBrightnessUp",  function ()
  awful.util.spawn_with_shell("bash ~/.config/awesome/scripts/brightness --up")
  update_brightness() 
end, {description = "brightness up", group = "multimedia"}),
awful.key({}, "XF86MonBrightnessDown",  function ()
  awful.util.spawn_with_shell("bash ~/.config/awesome/scripts/brightness --down")
  update_brightness() 
end, {description = "brightness down", group = "multimedia"}),

awful.key({ modkey,           }, "Right",
function ()
  awful.client.focus.byidx( 1)
end, {description = "focus next by index", group = "client"}
),
awful.key({ modkey,           }, "Left",
function ()
  awful.client.focus.byidx(-1)
end, {description = "focus previous by index", group = "client"}
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
{ rule = { class = "firefox" },
properties = { opacity = 1, maximized = false, floating = false } },
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
