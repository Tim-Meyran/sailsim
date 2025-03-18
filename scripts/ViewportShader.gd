class_name ViewportShader extends Node

var viewport: SubViewport
var sprite:Sprite2D
var shader_material: ShaderMaterial

var refs = {}
var refValues = {}

func setShaderRef(name:String, ref:ViewportShader):
	refs[name] = ref

func setShaderValue(name:String, ref:Variant):
	refValues[name] = ref

func updateReferences():
	for ref in refs:
		shader_material.set_shader_parameter(ref, refs[ref].viewport.get_texture())
	for ref in refValues:
		shader_material.set_shader_parameter(ref, refValues[ref])
		
func _init(size:Vector2i,shader:Shader):
	viewport = SubViewport.new()
	viewport.size = size#Vector2(256, 256)
	viewport.transparent_bg = false
	viewport.render_target_clear_mode = SubViewport.CLEAR_MODE_ALWAYS
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	viewport.set_default_canvas_item_texture_filter(Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_LINEAR)	
	viewport.disable_3d = true
	#viewport.use_hdr_2d = true
	#viewport.fsr_sharpness = 0.0
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
	shader_material.set_shader_parameter("min_val", -500)
	shader_material.set_shader_parameter("max_val", 500)
	shader_material.set_shader_parameter("texelSize",Vector2(1,1))
	shader_material.set_shader_parameter("dyeTexelSize",Vector2(1,1))
	shader_material.set_shader_parameter("dt",0.1)
	
	quad.material = shader_material
	
	
