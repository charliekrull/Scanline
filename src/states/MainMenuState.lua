MainMenuState = Class{__includes = BaseState}

function MainMenuState:init()
  
end

function MainMenuState:enter()
  
end

function MainMenuState:update(dt)
  suit.layout:reset(0, WINDOW_HEIGHT*2/3)
  suit.layout:padding(10)
  local newGameButton = suit.Button('New Game', {font = gFonts.medium}, suit.layout:row(WINDOW_WIDTH, 64))
  if newGameButton.hit then
    gStateMachine:change('displayChar', {chars = ALPHABET})
  end
  
  
end

function MainMenuState:render()
  love.graphics.clear(COLORS.cyan)
  love.graphics.setColor(COLORS.black)
  love.graphics.setFont(gFonts.large)
  love.graphics.printf('Scanline', 0, WINDOW_HEIGHT/4, WINDOW_WIDTH, 'center')
  
end
