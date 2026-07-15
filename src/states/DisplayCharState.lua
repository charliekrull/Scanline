--[[
  State where the line(s) move(s) across the screen revealing part of the letter.
  This state is entered whenever the player reaches a new level or they hit the replay button.
  It exits automatically when all the tweens are finished, to the state where we quiz the player on what they just saw
  ]]
  DisplayCharState = Class{__includes = BaseState}
  function DisplayCharState:init()
  
  end
  
  function DisplayCharState:enter(params)
    self.chars = params.chars or ALPHABET-- the possible options for the correct character
    self.character = params.character or table.randomChoice(self.chars)
    self.lineX, self.lineY = 0, 0
    self.lives = params.lives or 3
    self.level = params.level or 1
    self.options = params.options or {}
    self.replays = params.replays
    Timer.tween(1, {[self] = {lineY = WINDOW_HEIGHT}}):finish(function() gStateMachine:change('quiz', {charDisplayed = self.character, lives = self.lives, level = self.level, options = self.options, replays = self.replays}) end)
  end
  
  function DisplayCharState:update(dt)
    if love.mouse.clicks[1] then -- if user left-clicks
    self.character = table.randomChoice(self.chars)  
    end
  
    Timer.update(dt)
  end
  
  function DisplayCharState:exit()
    
  end
  
  
  function DisplayCharState:render()
    love.graphics.clear(COLORS.black)
    love.graphics.stencil(function() love.graphics.rectangle('fill', self.lineX, self.lineY, WINDOW_WIDTH, 3) end, 'replace', 1)
    love.graphics.setStencilTest('greater', 0)
    love.graphics.setColor(COLORS.white)
    love.graphics.rectangle('fill', 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
    love.graphics.setColor(COLORS.black)
    love.graphics.setFont(gFonts.character)
    love.graphics.printf(self.character, 0, -150, WINDOW_WIDTH, 'center')
    love.graphics.setStencilTest()
    love.graphics.setColor(COLORS.white)
  end
  