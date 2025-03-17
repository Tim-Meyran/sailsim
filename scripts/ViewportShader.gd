class_name ViewportShader extends Node

var viewport: SubViewport
var sprite:Sprite2D
var shader_material: ShaderMaterial

func _init(size:Vector2i,shader:Shader):
	viewport = SubViewport.new()
	viewport.size = size#Vector2(256, 256)
	viewport.transparent_bg = false
	viewport.render_target_clear_mode = SubViewport.CLEAR_MODE_ALWAYS
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	viewport.set_default_canvas_item_texture_filter(Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_LINEAR)	
	viewport.disable_3d = true
	viewport.use_hdr_2d = true
	viewport.fsr_sharpness = 0.0
	viewport.anisotropic_filtering_level = 0
	
	#var vt = viewport.get_texture();
	#var image = Image.create_empty(size.x,size.y,false,Image.FORMAT_RGBAF)
	#var texture = ImageTexture.create_from_image(image)
	#RenderingServer.texture_replace(vt.get_rid(),texture)
	
	add_child(viewport)
	
	#sprite = Sprite2D.new()
	#sprite.centered = false
	#sprite.texture = source_texture
	#sprite.scale = Vector2(1,1)
	#viewport.add_child(sprite)
	
	var quad := ColorRect.new()
	quad.color = Color.BISQUE
	quad.size = size
	viewport.add_child(quad)
	
	shader_material = ShaderMaterial.new()
	shader_material.shader = shader
	
	quad.material = shader_material
	
	
