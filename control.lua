mod_gui = require('mod-gui')


function guistuff(player)
    local ptable = global.players[player.index]

    if not global.guiloaded[player.index] then

        local modbuttons = mod_gui.get_button_flow(player)
        local modguis = mod_gui.get_frame_flow(player)

        if modbuttons.todo_list_top_button then modbuttons.todo_list_top_button.destroy() end

        ptable.topbutton =
        modbuttons.add({type="sprite-button", name="todo_list_top_button", sprite="todo-list-top-button-sprite"})

        if modguis.todo_list_main_frame then modguis.todo_list_main_frame.destroy() end

        ptable.maingui =
        modguis.add({
            type = "frame",
            name = "todo_list_main_frame",
            caption = "Todo List",
            direction = "vertical",
            visible = false
        })

        ptable.task_list = ptable.maingui.add({
            type = "scroll-pane",
            vertical_scroll_policy = "auto-and-reserve-space",
            horizontal_scroll_policy = "never"
        })
        ptable.task_list.style.height = 400
        ptable.task_list.style.width = 200

        local a = ptable.maingui.add({
            type = "flow",
        })

        ptable.new_task =
        a.add({
            type = "textfield"
        })

        a.add({
            type = "sprite",
            sprite = "utility/add"
        })


        global.guiloaded[player.index] = true
    end
end

function makenewtask(player, task)
    local ptable = global.players[player.index]

    local newflow = ptable.task_list.add({
        type = "flow",
        direction = "horizontal"
    })
    newflow.style.padding = {5,0,5,0}
    newflow.style.width = 200

    local newlabel = newflow.add({
        type = "label",
        caption = task
    })
    newlabel.style.single_line = false
    newlabel.style.width = 155

    local newcompletebutton = newflow.add({
        type = "sprite-button",
        sprite = "utility/check_mark_green",
        name = "todo_list_task_complete_button"
    })
    newcompletebutton.style.horizontal_align = "right"
    newcompletebutton.style.vertical_align = "bottom"
    newcompletebutton.style.width = 35
end

script.on_init(function()
    global.guiloaded = {}
    global.players = {}

    for _, player in pairs(game.players) do
        global.guiloaded[player.index] = false
        global.players[player.index] = {}

        guistuff(player)
    end
end)

script.on_load(function()
    log(serpent.block(global))
end)

script.on_event({defines.events.on_player_created, defines.events.on_console_chat}, function(event)
    local player = game.players[event.player_index]

    global.guiloaded[player.index] = false
    global.players[player.index] = {}

    guistuff(player)
end)

script.on_event({defines.events.on_gui_click, defines.events.on_gui_confirmed}, function(event)
    local element = event.element
    local player = game.players[event.player_index]
    local ptable = global.players[player.index]

    if element.name == "todo_list_top_button" then
        if ptable.maingui then
            ptable.maingui.visible = not ptable.maingui.visible
            ptable.new_task.text = ""
        end
    elseif element == ptable.new_task then
        local tasktitle = ptable.new_task.text
        ptable.new_task.text = ""
        if #tasktitle > 0 then
            makenewtask(player, tasktitle)
        end
    elseif element.name == "todo_list_task_complete_button" then
        element.parent.destroy()
    end
end)
