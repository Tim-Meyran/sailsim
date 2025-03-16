@tool 
extends SubViewport

@export_tool_button("clear","Callable") var btn = clear

func clear():
	print("Clear")
	var texture := get_texture()
	var image := texture.get_image()
	image.fill(Color.AQUA)
