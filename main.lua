

-- Initialize variables
local lives = "X X X"
local score = 0
local died = false

local lampiao
local inimigo
local gameLoopTimer
local livesText
local scoreText

local backGroup = display.newGroup()  -- Display group for the background image
local mainGroup = display.newGroup()  -- Display group for the ship, asteroids, lasers, etc.
local uiGroup = display.newGroup()    -- Display group for UI objects like the score



local background = display.newImageRect( backGroup, "img/fundo3.jpg", 600, 350)
background.x = display.contentCenterX
background.y = display.contentCenterY


lampiao = display.newImageRect( mainGroup, "img/lampiao.png", 90, 129 )
lampiao.x = display.contentCenterX
lampiao.y = display.contentCenterY + 20


inimigo = display.newImageRect( mainGroup, "img/inimigo.png", 90, 100 )
inimigo.x = display.contentCenterX - 240
inimigo.y = display.contentCenterY - 90




-- Esconde a barra de setStatus
display.setStatusBar( display.HiddenStatusBar )


livesText = display.newText( uiGroup, lives, display.contentCenterX, 40, "customfont.ttf", 13 )
scoreText = display.newText( uiGroup, "Score: "..score, display.contentCenterX, 20, "customfont.ttf", 13 )
local colorTable = { "gray" }
livesText:setFillColor( unpack(colorTable) )
scoreText:setFillColor( unpack(colorTable) )
