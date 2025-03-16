@tool
extends MeshInstance3D

@export_tool_button("update","Callable") var btn = update

@export
var resolution : Vector2i = Vector2i(256,256)

@export
var velocityTexture : Texture

@export
var pressureTexture : Texture

@export
var testTexture : Texture

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

func _ready():
	setup()
	set_process(true)
	
func update():
	setup()

func setup():
	for child in get_children():
		remove_child(child)
		
	var mat = get_surface_override_material(0) as StandardMaterial3D
	
	#texelSize = Vector2(1.0 / resolution.x,1.0 / resolution.y)
	#dyeTexelSize = texelSize
	
	var image = Image.create(resolution.x,resolution.y,false,Image.FORMAT_RGBAF)
	image.fill_rect(Rect2i(50,50,100,100),Color.BLUE)
	velocityTexture = ImageTexture.create_from_image(image)
	
	var velocity1 := ViewportShader.new(resolution,load("res://shaders/Blink.gdshader"))
	add_child(velocity1)
	
	var dye1 := ViewportShader.new(resolution,load("res://shaders/Dye.gdshader"))
	add_child(dye1)
	
	var uCurl1 := ViewportShader.new(resolution,load("res://shaders/Curl.gdshader"))
	add_child(uCurl1)
		
	var velocity2 := ViewportShader.new(resolution,load("res://shaders/VorticityShader.gdshader"))
	add_child(velocity2)
	
	var divergence1 := ViewportShader.new(resolution,load("res://shaders/DivergenceShader.gdshader"))
	add_child(divergence1)

	var pressure1 := ViewportShader.new(resolution,load("res://shaders/ClearShader.gdshader"))
	add_child(pressure1)
	
	var pressure2I = pressure1
	
	for i in range(0,50):
		var p = ViewportShader.new(resolution,load("res://shaders/PressureShader.gdshader"))
		p.shader_material.set_shader_parameter("uPressure",pressure2I.viewport.get_texture())
		p.shader_material.set_shader_parameter("uDivergence",divergence1.viewport.get_texture())
		p.shader_material.set_shader_parameter("texelSize",texelSize)
		p.shader_material.set_shader_parameter("dyeTexelSize",dyeTexelSize)
		p.shader_material.set_shader_parameter("dt", dt)
		p.shader_material.set_shader_parameter("dissipation",dissipation)
		add_child(p)
		pressure2I = p
	
	var velocity3 := ViewportShader.new(resolution,load("res://shaders/GradientSubtractShader.gdshader"))
	add_child(velocity3)
	
	var velocity4 := ViewportShader.new(resolution,load("res://shaders/Advect.gdshader"))
	add_child(velocity4)
	
	var dye2 := ViewportShader.new(resolution,load("res://shaders/Advect.gdshader"))
	add_child(dye2)
	
	var displayShader := ViewportShader.new(resolution,load("res://shaders/DisplayShader.gdshader"))
	add_child(displayShader)
	
	velocity1.shader_material.set_shader_parameter("uSource",velocity4.viewport.get_texture())
	
	dye1.shader_material.set_shader_parameter("uSource",dye2.viewport.get_texture())
	
	uCurl1.shader_material.set_shader_parameter("uVelocity",velocity1.viewport.get_texture())
	uCurl1.shader_material.set_shader_parameter("texelSize",texelSize)
	
	velocity2.shader_material.set_shader_parameter("uVelocity",velocity1.viewport.get_texture())
	velocity2.shader_material.set_shader_parameter("texelSize",texelSize)
	velocity2.shader_material.set_shader_parameter("uCurl",uCurl1.viewport.get_texture())
	velocity2.shader_material.set_shader_parameter("curl",curl)
	velocity2.shader_material.set_shader_parameter("dt", dt)
	
	divergence1.shader_material.set_shader_parameter("uVelocity",velocity2.viewport.get_texture())
	divergence1.shader_material.set_shader_parameter("texelSize",texelSize)
	
	pressure1.shader_material.set_shader_parameter("uTexture",pressure2I.viewport.get_texture())
	pressure1.shader_material.set_shader_parameter("value",pressure)
	
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
	
	velocity1Texture = velocity1.viewport.get_texture()
	velocity2Texture = velocity2.viewport.get_texture()
	velocity3Texture = velocity3.viewport.get_texture()
	velocity4Texture = velocity4.viewport.get_texture()
	pressureTexture = pressure2I.viewport.get_texture()
	
	mat.albedo_texture = displayShader.viewport.get_texture()
