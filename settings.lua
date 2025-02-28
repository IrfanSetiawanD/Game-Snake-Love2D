settings = {}

function settings.load()
    settings.options = {"BG Music Volume", "SFX Volume", "Back"}
    settings.selected = 1
    settings.bgVolume = 0.5
    settings.sfxVolume = 0.5

    -- Ukuran font
    settings.titleFont = love.graphics.newFont(34)  -- Font lebih besar untuk "Settings"
    settings.optionFont = love.graphics.newFont(24) -- Font lebih kecil untuk opsi lainnya
end

function settings.update(dt)
    bgMusic:setVolume(settings.bgVolume)
    eatSound:setVolume(settings.sfxVolume)
    newBestSound:setVolume(settings.sfxVolume)
    gameOverSound:setVolume(settings.sfxVolume)
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


function settings.draw()
    local width = love.graphics.getWidth()
    local totalHeight = #settings.options * 50
    local startY = (love.graphics.getHeight() - totalHeight) / 2 + 30  -- 30 agar agak turun sedikit
    local shadowOffset = 2  -- Offset bayangan

    -- Gambar shadow untuk judul "Settings"
    love.graphics.setFont(settings.titleFont)
    love.graphics.setColor(0, 0, 0, 0.5)  -- Bayangan hitam transparan
    love.graphics.printf("Settings", shadowOffset, startY - 80 + shadowOffset, width, "center")
    
    -- Gambar judul utama "Settings"
    love.graphics.setColor(1, 1, 1)  -- Warna putih
    love.graphics.printf("Settings", 0, startY - 80, width, "center")

    -- Gambar opsi menu dengan shadow
    love.graphics.setFont(settings.optionFont)
    for i, option in ipairs(settings.options) do
        local y = startY + (i - 1) * 50

        -- Shadow dulu
        love.graphics.setColor(0, 0, 0, 0.5)
        if i == 1 then
            love.graphics.printf(option .. ": " .. math.floor(settings.bgVolume * 100) .. "%", shadowOffset, y + shadowOffset, width, "center")
        elseif i == 2 then
            love.graphics.printf(option .. ": " .. math.floor(settings.sfxVolume * 100) .. "%", shadowOffset, y + shadowOffset, width, "center")
        else
            love.graphics.printf(option, shadowOffset, y + shadowOffset, width, "center")
        end

        -- Warna utama
        if i == settings.selected then
            love.graphics.setColor(1, 1, 0) -- Kuning untuk yang dipilih
        else
            love.graphics.setColor(1, 1, 1) -- Putih untuk yang lainnya
        end

        if i == 1 then
            love.graphics.printf(option .. ": " .. math.floor(settings.bgVolume * 100) .. "%", 0, y, width, "center")
        elseif i == 2 then
            love.graphics.printf(option .. ": " .. math.floor(settings.sfxVolume * 100) .. "%", 0, y, width, "center")
        else
            love.graphics.printf(option, 0, y, width, "center")
        end
    end

    -- Reset warna agar tidak mengganggu elemen lain
    love.graphics.setColor(1, 1, 1)
end

function settings.keypressed(key)
    if key == "down" then
        settings.selected = settings.selected + 1
        if settings.selected > #settings.options then
            settings.selected = 1
        end
    elseif key == "up" then
        settings.selected = settings.selected - 1
        if settings.selected < 1 then
            settings.selected = #settings.options
        end
    elseif key == "left" then
        if settings.selected == 1 then
            settings.bgVolume = math.max(0, settings.bgVolume - 0.1)
        elseif settings.selected == 2 then
            settings.sfxVolume = math.max(0, settings.sfxVolume - 0.1)
        end
    elseif key == "right" then
        if settings.selected == 1 then
            settings.bgVolume = math.min(1, settings.bgVolume + 0.1)
        elseif settings.selected == 2 then
            settings.sfxVolume = math.min(1, settings.sfxVolume + 0.1)
        end
    elseif key == "return" and settings.selected == 3 then
        gameState = previousState
    elseif key == "escape" then
        gameState = previousState
    end
end

return settings
