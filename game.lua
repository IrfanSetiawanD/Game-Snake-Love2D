game = {}

score = 0
bestScore = 0
game.bestScore = 0
gameState = "menu"  -- Menyimpan state permainan

function game.load()
    snakeHead = love.graphics.newImage("assets/snake_head.png")
    snakeBody = love.graphics.newImage("assets/snake_body.png")
    mouse = love.graphics.newImage("assets/mouse.png")
    bgGame = love.graphics.newImage("assets/bg_game.jpg")
    bgGrass = love.graphics.newImage("assets/bg_grass.jpg")

    bgMusic = love.audio.newSource("assets/bg_music.mp3", "stream")
    eatSound = love.audio.newSource("assets/eat.wav", "static")
    newBestSound = love.audio.newSource("assets/new_best.wav", "static")
    gameOverSound = love.audio.newSource("assets/gameover.wav", "static")

    bgMusic:setLooping(true)
    bgMusic:setVolume(0.5)
    love.audio.play(bgMusic)

    -- Menyesuaikan ukuran layar
    screenWidth = love.graphics.getWidth()
    screenHeight = love.graphics.getHeight()

    -- Arena ukuran 80% dari layar, agar ada ruang untuk score
    gridSize = 20
    gridCountX = math.floor(screenWidth * 0.8 / gridSize)
    gridCountY = math.floor(screenHeight * 0.8 / gridSize)
    arenaX = (screenWidth - gridCountX * gridSize) / 2
    arenaY = (screenHeight - gridCountY * gridSize) / 2 + 40  -- 40 untuk header score

    -- Hitung skala untuk menyesuaikan ukuran assets
    snakeScaleX = gridSize / snakeHead:getWidth()
    snakeScaleY = gridSize / snakeHead:getHeight()
    
    bodyScaleX = gridSize / snakeBody:getWidth()
    bodyScaleY = gridSize / snakeBody:getHeight()
    
    mouseScaleX = gridSize / mouse:getWidth()
    mouseScaleY = gridSize / mouse:getHeight()

    game.lastScreen = nil  -- Menyimpan tampilan terakhir

    game.reset()
end

function game.update(dt)
    if gameState == "playing" then
        timer = timer + dt
        if timer >= speed then
            timer = 0
            moveSnake()
        end
    end
end

function game.captureScreen()
    love.graphics.captureScreenshot(function(screenshot)
        game.lastScreen = love.graphics.newImage(screenshot)
    end)
end

function game.reset()
    snake = { body = { {x = 15, y = 15} }, dir = {x = 1, y = 0} }
    score = 0
    spawnFood()
    timer = 0
    speed = 0.1
end

function spawnFood()
    repeat
        food = {
            x = love.math.random(0, gridCountX - 1),
            y = love.math.random(0, gridCountY - 1)
        }
        local collision = false
        for _, segment in ipairs(snake.body) do
            if food.x == segment.x and food.y == segment.y then
                collision = true
                break
            end
        end
    until not collision  -- Pastikan food tidak spawn di tubuh ular
end

function moveSnake()
    local head = { x = snake.body[1].x + snake.dir.x, y = snake.body[1].y + snake.dir.y }

    -- Rotasi kepala sesuai arah gerakan
    if snake.dir.x == 1 then
        snake.rotation = math.pi          -- Kanan (0 radian)
    elseif snake.dir.x == -1 then
        snake.rotation = 0    -- Kiri (default, 180°)
    elseif snake.dir.y == 1 then
        snake.rotation = -math.pi/2 -- Atas (-90°)
    elseif snake.dir.y == -1 then
        snake.rotation = math.pi/2  -- Bawah (90°)
    end

    -- Teleportasi jika melewati batas layar
    head.x = (head.x + gridCountX) % gridCountX
    head.y = (head.y + gridCountY) % gridCountY


    -- Cek tabrakan dengan badan
    for i = 2, #snake.body do
        if head.x == snake.body[i].x and head.y == snake.body[i].y then
            love.audio.play(gameOverSound)
            gameState = "gameover"
            return
        end
    end

    table.insert(snake.body, 1, head)

    if head.x == food.x and head.y == food.y then
        love.audio.play(eatSound)
        score = score + 1
        -- Update Best Score jika Score lebih tinggi
    if score > game.bestScore then
        love.audio.play(newBestSound)  -- Play sfx jika score baru tinggi
        game.bestScore = score
    end
        spawnFood()
    else
        table.remove(snake.body)
    end
