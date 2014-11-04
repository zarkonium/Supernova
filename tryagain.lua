--- Load required modules -- 
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local myApp = require( "myApp" ) 

-- create function to go back to scene which brought you here
-- this is the required process to "completely" reload a scene using the storyboard module.
function scene:createScene( event )
        local group = self.view
		timer.performWithDelay(100, function() storyboard.gotoScene ( "level" .. myApp.level ) end, 1 )
end


---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

scene:addEventListener( "createScene", scene )

return scene
