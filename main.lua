--[[Based on a half-remembered flash game I played once
The player has to recognize characters through a moving slit. A letter, number, or other symbol is drawn large on the background and covered by a black rectangle with a thin transparent line/rectangle that moves across the screen so the player can only see part of the character at the time. They are then presented with a few options for what the character was and must choose. The score is the number of correct answers before losing

Charlie Krull
]]

require 'src/dependencies'

function love.load()
  io.stdout:setvbuf("no") --[[ turn off buffering for text so we can see everything we print to console immediately. 
                                turn this to "yes" if performance becomes an issue ]]
  math.randomseed(os.time())
  
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.window.setTitle('Scanline')
  love.keyboard.keysPressed = {}
  love.mouse.clicks = {}
  love.mouse.scroll = {}
  
  gFonts = {small = love.graphics.newFont('fonts/Cantarell-Regular.ttf', 20),
            medium = love.graphics.newFont('fonts/Cantarell-Regular.ttf', 40),
            large = love.graphics.newFont('fonts/Cantarell-Regular.ttf', 80),
            character = love.graphics.newFont('fonts/Cantarell-Regular.ttf', 700)}
          
  sfx = {correct = love.audio.newSource('sounds/correct.wav', 'static'),
          incorrect = love.audio.newSource('sounds/incorrect.mp3', 'static')}
        
  local replayCanvas = love.graphics.newCanvas(100, 100)
  local img = love.graphics.newImage('graphics/replay.png')
  love.graphics.setCanvas(replayCanvas)
  
  love.graphics.setColor(COLORS.green)
  
  love.graphics.draw(img, 0, 0, 0, 100/512, 100/512)
  love.graphics.setCanvas()
  love.graphics.setColor(COLORS.white)
  
  local imageData = replayCanvas:newImageData()
  
 
  gTextures = {replayImg = love.graphics.newImage(imageData),
                greenCheck = love.graphics.newImage('graphics/green_checkmark.png'),
                redX = love.graphics.newImage('graphics/red_cross.png')}
          
  gStateMachine = StateMachine{mainMenu = function() return MainMenuState() end,
                                displayChar = function() return DisplayCharState() end,
                                quiz = function() return QuizState() end,
                                gameOver = function() return GameOverState() end}
  gStateMachine:change('mainMenu')
end

function love.update(dt)
  gStateMachine:update(dt)
  if love.keyboard.wasPressed('escape') then
    
    love.event.quit()
    
  end
  love.keyboard.keysPressed = {}
  love.mouse.clicks = {}
  love.mouse.scroll = {}
end

function love.draw()
  gStateMachine:render()
  suit.draw()
end
