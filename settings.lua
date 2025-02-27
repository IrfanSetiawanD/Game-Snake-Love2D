settings = {}

function settings.load()
    settings.options = {"BG Music Volume", "SFX Volume", "Back"}
    settings.selected = 1
    settings.bgVolume = 0.5
    settings.sfxVolume = 1.0
end

function settings.update(dt)
    bgMusic:setVolume(settings.bgVolume)
    eatSound:setVolume(settings.sfxVolume)
    gameOverSound:setVolume(settings.sfxVolume)
end

function settings.draw()
    love.graphics.printf("Settings", 0, 50, 600, "center")

    for i, option in ipairs(settings.options) do
        if i == settings.selected then
            love.graphics.setColor(1, 1, 0)
        else
            love.graphics.setColor(1, 1, 1)
        end

        if i == 1 then
            love.graphics.printf(option .. ": " .. math.floor(settings.bgVolume * 100) .. "%", 0, 150, 600, "center")
        elseif i == 2 then
            love.graphics.printf(option .. ": " .. math.floor(settings.sfxVolume * 100) .. "%", 0, 190, 600, "center")
        else
            love.graphics.printf(option, 0, 230, 600, "center")
        end
    end
end

function settings.keypressed(key)
    if key == "down" then
        settings.selected = (settings.selected % #settings.options) + 1
    elseif key == "up" then
        settings.selected = (settings.selected - 2) % #settings.options + 1
    elseif key == "left" then
        if settings.selected == 1 then settings.bgVolume = math.max(0, settings.bgVolume - 0.1)
        elseif settings.selected == 2 then settings.sfxVolume = math.max(0, settings.sfxVolume - 0.1) end
    elseif key == "right" then
        if settings.selected == 1 then settings.bgVolume = math.min(1, settings.bgVolume + 0.1)
        elseif settings.selected == 2 then settings.sfxVolume = math.min(1, settings.sfxVolume + 0.1) end
    elseif key == "return" and settings.selected == 3 then
        gameState = previousState
    end
end

return settings
