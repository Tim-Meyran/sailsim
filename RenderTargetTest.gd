@tool
extends SubViewport

@onready
var viewport2 = $"../SubViewport2"

@onready
var sprite := $ColorRect

@export_tool_button("update","Callable") var btn = update

#func _init() -> void:
#	get_tree().create_timer(1.0).timeout.connect(update)

func update():
	var render_target = viewport2.get_texture()
	var shader_material: ShaderMaterial = sprite.material
	shader_material.set_shader_parameter("target_texture", render_target)
	
func _process(delta):
	pass
	#shader_material.set_shader_parameter("time", Time.get_ticks_msec() / 1000.0)
