--- Load required modules -- 
local storyboard = require ( "storyboard" )
local myApp = require( "myApp" ) 

--hide status bar
display.setStatusBar( display.HiddenStatusBar )

--activate auto scene purging on scene changes
storyboard.purgeOnSceneChange = true

--load settings or create if no past settings exist
myApp.settings = myApp.loadTable("settings.json")
if not myApp.settings then
	myApp.settings = {}
	myApp.settings.maxLevel = 1
	myApp.settings.seenInstructions = false
	myApp.saveTable(myApp.settings, "settings.json")
end

-- go to level select menu
storyboard.gotoScene("menu", {time=250})
