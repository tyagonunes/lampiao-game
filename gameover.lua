
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
    audio.stop()  -- Stop all audio
    audio.dispose( music )  -- Release music handle
    composer.gotoScene( "menu", { time=400, effect="crossFade" } )
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    local score = composer.getVariable( "finalScore" )
    local fama = composer.getVariable( "fama" )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
    local background = display.newImageRect( sceneGroup, "img/fundo_cordel.jpg", 600, 350 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY


    local title = display.newText( sceneGroup, "VOCÊ FOI PEGO", display.contentCenterX, 60, "cordel_I.ttf", 30 )
    title:setFillColor( gray )

    local scoreLabel = display.newText( sceneGroup, "Mortos: ".. score, display.contentCenterX, 120, "cordel_I.ttf", 20 )
    scoreLabel:setFillColor( gray )

    local famaTitle = display.newText( sceneGroup, "Legado: ", display.contentCenterX, 160, "cordel_I.ttf", 14 )
    famaTitle:setFillColor( gray )

    local famaLabel = display.newText( sceneGroup, "Cangaceiro "..fama, display.contentCenterX, 190, "cordel_I.ttf", 14 )
    famaLabel:setFillColor( gray )

    local playButton = display.newText( sceneGroup, "Vai de novo", display.contentCenterX - 50, 240, "cordel_I.ttf", 16 )
    playButton:setFillColor( gray )

    local menuButton = display.newText( sceneGroup, "MENU", display.contentCenterX + 70, 240, "cordel_I.ttf", 16 )
    menuButton:setFillColor( gray )

    local iconHouse = display.newText( sceneGroup, "$", 40, 270, "cordel_I.ttf", 90 )
    iconHouse:setFillColor( gray )
    transition.to( iconHouse, { x=80, time=10000, } )

    local iconPlants = display.newText( sceneGroup, "&", display.contentWidth - 40, 270, "cordel_I.ttf", 90 )
    iconPlants:setFillColor( gray )
    transition.to( iconPlants, { x=display.contentWidth, time=10000, } )

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


	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
  composer.removeScene( "gameover" )

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
