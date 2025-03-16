@tool
extends MeshInstance3D

@export_tool_button("update","Callable") var btn = update

@export var test:String = "test"


func _init() -> void:
	update()

func update() -> void:	
	 # Shader laden (Shader muss im Projektordner existieren)
	var shader = load("res://Water.gdshader")  # Passe den Pfad entsprechend an
	var shader_material = ShaderMaterial.new()
	shader_material.shader = shader
	
	var image = Image.create(256, 256, false, Image.FORMAT_RGBA8)	
	image.fill(Color(0, 0, 0, 1))  # Schwarz mit voller Deckkraft	
	for y:float in range(0,255):
		for x:float in range(0,255):	
		#image.set_pixel()
			image.set_pixel(x,y,Color(x/255.0,y/255.0,0.0))
	var texture = ImageTexture.create_from_image(image)
	shader_material.set_shader_parameter("albedo_texture", texture)

	# Parameter setzen
	#shader_material.set_shader_parameter("wave_speed", 1.5)
	#shader_material.set_shader_parameter("base_color", Color(0.2, 0.3, 0.8))
	#shader_material.set_shader_parameter("highlight_color", Color(0.8, 0.3, 0.2))

	# ShaderMaterial an das MeshInstance3D zuweisen
	self.material_override = shader_material
