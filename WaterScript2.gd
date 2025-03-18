@tool
extends MeshInstance3D

@export_tool_button("update","Callable") var btn = update

@export_tool_button("clear","Callable") var btn2 = clear

@export
var resolution : Vector2i = Vector2i(256,256)

@export
var pressureTexture : Texture

@export
var testTexture : Texture

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
var dissipation : float = 0.2

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

@export
var velocity0 : ViewportShader

func _ready():
	#setup()
	set_process(true)
	for child in get_children():
		remove_child(child)
	
func update():
	setup()

func clear():
	for child in get_children():
		remove_child(child)

func _init() -> void:
	if not Engine.is_editor_hint():
		setup()

func setup():
	for child in get_children():
		remove_child(child)
		
	var mat = get_surface_override_material(0) as StandardMaterial3D
	
	var viewportShaders = []
	#texelSize = Vector2(1.0 / resolution.x,1.0 / resolution.y)
	#dyeTexelSize = texelSize
		
	velocity0 = ViewportShader.new(resolution,load("res://shaders/Splat.gdshader"))
	viewportShaders.append(velocity0)
	
	var dye0 := ViewportShader.new(resolution,load("res://shaders/Splat.gdshader"))
	viewportShaders.append(dye0)
	
	var velocity1 := ViewportShader.new(resolution,load("res://shaders/Blink.gdshader"))
	viewportShaders.append(velocity1)

	var dye1 := ViewportShader.new(resolution,load("res://shaders/Dye.gdshader"))
	viewportShaders.append(dye1)
	
	var uCurl1 := ViewportShader.new(resolution,load("res://shaders/Curl.gdshader"))
	viewportShaders.append(uCurl1)
	
	var velocity2 := ViewportShader.new(resolution,load("res://shaders/VorticityShader.gdshader"))
	viewportShaders.append(velocity2)
	
	var divergence1 := ViewportShader.new(resolution,load("res://shaders/DivergenceShader.gdshader"))
	viewportShaders.append(divergence1)
	
	var pressure1 := ViewportShader.new(resolution,load("res://shaders/ClearShader.gdshader"))
	viewportShaders.append(pressure1)
	
	var pressureFilters = []
	for i in range(0,20):
		var p = ViewportShader.new(resolution,load("res://shaders/PressureShader.gdshader"))
		viewportShaders.append(p)
		pressureFilters.append(p)
	
	var velocity3 := ViewportShader.new(resolution,load("res://shaders/GradientSubtractShader.gdshader"))
	viewportShaders.append(velocity3)
	
	var velocity4 := ViewportShader.new(resolution,load("res://shaders/Advect.gdshader"))
	viewportShaders.append(velocity4)
	
	var dye2 := ViewportShader.new(resolution,load("res://shaders/Advect.gdshader"))
	viewportShaders.append(dye2)
	
	var displayShader := ViewportShader.new(resolution,load("res://shaders/DisplayShader.gdshader"))
	viewportShaders.append(displayShader)
	
	#viewportShaders.reverse()
	for vpShader in viewportShaders:
		add_child(vpShader)
		await RenderingServer.frame_post_draw
		
	velocity0.shader_material.set_shader_parameter("color", Vector3.ZERO)
	velocity0.shader_material.set_shader_parameter("point", Vector3.ZERO)
	velocity0.shader_material.set_shader_parameter("radius",0.0)
	velocity0.shader_material.set_shader_parameter("uTarget",velocity4.viewport.get_texture())
	dye0.shader_material.set_shader_parameter("uTarget",dye2.viewport.get_texture())
	
	velocity1.shader_material.set_shader_parameter("uSource",velocity0.viewport.get_texture())
	
	dye1.shader_material.set_shader_parameter("uSource",dye0.viewport.get_texture())
	
	uCurl1.shader_material.set_shader_parameter("uVelocity",velocity1.viewport.get_texture())
	uCurl1.shader_material.set_shader_parameter("texelSize",texelSize)
	
	velocity2.shader_material.set_shader_parameter("uVelocity",velocity1.viewport.get_texture())
	velocity2.shader_material.set_shader_parameter("texelSize",texelSize)
	velocity2.shader_material.set_shader_parameter("uCurl",uCurl1.viewport.get_texture())
	velocity2.shader_material.set_shader_parameter("curl",curl)
	velocity2.shader_material.set_shader_parameter("dt", dt)
	
	divergence1.shader_material.set_shader_parameter("uVelocity",velocity2.viewport.get_texture())
	divergence1.shader_material.set_shader_parameter("texelSize",texelSize)
	
	pressure1.shader_material.set_shader_parameter("value",pressure)
	
	var pressure2I = pressure1
	for p in pressureFilters:
		p.shader_material.set_shader_parameter("uPressure",pressure2I.viewport.get_texture())
		p.shader_material.set_shader_parameter("uDivergence",divergence1.viewport.get_texture())
		p.shader_material.set_shader_parameter("texelSize",texelSize)
		p.shader_material.set_shader_parameter("dyeTexelSize",dyeTexelSize)
		p.shader_material.set_shader_parameter("dt", dt)
		p.shader_material.set_shader_parameter("dissipation",dissipation)
		pressure2I = p
	
	pressure1.shader_material.set_shader_parameter("uTexture",pressure2I.viewport.get_texture())
	
	velocity3.shader_material.set_shader_parameter("uPressure",pressure2I.viewport.get_texture())
	velocity3.shader_material.set_shader_parameter("uVelocity",velocity2.viewport.get_texture())
	velocity3.shader_material.set_shader_parameter("texelSize", texelSize)
	velocity3.shader_material.set_shader_parameter("dyeTexelSize", dyeTexelSize)
	velocity3.shader_material.set_shader_parameter("dt",0.01)
	velocity3.shader_material.set_shader_parameter("dissipation", dissipation)
	
	velocity4.shader_material.set_shader_parameter("texelSize", texelSize)
	velocity4.shader_material.set_shader_parameter("dyeTexelSize", dyeTexelSize)
	velocity4.shader_material.set_shader_parameter("uVelocity",velocity3.viewport.get_texture())
	velocity4.shader_material.set_shader_parameter("uSource",velocity3.viewport.get_texture())
	velocity4.shader_material.set_shader_parameter("dt",0.01)
	velocity4.shader_material.set_shader_parameter("dissipation", dissipation)
	
	dye2.shader_material.set_shader_parameter("texelSize", texelSize)
	dye2.shader_material.set_shader_parameter("dyeTexelSize", dyeTexelSize)
	dye2.shader_material.set_shader_parameter("uVelocity",velocity4.viewport.get_texture())
	dye2.shader_material.set_shader_parameter("uSource",dye1.viewport.get_texture())
	dye2.shader_material.set_shader_parameter("dt",0.01)
	dye2.shader_material.set_shader_parameter("dissipation", dissipation)
	
	displayShader.shader_material.set_shader_parameter("texelSize", texelSize)
	displayShader.shader_material.set_shader_parameter("uTexture", dye2.viewport.get_texture())
	
	divergence1Texture = divergence1.viewport.get_texture()
	
	velocity1Texture = velocity1.viewport.get_texture()
	velocity2Texture = velocity2.viewport.get_texture()
	velocity3Texture = velocity3.viewport.get_texture()
	velocity4Texture = velocity4.viewport.get_texture()
	pressureTexture = pressure2I.viewport.get_texture()
	
	mat.albedo_texture = displayShader.viewport.get_texture()
	
func _process(delta: float) -> void:
	return 
	var x = cos(Time.get_ticks_msec() / 1000)
	var y = sin(Time.get_ticks_msec() / 1000)
	
	velocity0.shader_material.set_shader_parameter("color", Vector3(10.0*x,10.0*y,0.0))
	velocity0.shader_material.set_shader_parameter("point", Vector3(0.5,0.5,0.0))
	velocity0.shader_material.set_shader_parameter("radius",0.25)
	
		
