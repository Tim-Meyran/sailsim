extends Node3D

var rd : RenderingDevice
var texture : Texture2D
var framebuffer : RID
var shader : RID
var pipeline : RID
var uniform_set : RID
var vertex_buffer : RID

func _ready():
	rd = RenderingServer.get_rendering_device()
	create_texture()
	create_shader()
	create_pipeline()
	draw_quad()

func create_texture():
	texture = ImageTexture.create_from_image(Image.create(512, 512, false, Image.FORMAT_RGBA8))
	framebuffer = rd.texture_create_from_image(texture.get_image(), RDTextureFormat.new())

func create_shader():
	var shader_file := load("res://shaders/RenderDeviceShader.gdshader")
	var shader_spirv: RDShaderSPIRV = shader_file.get_spirv()
	shader = rd.shader_create_from_spirv(shader_spirv)

func create_pipeline():
	var format = RDAttachmentFormat.new()
	var frameBufferFormat: int = rd.framebuffer_format_create([format], 1)

	var vertexFormat = rd.vertex_format_create([])

	var raster_state = RDPipelineRasterizationState.new()
	var multisample_state = RDPipelineMultisampleState.new()
	var depth_stencil_state = RDPipelineDepthStencilState.new()
	var color_blend_state = RDPipelineColorBlendState.new()

	pipeline = rd.render_pipeline_create(
		shader,
		frameBufferFormat,
		vertexFormat,
		RenderingDevice.RENDER_PRIMITIVE_TRIANGLES,
		raster_state,
		multisample_state,
		depth_stencil_state,
		color_blend_state
	)

func draw_quad():
	rd.framebuffer_set_attachment(framebuffer, 0, framebuffer)
	rd.draw_list_begin(framebuffer)

	rd.draw_list_bind_pipeline(pipeline)
	#rd.draw_list_bind_uniform_set(pipeline, 0, uniform_set)

	rd.draw_list_draw_array(0, 4)  # 4 Eckpunkte für ein Quad
	rd.draw_list_end()

func _process(delta):
	if texture:
		$Sprite3D.texture = texture
