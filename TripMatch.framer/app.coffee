# Import file "TripMatchMockups" (sizes and positions are scaled 1:3)
sketch1 = Framer.Importer.load("imported/TripMatchMockups@3x")

scaleSize = Screen.width /  1240
Framer.Device.contentScale = scaleSize

AllButtons = [
	{"name": "ArrowNext1"}
]

ArrowNext1 = sketch1.ArrowNext1
ReasonTrip = sketch1.ReasonTrip

window.sketch1 = sketch1



`

function moveall()
{
	``
	for(var propertyName in sketch1) {
		if(sketch1[propertyName].width == Screen.width)
		{
			sketch1[propertyName].x = 0
			sketch1[propertyName].visible = false
			console.log("moving" + propertyName)
		}
	}
}

function switchto(name)
{
	moveall()
	sketch1[name].visible = true
	//sketch1[name].bringToFront()
}
`

# switchto('AirlineName')
# switchto('CityTravelingTo')
# sketch1.CityTravelingTo.opacity = 0
# sketch1.AirlineName.bringToFront()
# sketch1.AirlineName.x = 0


# sketch1.AirlineName.visible = true


# closeButton = new Layer
# 	index: 2
# 	maxX: Screen.width
# 	width: 120
# 	height: 120
# 	image: "images/icons/close.png"
# 	superLayer: sketch1
# 	style: "text-transform":"uppercase"
	

# console.log(sketch1)
# Layer::segue = ->
# 	this.animate
# 		properties:
# 			opacity: 1
# 		curve: 'ease-in-out'
# 		time: 0.1
		
# newsCurve = 'spring(50, 30, 30)'
# newsAnimation = ->
#         ArrowNext1.animate
#             delay: i * 0.1
#             properties:
#                 x: 0
#             curve: newsCurve
		

#changeScence = (scene) ->
	#switch (scene) 
		#when 1
			#ReasonTrip.segue()


# banner= new Layer
# 	width: Screen.width
# 	backgroundColor: "brown"
# 	height: 651
	
# banner2 = new sketch1.AirlineName
# 	width: Screen.width

ArrowNext1.on Events.Tap, -> 
# 	console.log "ben1"
# 	console.log ArrowNext1
# 	sketch1.visible = false
	switchto 'AirlineName'
# 	banner.visible = false
# 	ArrowNext1.animate "shown"
# 	console.log "hello1"



