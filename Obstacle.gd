extends MeshInstance3D



func _ready() -> void:
	var shader_material = ShaderMaterial.new()
	shader_material.shader = load("res://shaders/ObjectMaskShader.gdshader")
	shader_material.set_shader_parameter("velocity", Vector3(1.0,1.0,0.0))
	material_override = shader_material

func _process(delta: float) -> void:
	
	material_override.set_shader_parameter("velocity", Vector3(1.0,1.0,0.0))
