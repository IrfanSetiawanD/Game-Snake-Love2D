love.window.setTitle("Munchy SnakZzz")

local screenWidth, screenHeight

function detectScreenSize()
    local os = love.system.getOS()
    screenWidth, screenHeight = love.window.getDesktopDimensions()

    -- Jika di Android, atur fullscreen
    if os == "Android" then
        love.window.setMode(0, 0, {fullscreen = true})
        screenWidth, screenHeight = love.graphics.getDimensions()
    else
        -- Jika di PC, sesuaikan resolusi dalam mode landscape
        if screenWidth < screenHeight then
            screenWidth, screenHeight = screenHeight, screenWidth -- Tukar width dan height agar landscape
        end
        love.window.setMode(screenWidth, screenHeight)
    end
end

detectScreenSize() -- Panggil fungsi deteksi layar

require "menu"
require "game"
require "settings"

local background, bgScaleX, bgScaleY

function love.load()
    background = love.graphics.newImage("assets/Munchy Snake.jpg")
    gameState = "menu"
    menu.load()
    game.load()
    settings.load()
    
    -- Hitung skala background agar sesuai dengan layar
    bgScaleX = screenWidth / background:getWidth()
    bgScaleY = screenHeight / background:getHeight()
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
    -- Gambar background agar sesuai dengan layar
    love.graphics.draw(background, 0, 0, 0, bgScaleX, bgScaleY)

    if gameState == "menu" then
        menu.draw()
    elseif gameState == "playing" then
        game.draw()
    elseif gameState == "paused" then
        game.draw()  -- Tetap menggambar game sebelum overlay pause
        drawPauseMenu()
    elseif gameState == "gameover" then
        game.draw()  -- Tetap menggambar game sebelum overlay Game Over
        drawGameOverMenu()
    elseif gameState == "settings" then
        settings.draw()
    end
end

previousState = "menu"  -- Menyimpan state sebelum masuk ke settings
pauseMenu = {"Main Menu", "Settings", "Exit"}
pauseSelection = 1  -- Indeks pilihan menu yang dipilih
gameOverMenu = {"Start Again", "Main Menu", "Exit"}
gameOverSelection = 1  -- Indeks pilihan yang dipilih

function drawPauseMenu()
    -- Overlay transparan
    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle("fill", 0, 0, screenWidth, screenHeight)

    -- Ukuran font
    local titleFont = love.graphics.newFont(48)
    local menuFont = love.graphics.newFont(28)
    local hintFont = love.graphics.newFont(22)

    -- Teks "PAUSED" di tengah layar, lebih dekat ke menu
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(titleFont)
    love.graphics.printf("PAUSED", 0, screenHeight * 0.35, screenWidth, "center")

    -- Teks menu dengan jarak lebih dekat ke "PAUSED"
    love.graphics.setFont(menuFont)
    for i, option in ipairs(pauseMenu) do
        if i == pauseSelection then
            love.graphics.setColor(1, 1, 0)  -- Warna kuning untuk pilihan aktif
        else
            love.graphics.setColor(1, 1, 1)  -- Warna putih untuk lainnya
        end
        love.graphics.printf(option, 0, screenHeight * 0.45 + (i - 1) * 35, screenWidth, "center")
    end

    -- Teks hint lebih dekat ke menu
    love.graphics.setFont(hintFont)
    love.graphics.setColor(1, 1, 1, 0.7)
    love.graphics.printf("Tekan ESC untuk melanjutkan", 0, screenHeight * 0.65, screenWidth, "center")
end


function drawGameOverMenu()   
    -- Overlay transparan dengan efek semi-gelap
    love.graphics.setColor(0, 0, 0, 0.6)
    love.graphics.rectangle("fill", 0, 0, screenWidth, screenHeight)

    -- Teks Game Over besar dan berwarna merah terang
    love.graphics.setColor(1, 0, 0)
    love.graphics.setFont(love.graphics.newFont(48))
    love.graphics.printf("GAME OVER", 0, screenHeight / 4, screenWidth, "center")

    -- Teks skor & best score
    love.graphics.setFont(love.graphics.newFont(28))
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Final Score: " .. score, 0, screenHeight / 2 - 40, screenWidth, "center")
    love.graphics.printf("Best Score: " .. game.bestScore, 0, screenHeight / 2, screenWidth, "center")

    -- Opsi menu dengan highlight warna kuning untuk pilihan aktif
    for i, option in ipairs(gameOverMenu) do
        if i == gameOverSelection then
            love.graphics.setColor(1, 1, 0)  -- Warna kuning untuk pilihan aktif
        else
            love.graphics.setColor(1, 1, 1)  -- Warna putih untuk lainnya
        end
        love.graphics.printf(option, 0, screenHeight / 2 + 60 + (i - 1) * 40, screenWidth, "center")
    end
end

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
            elseif pauseSelection == 2 then  -- Settings
                previousState = gameState
                gameState = "settings"
            elseif pauseSelection == 3 then  -- Exit
                love.event.quit()
            end
        elseif key == "escape" then
            gameState = "playing"
        end
    elseif gameState == "gameover" then
        if key == "up" then
            gameOverSelection = gameOverSelection - 1
            if gameOverSelection < 1 then
                gameOverSelection = #gameOverMenu
            end
        elseif key == "down" then
            gameOverSelection = gameOverSelection + 1
            if gameOverSelection > #gameOverMenu then
                gameOverSelection = 1
            end
        elseif key == "return" or key == "space" then
            if gameOverSelection == 1 then  -- Start Again
                game.reset()
                gameState = "playing"
            elseif gameOverSelection == 2 then  -- Main Menu
                gameState = "menu"
            elseif gameOverSelection == 3 then  -- Exit
                love.event.quit()
            end
        end
    elseif gameState == "settings" then
        settings.keypressed(key)
    end
end

function love.touchpressed(id, x, y, dx, dy, pressure)
    if gameState == "menu" then
        menu.touchpressed(x, y)
    elseif gameState == "playing" then
        game.touchpressed(x, y)
    elseif gameState == "paused" then
        game.touchpressed(x, y)
    elseif gameState == "gameover" then
        game.touchpressed(x, y)
    elseif gameState == "settings" then
        settings.touchpressed(x, y)
    end
end
