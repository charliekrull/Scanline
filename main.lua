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
          
  local replayCanvas = love.graphics.newCanvas(100, 100)
  love.graphics.setCanvas(replayCanvas)
  love.graphics.clear(COLORS.grey)
  love.graphics.setColor(COLORS.green)
  love.graphics.polygon('fill', 35, 30, 80, 50, 35, 70)--triangle
  love.graphics.arc('line', 'open', 50, 50, 45, math.pi, -math.pi * 0.85)
  love.graphics.setColor(COLORS.yellow)
  love.graphics.line(0, 60, 5, 50, 12, 60)
  love.graphics.setCanvas()
  local imageData = replayCanvas:newImageData()
  
  gTextures = {replayImg = love.graphics.newImage(imageData)}
          
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
