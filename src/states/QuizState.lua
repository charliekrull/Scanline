--[[ The state of the game where we ask the player what character they just saw
]]

QuizState = Class{__includes = BaseState}

function QuizState:init()
  
  self.imgScale = 1
  self.rightAnswer = false
  self.wrongAnswer = false
end

function QuizState:enter(params)
  self.options = params.options or {}
  self.charDisplayed = params.charDisplayed
  self.level = params.level or 1
  self.lives = params.lives
  self.replays = params.replays or 3
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
  Timer.update(dt)
  suit.layout:reset(0, 0, 5, 5)
  local question = suit.Label('Which one did you just see?', {font = gFonts.large, color = {normal = {fg = COLORS.white}}}, 0, WINDOW_HEIGHT/6, WINDOW_WIDTH, 100)
  if self.replays > 0 then
    local replayButton = suit.ImageButton(gTextures.replayImg, suit.layout:row(gTextures.replayImg:getWidth(), gTextures.replayImg:getHeight()))
    local replayLabel = suit.Label(tostring(self.replays), {font = gFonts.small, color = {normal = {fg = COLORS.green}}}, gTextures.replayImg:getWidth()-20, gTextures.replayImg:getHeight() - 20)
      
    if replayButton.hit then
      self.replays = self.replays - 1
      gStateMachine:change('displayChar', {options = self.options, character = self.charDisplayed, level = self.level, lives = self.lives, replays = self.replays})  
    end
  end
  suit.layout:reset(25, WINDOW_HEIGHT*0.75, 5, 5)
  love.graphics.setColor(COLORS.white)
  local scoreLabel = suit.Label('Score: '..tostring(self.level - 1), {font = gFonts.medium, color = {normal = {fg = COLORS.white}}}, WINDOW_WIDTH - 300, 20, 280, 100)
  local livesLabel = suit.Label('Lives: '..tostring(self.lives), {font = gFonts.medium, color = {normal = {fg = COLORS.white}}}, WINDOW_WIDTH - 300, 60, 280, 100)
  local buttons = {}
  
  local buttonsPerRow = math.floor((WINDOW_WIDTH - 10)/100)
  

  
  for i = 1, #self.options do
    if i > buttonsPerRow and i % buttonsPerRow == 1 then
      suit.layout:reset(25, WINDOW_HEIGHT * 0.75 + 55 * math.floor(i/buttonsPerRow), 5, 5)
      
      
    end
    
    table.insert(buttons, suit.Button(self.options[i], {font = gFonts.medium}, suit.layout:col(100, 50)))
   
    
    if buttons[i].hit then
      if self.options[i] == self.charDisplayed then
        self.rightAnswer = true
        sfx.correct:play()
        Timer.tween(0.5, {[self] = {imgScale = 50}}):finish(function() gStateMachine:change('displayChar', {lives = self.lives, level = self.level + 1, replays = self.replays}) end)
        
      else
        self.wrongAnswer = true
        sfx.incorrect:play()
        if self.lives <= 0 then
          
          Timer.tween(0.5, {[self] = {imgScale = 50}}):finish(function() gStateMachine:change('gameOver', {level = self.level}) end)
          
        else
          
          Timer.tween(0.5, {[self] = {imgScale = 50}}):finish(function() gStateMachine:change('displayChar', {lives = self.lives - 1, level = self.level}) end)
          
        end
        
        
      end
    end
    
  end
 
  
  
end

function QuizState:exit()
  
end


function QuizState:render()
  love.graphics.clear(COLORS.grey)
  if self.rightAnswer then
    love.graphics.draw(gTextures.greenCheck, WINDOW_WIDTH/2 - (gTextures.greenCheck:getWidth() * self.imgScale/2), WINDOW_HEIGHT/2 - (gTextures.greenCheck:getHeight() * self.imgScale/2), 0, self.imgScale, self.imgScale)
    
  elseif self.wrongAnswer then
    love.graphics.draw(gTextures.redX, WINDOW_WIDTH/2 - (gTextures.redX:getWidth() * self.imgScale/2), WINDOW_HEIGHT/2 - (gTextures.redX:getHeight() * self.imgScale/2), 0, self.imgScale, self.imgScale)
  end
    
end

