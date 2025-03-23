extends TextureRect

@onready
var water = %FluidSimPlane

func _process(dt) -> void:
	if water.velocity0 and water.velocity0.viewport:
		texture = water.velocity0.viewport.get_texture()
