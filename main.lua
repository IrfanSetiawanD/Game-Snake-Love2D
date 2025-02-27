love.window.setTitle("Snake Game")
love.window.setMode(600, 600)

require "menu"
require "game"
require "settings"

function love.load()
    background = love.graphics.newImage("assets/Munchy Snake.JPG")
    gameState = "menu"
    menu.load()
    game.load()
    settings.load()
end

function love.update(dt)
    if gameState == "menu" then
        menu.update(dt)
    elseif gameState == "playing" then
        game.update(dt)
    elseif gameState == "settings" then
        settings.update(dt)
    end
end

function love.draw()
    if gameState == "menu" then
        love.graphics.draw(background, 0, 0)
        menu.draw()
    elseif gameState == "playing" then
        game.draw()
    elseif gameState == "paused" then
        game.draw()  -- Tetap menggambar game sebelum overlay pause
        drawPauseMenu()
    elseif gameState == "settings" then
        settings.draw()
    end
end

function drawPauseMenu()
    love.graphics.setColor(0, 0, 0, 0.7)  -- Overlay transparan
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    love.graphics.setColor(1, 1, 1)  -- Warna teks putih
    love.graphics.printf("PAUSED", 0, 100, love.graphics.getWidth(), "center")

    -- Gambar opsi menu
    for i, option in ipairs(pauseMenu) do
        if i == pauseSelection then
            love.graphics.setColor(1, 1, 0)  -- Warna kuning untuk opsi yang dipilih
        else
            love.graphics.setColor(1, 1, 1)  -- Warna putih untuk opsi lainnya
        end
        love.graphics.printf(option, 0, 200 + (i - 1) * 40, love.graphics.getWidth(), "center")
    end
    love.graphics.setColor(1, 1, 1, 0.7)  -- Warna putih dengan transparansi
    love.graphics.printf("Tekan ESC untuk melanjutkan", 0, 350, love.graphics.getWidth(), "center")
end

previousState = "menu"  -- Menyimpan state sebelum masuk ke settings
pauseMenu = {"Main Menu", "Settings", "Exit"}
pauseSelection = 1  -- Indeks pilihan menu yang dipilih


function love.keypressed(key)
    if gameState == "menu" then
        menu.keypressed(key)
    elseif gameState == "playing" then
        game.keypressed(key)
    elseif gameState == "paused" then
        if key == "up" then
            pauseSelection = pauseSelection - 1
            if pauseSelection < 1 then
                pauseSelection = #pauseMenu
            end
        elseif key == "down" then
            pauseSelection = pauseSelection + 1
            if pauseSelection > #pauseMenu then
                pauseSelection = 1
            end
        elseif key == "return" or key == "space" then
            if pauseSelection == 1 then  -- Main Menu
                gameState = "menu"
            elseif pauseSelection == 2 then
                previousState = gameState  -- Settings
                gameState = "settings"
            elseif pauseSelection == 3 then  -- Exit
                love.event.quit()
            end
        elseif key == "escape" then
            gameState = "playing"  -- Kembali bermain
        end
    elseif gameState == "settings" then
        settings.keypressed(key)
    end
end
