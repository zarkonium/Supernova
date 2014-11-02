local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local myApp = require( "myApp" ) 


function scene:createScene( event )
        local group = self.view
		timer.performWithDelay(100, function() storyboard.gotoScene ( "level" .. myApp.level ) end, 1 )
end


---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

scene:addEventListener( "createScene", scene )

return scene
