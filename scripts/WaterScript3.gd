@tool
extends MeshInstance3D

@export_tool_button("update","Callable") var btn = update

@export_tool_button("clear","Callable") var btn2 = clear

@export
var clearValues : bool = true

@export
var image : Image 

@export
var texture : ImageTexture 

@export
var resolution : Vector2i = Vector2i(256,256)

@export
var pressureTexture : Texture

@export
var velocity4Image : Image

@export
var divergence1Texture : Texture

@export
var velocity1Texture : Texture

@export
var velocity2Texture : Texture

@export
var velocity3Texture : Texture

@export
var velocity4Texture : Texture

@export_range(0,4)
var dissipation : float = 0.1

@export_range(0,4)
var dissipationDye : float = 0.2

@export_range(0,50)
var curl : float = 30

@export_range(0,1.0)
var pressure : float = 0.8

@export
var dt : float = 0.1

@export
var texelSize :Vector2  = Vector2(1,1)

@export
var dyeTexelSize :Vector2  = Vector2(1,1)

var velocity0 : ViewportShader
var velocity1 : ViewportShader

var pressure1 : ViewportShader

var dye1 : ViewportShader

var velocity4 : ViewportShader
var dye2 : ViewportShader

var viewportShaders = []

func _ready():
	#setup()
	set_process(true)
	for child in get_children():
		remove_child(child)
	
	if not Engine.is_editor_hint():
		update()
	
func update():
	setup()

func clear():
	for child in get_children():
		remove_child(child)

#func _init() -> void:
#	if not Engine.is_editor_hint():
#		setup()

func setup():
	print("Setup fluid shader")
	for child in get_children():
		remove_child(child)
	
	clearValues = true	
	viewportShaders.clear()
	texelSize = Vector2(1.0 / resolution.x, 1.0 / resolution.y)
	dyeTexelSize = texelSize
	
	dye1 = ViewportShader.new(resolution,load("res://shaders/Splat.gdshader"))
	viewportShaders.append(dye1)

	image = Image.load_from_file("res://Map-Photoroom.png")
	#image = Image.create(resolution.x, resolution.y, false, Image.FORMAT_RGBA8)
	#image.fill(Color(0.5, 0.5, 0.0, 1.0)) # Optional: Transparent ausfüllen
	#image.fill_rect(Rect2i(10,10,resolution.x -20,resolution.y -20),Color(0.5, 0.5, 0.0, 0.0))
	
	#image.fill_rect(Rect2i(200,200,150,150),Color(0.6, 0.6, 0.0, 1.0))
	
	texture = ImageTexture.create_from_image(image)
	await RenderingServer.frame_post_draw
	
	velocity0 = ViewportShader.new(resolution,load("res://shaders/VelocityMaskShader.gdshader"))
	velocity0.setShaderValue("uSource1",texture)
	viewportShaders.append(velocity0)
			
	velocity1 = ViewportShader.new(resolution,load("res://shaders/Splat.gdshader"))
	velocity1.setShaderRef("uTarget",velocity0)
	viewportShaders.append(velocity1)
	
	var uCurl1 := ViewportShader.new(resolution,load("res://shaders/Curl.gdshader"))
	uCurl1.setShaderRef("uVelocity",velocity1)
	viewportShaders.append(uCurl1)
	
	var velocity2 := ViewportShader.new(resolution,load("res://shaders/VorticityShader.gdshader"))
	velocity2.setShaderRef("uVelocity",velocity1)
	velocity2.setShaderRef("uCurl",uCurl1)
	velocity2.setShaderValue("curl",curl)
	viewportShaders.append(velocity2)
	
	var divergence1 := ViewportShader.new(resolution,load("res://shaders/DivergenceShader.gdshader"))
	divergence1.setShaderRef("source_texture",velocity2)
	viewportShaders.append(divergence1)
	
	pressure1 = ViewportShader.new(resolution,load("res://shaders/ClearShader.gdshader"))
	pressure1.setShaderValue("value", pressure)
	viewportShaders.append(pressure1)
		
	var pressure2I = pressure1
	for i in range(0,20): #20
		var p = ViewportShader.new(resolution,load("res://shaders/PressureShader.gdshader"))
		p.setShaderRef("uPressure",pressure2I)
		p.setShaderRef("uDivergence",divergence1)
		viewportShaders.append(p)
		pressure2I = p
	
	pressure1.setShaderRef("uTexture",pressure2I)
	
	var velocity3 := ViewportShader.new(resolution,load("res://shaders/GradientSubtractShader.gdshader"))
	velocity3.setShaderRef("uPressure",pressure2I)
	velocity3.setShaderRef("uVelocity",velocity2)
	viewportShaders.append(velocity3)
	
	velocity4 = ViewportShader.new(resolution,load("res://shaders/Advect.gdshader"))
	velocity4.setShaderRef("uVelocity",velocity3)
	velocity4.setShaderRef("uSource",velocity3)
	viewportShaders.append(velocity4)
	velocity0.setShaderRef("uSource2",velocity4)
	#velocity1.setShaderRef("uTarget",velocity4)

	dye2 = ViewportShader.new(resolution,load("res://shaders/Advect.gdshader"))
	dye2.setShaderRef("uSource",dye1)
	dye2.setShaderRef("uVelocity",velocity4)
	viewportShaders.append(dye2)
	dye1.setShaderRef("uTarget",dye2)
	
	var displayShader := ViewportShader.new(resolution,load("res://shaders/DisplayShader.gdshader"))
	displayShader.setShaderRef("uTexture",dye2)
	viewportShaders.append(displayShader)
	
	#viewportShaders.reverse()
	for vpShader in viewportShaders:
		add_child(vpShader)
	
	await RenderingServer.frame_post_draw
	
	for vpShader in viewportShaders:
		vpShader.updateReferences()
	
	await RenderingServer.frame_post_draw
		
	self.velocity1.shader_material.set_shader_parameter("color", Vector3.ZERO)
	self.velocity1.shader_material.set_shader_parameter("point", Vector3.ZERO)
	self.velocity1.shader_material.set_shader_parameter("radius",0.5)
	self.dye1.shader_material.set_shader_parameter("color", Vector3.ZERO)
	self.dye1.shader_material.set_shader_parameter("point", Vector3.ZERO)
	self.dye1.shader_material.set_shader_parameter("radius",0.5)
	
	var mat = get_surface_override_material(0) as StandardMaterial3D
	#mat.albedo_texture = displayShader.viewport.get_texture()
	mat.albedo_texture = velocity0.viewport.get_texture()
	#mat.heightmap_texture = pressure2I.viewport.get_texture()
	
	print("Setup fluid shader done!")
	await RenderingServer.frame_post_draw
	await get_tree().create_timer(2.0).timeout
	clearValues = false
	
