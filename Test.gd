@tool
extends MeshInstance3D

@export_tool_button("update","Callable") var btn = setup

@export
var resolution = Vector2i(256,256)

@export
var velocityTexture : Texture

@export
var testTexture : Texture

func setup():
	for child in get_children():
		remove_child(child)
			
	var image = Image.create(resolution.x,resolution.y,false,Image.FORMAT_RGB8)
	image.fill_rect(Rect2i(50,50,100,100),Color.BLUE)
	velocityTexture = ImageTexture.create_from_image(image)
	
	var viewport = SubViewport.new()
	viewport.size = resolution
	viewport.transparent_bg = true
	viewport.render_target_clear_mode = SubViewport.CLEAR_MODE_ALWAYS
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	add_child(viewport)
	
	var quad := ColorRect.new()
	quad.color = Color.BISQUE
	quad.size = resolution
	viewport.add_child(quad)
	
	var shader_material = ShaderMaterial.new()
	shader_material.shader = load("res://shaders/Curl.gdshader")
	quad.material = shader_material
	
	await RenderingServer.frame_post_draw
		
	var material = get_surface_override_material(0) as StandardMaterial3D
	material.albedo_texture = viewport.get_texture()
	testTexture = viewport.get_texture()
	
	return
