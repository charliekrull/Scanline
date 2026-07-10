GameOverState = Class{__includes = BaseState}

function GameOverState:init()
  
end

function GameOverState:enter(params)
  self.score = params.level - 1
end

function GameOverState:update(dt)
  suit.layout:reset(0, WINDOW_HEIGHT/3)
  suit.Label('Game Over', {align = 'center', font = gFonts.large, color = {normal = {fg = COLORS.black}}}, suit.layout:row(WINDOW_WIDTH, 80))
  suit.Label('Final Score: '..tostring(self.score), {align = 'center', font = gFonts.medium, color = {normal = {fg = COLORS.black}}}, suit.layout:row())
end

function GameOverState:render()
  love.graphics.clear(COLORS.grey)
end
