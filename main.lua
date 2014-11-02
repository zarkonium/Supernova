local storyboard = require ( "storyboard" )
local myApp = require( "myApp" ) 

display.setStatusBar( display.HiddenStatusBar )
storyboard.purgeOnSceneChange = true

myApp.settings = myApp.loadTable("settings.json")
if not myApp.settings then
	myApp.settings = {}
	myApp.settings.maxLevel = 1
	myApp.settings.seenInstructions = false
	myApp.saveTable(myApp.settings, "settings.json")
end

function myApp.showScreen1()
    --storyboard.removeAll()
    storyboard.gotoScene("menu", {time=250})
    return true
end

myApp.showScreen1()
