extends Node3D

@onready
var water = %FluidSimPlane

@onready
var rect = $"../Window/TextureRect"

var velicity = Vector3.ZERO

@onready
var arrow:MeshInstance3D = $ArrowMeshInstance

@onready
var obstacleViewPort :SubViewport = %ObstacleViewPort

func _physics_process(delta: float) -> void:
	var uv = Vector2(water.resolution) * Vector2(0.5 + 0.5 * position.x / 50.0,0.5 + 0.5 * position.z / 50.0)
	
	if water.velocity0 and water.velocity0.viewport:
		#water.image.fill_rect(Rect2i(0,0,water.resolution.x,water.resolution.y),Color(0.5,0.5,0.5,1.0))
		#water.image.fill_rect(Rect2i(uv.x-50,uv.y-50,100,100),Color(0.25,0.75,0.5,1.0))
		
		var vt :ViewportTexture = water.velocity0.viewport.get_texture()
		var waterImage : Image = vt.get_image()
		var col = waterImage.get_pixel(uv.x,uv.y)
		#rect.texture = vt
		if obstacleViewPort:
			rect.texture = obstacleViewPort.get_texture()
		
		velicity.x = - 1.0 + 2.0 * col.r 
		velicity.z = - 1.0 + 2.0 * col.g
		#velicity.x = -velicity.x
		#velicity += -position.normalized()*0.1*delta
		if velicity.length_squared() > 0.01:
			position += 10.0*velicity * delta
		
		if position.x > 45:
			position.x = 45
			velicity.x = -1
		if position.x < -45:
			position.x = -45
			velicity.x = 1
		if position.z > 45:
			position.z = 45
			velicity.z = -1
		if position.z < -45:
			position.z = -45
			velicity.z = 1
		
		print("UV<" + str(uv) + "> Position<" + str(position)+ "> Color<" + str(col) + "> Velicity<" + str(velicity) + ">")
		#print(str(position) + " length_squared:" + str(velicity.length_squared()))
		
		arrow.look_at_from_position(position + velicity * 5.0,position,Vector3.UP)
		#if velicity.length_squared() > 0.1:
		#	sailboat.look_at_from_position(position,position+ velicity,Vector3.UP)