end

function gameOver()
    if score > bestScore then
        game.bestScore = score
    end
    gameState = "gameover"
end

function game.keypressed(key)
    if gameState == "menu" and key == "return" then
        game.reset()  -- Reset game sebelum mulai baru
        gameState = "playing"
    elseif gameState == "playing" then
        if key == "up" and snake.dir.y == 0 then
            snake.dir = {x = 0, y = -1}
        elseif key == "down" and snake.dir.y == 0 then
            snake.dir = {x = 0, y = 1}
        elseif key == "left" and snake.dir.x == 0 then
            snake.dir = {x = -1, y = 0}
        elseif key == "right" and snake.dir.x == 0 then
            snake.dir = {x = 1, y = 0}
        elseif key == "escape" then
            game.captureScreen()
            gameState = "paused"  -- Masuk ke mode pause
        end
    elseif gameState == "paused" then
        if key == "escape" then
            gameState = "playing"  -- Lanjutkan game
        end
        elseif gameState == "gameover" then
            if key == "return" then
                game.reset()
                gameState = "playing"
            elseif key == "escape" then
                gameState = "menu"
            end
        end
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
    

function game.draw()
    love.graphics.setColor(1, 1, 1)

    -- Gambar Background utama dulu
    love.graphics.draw(bgGame, 0, 0, 0, screenWidth / bgGame:getWidth(), screenHeight / bgGame:getHeight())

    -- Gambar Background arena setelahnya
    if gameState == "playing" then
    love.graphics.draw(bgGrass, arenaX, arenaY, 0, (gridCountX * gridSize) / bgGrass:getWidth(), (gridCountY * gridSize) / bgGrass:getHeight())

    -- Gambar makanan (mouse) dulu sebelum snake
    love.graphics.draw(
        mouse, 
        food.x * gridSize + arenaX,  -- Sesuaikan dengan posisi arena
        food.y * gridSize + arenaY, 
        0, 
        mouseScaleX, mouseScaleY
    )

    -- Gambar ular
    local headX = snake.body[1].x * gridSize + arenaX + gridSize / 2
    local headY = snake.body[1].y * gridSize + arenaY + gridSize / 2

    love.graphics.draw(
        snakeHead, 
        headX, headY, 
        snake.rotation, 
        snakeScaleX, snakeScaleY, 
        snakeHead:getWidth() / 2, snakeHead:getHeight() / 2
    )

    -- Gambar tubuh ular
    for i = 2, #snake.body do
        love.graphics.draw(
            snakeBody, 
            snake.body[i].x * gridSize + arenaX, 
            snake.body[i].y * gridSize + arenaY, 
            0, 
            bodyScaleX, bodyScaleY
        )
    end

    -- **Tampilan Score & Best Score**
    local scoreBoxX = arenaX
    local scoreBoxY = arenaY - 50
    local scoreBoxWidth = gridCountX * gridSize
    local scoreBoxHeight = 40

    -- Kotak score
    love.graphics.setColor(0, 0, 0, 0.6)
    love.graphics.rectangle("fill", scoreBoxX, scoreBoxY, scoreBoxWidth, scoreBoxHeight, 10, 10)

    -- Teks score
    love.graphics.setColor(1, 1, 0)
    love.graphics.setFont(love.graphics.newFont(24))
    love.graphics.printf("Score: " .. score, scoreBoxX, scoreBoxY + 5, scoreBoxWidth / 2, "center")
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Best Score: " .. game.bestScore, scoreBoxX + scoreBoxWidth / 2, scoreBoxY + 5, scoreBoxWidth / 2, "center")
    end
end

return game
