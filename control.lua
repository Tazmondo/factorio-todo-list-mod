local mod_gui = require('mod-gui')

local x = 1
local y

local myfunction = function(event)
    game.print(string.rep(math.random(1000), 100), {math.random(), math.random(), math.random(), math.random()})
    x = x + 1
end

local guistuff = function(player)
    if not global.guiloaded[player.name] then

        local modbuttons = mod_gui.get_button_flow(player)

        if modbuttons.todo_list then modbuttons.todo_list.destroy() end
        y = modbuttons.add({type="sprite-button", name="todo_list", sprite="todo-list-top-button-sprite"})

        global.guiloaded[player.name] = true
    end
end

script.on_init(function()
    global.guiloaded = {}

    for _, player in pairs(game.players) do
        global.guiloaded[player.name] = false
        guistuff(player)
    end
end)

script.on_event({defines.events.on_player_created}, function(event)
    local player = game.players[event.player_index]
    global.guiloaded[player.name] = false
    guistuff(player)
end)

script.on_event(defines.events.on_gui_click, function(event)
    local element = event.element
    local player = game.players[event.player_index]

    if element == y then
        myfunction(nil)
    end
end)
