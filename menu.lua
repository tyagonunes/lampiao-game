
local composer = require( "composer" )
local widget = require( "widget" )
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------



local music = audio.loadStream( "assets/sounds/music_menu.mp3" )

local function gotoInstructions()
    composer.gotoScene( "instrucoes", { time=400, effect="crossFade" } )
end



-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )
    --audio.play( music )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
    local background = display.newImageRect( sceneGroup, "assets/img/fundo_cordel.jpg", 600, 350 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    local iconChapeu = display.newText( sceneGroup, "&", display.contentCenterX, 50, "assets/fonts/xilosa.ttf", 50 )
    iconChapeu:setFillColor( gray )

    local title = display.newText( sceneGroup, "Rei do Cangaço", display.contentCenterX, 120, "assets/fonts/xilosa.ttf", 50 )
    title:setFillColor( gray )

    local playButton = display.newText( sceneGroup, "Jogar", display.contentCenterX, 200, "assets/fonts/xilosa.ttf", 35 )
    playButton:setFillColor( gray )

   


    local iconEnemy = display.newText( sceneGroup, "_", -400, display.contentHeight - 40, "assets/fonts/cordel_I.ttf", 70 )
    iconEnemy:setFillColor( gray )
    transition.to( iconEnemy, { x=display.contentWidth + 150, time=150000, } )

    local iconLampiao = display.newText( sceneGroup, "!", -200, display.contentHeight - 40, "assets/fonts/cordel_I.ttf", 70 )
    iconLampiao:setFillColor( gray )
    transition.to( iconLampiao, { x=display.contentWidth + 150, time=100000, } )

    local iconHouse = display.newText( sceneGroup, "$", 40, display.contentHeight - 40, "assets/fonts/cordel_I.ttf", 70 )
    iconHouse:setFillColor( gray )
    transition.to( iconHouse, { x=display.contentWidth + 150, time=80000, } )

    local iconPlants = display.newText( sceneGroup, "&", display.contentWidth - 40, display.contentHeight - 40, "assets/fonts/cordel_I.ttf", 70 )
    iconPlants:setFillColor( gray )
    transition.to( iconPlants, { x=display.contentWidth + 150, time=40000, } )

    playButton:addEventListener( "touch", gotoInstructions )
   
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
    timer.performWithDelay( 5, function()
				audio.play( music, { loops = -1, channel = 2 } )
				audio.fade({ channel = 1, time = 333, volume = 1.0 } )
			end)

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
        composer.removeScene( "menu" )

    elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

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
