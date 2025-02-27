menu = {}

function menu.load()
    menu.options = {"Start", "Settings", "Exit"}
    menu.selected = 1
end

function menu.update(dt)
    -- Kosongkan jika belum ada logika update untuk menu
end

function menu.draw()
    love.graphics.printf("SNAKE GAME", 0, 100, love.graphics.getWidth(), "center")

    for i, option in ipairs(menu.options) do
        if i == menu.selected then
            love.graphics.setColor(1, 1, 0)
        else
            love.graphics.setColor(1, 1, 1)
        end
        love.graphics.printf(option, 0, 200 + (i - 1) * 40, love.graphics.getWidth(), "center")
    end
end

function menu.keypressed(key)
    if key == "down" then
        menu.selected = (menu.selected % #menu.options) + 1
    elseif key == "up" then
        menu.selected = (menu.selected - 2) % #menu.options + 1
    elseif key == "return" then
        if menu.selected == 1 then
            game.reset()
            gameState = "playing"
        elseif menu.selected == 2 then
            gameState = "settings"
        elseif menu.selected == 3 then
            love.event.quit()
        end
    end
end

return menu
