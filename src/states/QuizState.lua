--[[
The state of the game where we ask the player what character they just saw
]]

QuizState = Class{__includes = BaseState}

function QuizState:init()
  
end

function QuizState:enter(params)
  self.options = params.options or {}
  self.charDisplayed = params.charDisplayed
  self.level = params.level or 1
  self.lives = params.lives
  if #self.options == 0 then 
    table.insert(self.options, self.charDisplayed)
    for i = 1, math.min(#ALPHABET, math.floor((self.level + 5)/3)) do
      local choice = table.randomChoice(ALPHABET)
      while table.contains(self.options, choice) do
        choice = table.randomChoice(ALPHABET)  
      end
      table.insert(self.options, choice)
    end
    shuffle(self.options)
  end
  
end

function QuizState:update(dt)
  suit.layout:reset(0, 0, 5, 5)
  local question = suit.Label('Which one did you just see?', {font = gFonts.large, color = {normal = {fg = COLORS.white}}}, 0, WINDOW_HEIGHT/6, WINDOW_WIDTH, 100)
  local replayButton = suit.ImageButton(gTextures.replayImg, suit.layout:row(gTextures.replayImg:getWidth(), gTextures.replayImg:getHeight()))
  if replayButton.hit then
    gStateMachine:change('displayChar', {chars = {self.charDisplayed}, level = self.level, lives = self.lives})  
  end
  
  suit.layout:reset(25, WINDOW_HEIGHT*0.75, 5, 5)
  love.graphics.setColor(COLORS.white)
  local scoreLabel = suit.Label('Score: '..tostring(self.level - 1), {font = gFonts.medium, color = {normal = {fg = COLORS.white}}}, WINDOW_WIDTH - 200, 20, 180, 100)
  local livesLabel = suit.Label('Lives: '..tostring(self.lives), {font = gFonts.medium, color = {normal = {fg = COLORS.white}}}, WINDOW_WIDTH - 200, 60, 180, 100)
  local buttons = {}
  
  for i = 1, #self.options do
    
    table.insert(buttons, suit.Button(self.options[i], {font = gFonts.medium}, suit.layout:col(100, 50)))
    if buttons[i].hit then
      if self.options[i] == self.charDisplayed then
        gStateMachine:change('displayChar', {lives = self.lives, level = self.level + 1})
        
      else
        if self.lives <= 0 then
          
          gStateMachine:change('gameOver', {level = self.level})
          
        else
          gStateMachine:change('displayChar', {lives = self.lives - 1, level = self.level})
          
        end
        
        
      end
    end
    
  end
 
  
  
end

function QuizState:exit()
  
end


function QuizState:render()
  love.graphics.clear(COLORS.grey)
  
end

