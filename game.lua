game = {}

function game.load()
    snakeHead = love.graphics.newImage("assets/snake_head.png")
    snakeBody = love.graphics.newImage("assets/snake_body.png")
    mouse = love.graphics.newImage("assets/mouse.png")

    bgMusic = love.audio.newSource("assets/bg_music.mp3", "stream")
    eatSound = love.audio.newSource("assets/eat.wav", "static")
    gameOverSound = love.audio.newSource("assets/gameover.wav", "static")

    bgMusic:setLooping(true)
    bgMusic:setVolume(0.5)
    love.audio.play(bgMusic)

    gridSize = 20
    gridCount = 30
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

function game.reset()
    snake = { body = { {x = 15, y = 15} }, dir = {x = 1, y = 0} }
    score = 0
    spawnFood()
    timer = 0
    speed = 0.1
end

function spawnFood()
    food = { x = love.math.random(0, gridCount - 1), y = love.math.random(0, gridCount - 1) }
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
    head.x = (head.x + gridCount) % gridCount
    head.y = (head.y + gridCount) % gridCount

    -- Cek tabrakan dengan badan
    for i = 2, #snake.body do
        if head.x == snake.body[i].x and head.y == snake.body[i].y then
            love.audio.play(gameOverSound)
            gameState = "menu"
            return
        end
    end

    table.insert(snake.body, 1, head)

    if head.x == food.x and head.y == food.y then
        love.audio.play(eatSound)
        score = score + 1
        spawnFood()
    else
        table.remove(snake.body)
    end
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
            gameState = "paused"  -- Masuk ke mode pause
        end
    elseif gameState == "paused" then
        if key == "escape" then
            gameState = "playing"  -- Lanjutkan game
        end
    end
end


function game.draw()
    love.graphics.setColor(1, 1, 1)

    -- Tentukan posisi pusat kepala agar rotasi terjadi dari tengah
    local headX = snake.body[1].x * gridSize + gridSize / 2
    local headY = snake.body[1].y * gridSize + gridSize / 2

    love.graphics.draw(snakeHead, headX, headY, snake.rotation, 1, 1, snakeHead:getWidth() / 2, snakeHead:getHeight() / 2)

    -- Gambar tubuh ular
    for i = 2, #snake.body do
        love.graphics.draw(snakeBody, snake.body[i].x * gridSize, snake.body[i].y * gridSize)
    end

    -- Gambar mouse tanpa scaling
    love.graphics.draw(mouse, food.x * gridSize, food.y * gridSize)
end

return game
