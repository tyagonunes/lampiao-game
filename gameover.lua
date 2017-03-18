
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------


local function gotoGame()
    composer.gotoScene( "game", { time=400, effect="crossFade" } )
end

local function gotoMenu()
    composer.gotoScene( "menu", { time=400, effect="crossFade" } )
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    local score = composer.getVariable( "finalScore" )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
    local background = display.newImageRect( sceneGroup, "img/fundo.jpg", 600, 350 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    local colorBlack = { "gray" }

    local title = display.newText( sceneGroup, "GAME OVER", display.contentCenterX, 90, "customfont.ttf", 30 )
    title:setFillColor(unpack(colorBlack) )

    local score = display.newText( sceneGroup, "SCORE: ".. score, display.contentCenterX, 140, "customfont.ttf", 16 )
    score:setFillColor(unpack(colorBlack) )

    local playButton = display.newText( sceneGroup, "Jogar Novamente", display.contentCenterX, 200, "customfont.ttf", 13 )
    playButton:setFillColor( unpack(colorBlack) )

    local menuButton = display.newText( sceneGroup, "Menu", display.contentCenterX, 230, "customfont.ttf", 13 )
    menuButton:setFillColor(unpack(colorBlack) )


    playButton:addEventListener( "tap", gotoGame )
    menuButton:addEventListener( "tap", gotoMenu )
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
        composer.removeScene( "gameover" )
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
