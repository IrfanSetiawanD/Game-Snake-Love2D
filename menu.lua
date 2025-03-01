menu = {}

function menu.load()
    menu.options = {"Start", "Settings", "Exit"}
    menu.selected = 1
    menu.font = love.graphics.newFont(42)
end

function menu.update(dt)
end

function handleMenuSelection()
    if selectedMenuIndex == 1 then
        gameState = "playing"
    elseif selectedMenuIndex == 2 then
        gameState = "settings"
    elseif selectedMenuIndex == 3 then
        love.event.quit()
    end
end

function handleSettingsSelection()
    -- Tambahkan logika setting di sini
    gameState = "menu"
end

function handlePauseSelection()
    if selectedMenuIndex == 1 then
        gameState = "playing"
    elseif selectedMenuIndex == 2 then
        gameState = "menu"
    end
end


function menu.draw()
    love.graphics.setFont(menu.font)

    local textColor = {1, 1, 1}  -- Putih
    local shadowColor = {0, 0, 0} -- Hitam
    local highlightColor = {1, 1, 0} -- Kuning

    local width = love.graphics.getWidth()
    local totalHeight = #menu.options * 50  -- Tinggi semua opsi menu
    local startY = (love.graphics.getHeight() - totalHeight) / 2  -- Mulai dari tengah layar

    for i, option in ipairs(menu.options) do
        local y = startY + (i - 1) * 50

        -- Shadow
        love.graphics.setColor(shadowColor)
        love.graphics.printf(option, 2, y + 2, width, "center")

        -- Teks utama
        if i == menu.selected then
            love.graphics.setColor(highlightColor) -- Kuning untuk opsi terpilih
        else
            love.graphics.setColor(textColor) -- Putih untuk opsi lain
        end
        love.graphics.printf(option, 0, y, width, "center")
    end

    love.graphics.setColor(1, 1, 1) -- Reset warna
end

function menu.keypressed(key)
    if key == "down" then
        menu.selected = menu.selected + 1
        if menu.selected > #menu.options then
            menu.selected = 1
        end
    elseif key == "up" then
        menu.selected = menu.selected - 1
        if menu.selected < 1 then
            menu.selected = #menu.options
        end
    elseif key == "return" or key == "space" then
        if menu.selected == 1 then
            if game.reset then
                game.reset()
            end
            gameState = "playing"
        elseif menu.selected == 2 then
            gameState = "settings"
        elseif menu.selected == 3 then
            love.event.quit()
        end
    end
end

function menu.input()
    if menu.selected == 1 then
        game.reset()
        gameState = "playing"
    elseif menu.selected == 2 then
        gameState = "settings"
    elseif menu.selected == 3 then
        love.event.quit()
    end
end

function menu.touchpressed(x, y)
    local menuStartY = (love.graphics.getHeight() - (#menu.options * 50)) / 2
    for i, _ in ipairs(menu.options) do
        local optionY = menuStartY + (i - 1) * 50
        if y >= optionY and y <= optionY + 50 then
            menu.selected = i
            menu.input()
        end
    end
end

return menu
