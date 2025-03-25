extends RigidBody3D

@onready
var waterShape2D = $WaterShape2D

@onready
var water = %FluidSimPlane

@onready
var pointer = $Pointer

@onready
var camera: Camera3D = $"../../Camera3D"

@onready
var cameraMarker = $CameraMarker

var shader_material:ShaderMaterial

func _ready() -> void:
	pass
	#shader_material = ShaderMaterial.new()
	#shader_material.shader = load("res://shaders/ObjectMaskShader.gdshader")
	#shader_material.set_shader_parameter("velocity", Vector3(0.5,0.5,0.5))
	#waterShape2D.material = shader_material

func map_range(v:float,min1:float,max1:float,min2:float,max2:float) -> float:
	var f = (v - min1) / (max1 - min1) * (max2 - min2) + min2 
	return clamp(f, min2, max2)

func _process(delta: float) -> void:
	#linear_velocity
	#linear_velocity.x = -1.0
	var scalingFactor = 10.0
	
	var dx1 = map_range(linear_velocity.x*scalingFactor ,-500,500,0,1) 
	var dy1 = map_range(linear_velocity.z*scalingFactor ,-500,500,0,1)
	#print(dx1, " ", dy1)
	waterShape2D.position.x = map_range(position.x,-50,50,0,1024)
	waterShape2D.position.y = map_range(position.z,-50,50,0,1024)
	waterShape2D.material.set_shader_parameter("velocity", Vector3(dx1,dy1,0.5))
	
	waterShape2D.rotation = -rotation.y
	
	#TODO add angular velocity to texture
	if not water.velocity0 or not water.velocity0.viewport: return
	
	var vt :ViewportTexture = water.velocity4.viewport.get_texture()
	var waterImage : Image = vt.get_image()
	
	for y in range(-10,10):
		for x in range(-10,10):
			var pos = Vector3(position.x + x / 5.0,0.0,position.z + y / 5.0) 
			var uv = Vector2(map_range(pos.x,-50,50,0,water.resolution.x),map_range(pos.y,-50,50,0,water.resolution.y))
			if pos.x < -50 or pos.x > 50 or pos.y < -50 or pos.y > 50: 
				continue
			
			var col = waterImage.get_pixel(uv.x, uv.y)
			var dx = map_range(col.r,0,1,-500,500)
			var dy = map_range(col.g,0,1,-500,500)
			apply_force(Vector3(dx-linear_velocity.x ,0.0,dy-linear_velocity.z)/mass,  Vector3(x/5.0, 0.0, y/5.0))

	if linear_velocity.length() > 0.01:
		pointer.look_at_from_position(position + linear_velocity.normalized()*2.5,position )

	apply_force(-position)
	
	if position.x < -45:
		position.x = -45
	if position.x > 45:
		position.x = 45
	if position.z < -45:
		position.z = -45
	if position.z > 45:
		position.z = 45		 
		
	if Input.is_action_pressed("ui_up"):
		apply_force(2.0*mass*Vector3.FORWARD * quaternion.inverse(),  Vector3.ZERO)
	if Input.is_action_pressed("ui_down"):
		apply_force(2.0*mass*Vector3.BACK * quaternion.inverse(),  Vector3.ZERO)
	if Input.is_action_pressed("ui_left"):
		apply_torque(mass*Vector3(0,1,0))
	if Input.is_action_pressed("ui_right"):
		apply_torque(mass*Vector3(0,-1,0))
		
	var p = lerp(camera.global_position,cameraMarker.global_position,delta)
	camera.look_at_from_position(p,global_position)
	
