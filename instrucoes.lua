
local composer = require( "composer" )
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function gotoGame()
    composer.gotoScene( "game", { time=400, effect="crossFade" } )
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
    local background = display.newImageRect( sceneGroup, "assets/img/fundo_cordel.jpg", 600, 350 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY
   	
   	local titulo = display.newText( sceneGroup, "Instruções", display.contentCenterX, 30, "assets/fonts/xilosa.ttf", 23 )
    titulo:setFillColor( gray )

    local instucao1 = display.newText( sceneGroup, "- Toque nos inimigos que aparecem na tela para eliminá-los.", display.contentCenterX, 70, "assets/fonts/xilosa.ttf", 18 )
    instucao1:setFillColor( gray )

    local instucao2 = display.newText( sceneGroup, "- Não permita mais de 3 inimigos permaneçam na tela ou morrerá.", display.contentCenterX, 100, "assets/fonts/xilosa.ttf", 18 )
    instucao2:setFillColor( gray )

    local instucao3 = display.newText( sceneGroup, "- Quanto mais vitimas você tiver, maior será a fama do seu cangaceiro.", display.contentCenterX, 130, "assets/fonts/xilosa.ttf", 18 )
    instucao3:setFillColor( gray )

    local instucao4 = display.newText( sceneGroup, "- Seu objetivo é ter o maior número de vítimas.", display.contentCenterX, 160, "assets/fonts/xilosa.ttf", 18 )
    instucao4:setFillColor( gray )

     local instucao5 = display.newText( sceneGroup, "- Seu desafio é chegar ao nivel de fama de Lampião.", display.contentCenterX, 190, "assets/fonts/xilosa.ttf", 18 )
    instucao5:setFillColor( gray )

    local playButton = display.newText( sceneGroup, "Vamos lá", display.contentCenterX, 260, "assets/fonts/xilosa.ttf", 23 )
    playButton:setFillColor( gray )

     playButton:addEventListener( "tap", gotoGame )
   
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
		 composer.removeScene( "instrucoes" )

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