var splatIndex = 0
func _process(delta: float) -> void:
	if not velocity1: return
	
	#clearValues = false
	
	velocity4Image = velocity4.viewport.get_texture().get_image()
	
	var splats = [Vector2(0.25,0.5),Vector2(0.75,0.5)]
	
	var x = cos(2.0*Time.get_ticks_msec() / 1000.0)
	var y = sin(2.0*Time.get_ticks_msec() / 1000.0)
	
	var h:int = Time.get_ticks_msec() / 10
	h = h % 1000
	var color = Color.from_hsv(h/1000.0,1.0,0.1);
	#print(color)
	var pos = splats[splatIndex] # Vector3(-x * 0.05 + 0.5,-y * 0.05 + 0.5,0.0)
	var dir = Vector3(-1,0,0.0) 
	if(splatIndex == 0):
		dir = -dir
		#color = Color(1.0,0.0,0.0)
	else:
		color = Color(0.0,0.0,1.0)
	var radius = 0.5
	
	#pos.x = randf()
	#pos.y = randf()
	
	splatIndex += 1
	if splatIndex >= splats.size(): splatIndex = 0
	
	for vps in self.viewportShaders:
		vps.shader_material.set_shader_parameter("texelSize",texelSize)
		vps.shader_material.set_shader_parameter("dyeTexelSize",dyeTexelSize)
		vps.shader_material.set_shader_parameter("dt",dt)

	velocity4.shader_material.set_shader_parameter("dissipation",dissipation)
	dye2.shader_material.set_shader_parameter("dissipation",dissipationDye)
	
	velocity1.shader_material.set_shader_parameter("color", dir * 00.0)
	velocity1.shader_material.set_shader_parameter("point", pos)
	velocity1.shader_material.set_shader_parameter("radius",radius / 100.0)
	dye1.shader_material.set_shader_parameter("color", Vector3(color.r,color.g,color.b))
	dye1.shader_material.set_shader_parameter("point", pos)
	dye1.shader_material.set_shader_parameter("radius",radius / 100.0)
	
	#image.fill(Color(0.5,0.5,0.5,0.0))
	#image.fill_rect(Rect2i(10,10,resolution.x -20,resolution.y -20),Color(0.5, 0.5, 0.0, 0.0))
	#image.fill_rect(Rect2i(512 ,250,50,50),Color(0.5, 0.8, 0.0, 1.0))
	#image.fill_rect(Rect2i(512 ,750,50,50),Color(0.5, 0.2, 0.0, 1.0))
	
	#image = preload("res://Map-Photoroom.png")
	
	#image.fill_rect(Rect2i(0.5 + 0.5 * x *resolution.x,0.5 + 0.5 * y*resolution.y,50,50),Color(0.7, 0.8, 0.0, 1.0))
	texture.update(image)  
	image.fill_rect(Rect2i(0,00,30,resolution.y),Color(1.0, 0.5, 0.0, 1.0))
	image.fill_rect(Rect2i(resolution.x - 30,00,30,resolution.y),Color(0.0, 0.5, 0.0, 1.0))	
	
	if clearValues : 
		pressure1.shader_material.set_shader_parameter("value",0.0)
		velocity1.shader_material.set_shader_parameter("clear",0.0)
		dye1.shader_material.set_shader_parameter("clear",0.0)
	else : 
		pressure1.shader_material.set_shader_parameter("value",pressure)
		velocity1.shader_material.set_shader_parameter("clear", 1.0)
		dye1.shader_material.set_shader_parameter("clear",1.0)
