extends MeshInstance3D

var texture_rid
var shader_rid
var material_rid
var viewport_rid
var quad_rid
var render_target_rid
var texture_size = Vector2i(512, 512)

func __ready():
	create_texture()
	create_render_target()
	create_shader()
	create_quad()

func create_texture():
	# Erstelle eine neue Textur korrekt mit RenderingServer in Godot 4
	var image = Image.create(texture_size.x,texture_size.y,false, Image.FORMAT_RGBA8)
	texture_rid = RenderingServer.texture_2d_create(image) 
	var texture = ImageTexture.create_from_image(RenderingServer.texture_2d_get(texture_rid))
	
	#var material = material_override as StandardMaterial3D
	#material.albedo_texture = texture

func create_render_target():
	viewport_rid = RenderingServer.viewport_create()
	RenderingServer.viewport_set_size(viewport_rid, texture_size.x, texture_size.y)
	#RenderingServer.viewport_set_render
	RenderingServer.viewport_set_update_mode(viewport_rid, RenderingServer.VIEWPORT_UPDATE_ALWAYS)

	render_target_rid = RenderingServer.viewport_get_texture(viewport_rid)
	# Erstelle ein zusätzliches Render-Target als zweite Textur
	var image = Image.create(texture_size.x,texture_size.y,false, Image.FORMAT_RGBA8)
	render_target_rid = RenderingServer.texture_2d_create(image) 
	#var texture = ImageTexture.create_from_image(RenderingServer.texture_2d_get(texture_rid))
	

func create_shader():
	shader_rid = RenderingServer.shader_create()
	var shader_code = """
		shader_type spatial;
		render_mode unshaded;
		uniform sampler2D my_texture;
		void fragment() {
			COLOR = texture(my_texture, UV);
		}
	"""
	RenderingServer.shader_set_code(shader_rid, shader_code)

	material_rid = RenderingServer.material_create()
	RenderingServer.material_set_shader(material_rid, shader_rid)
	RenderingServer.material_set_param(material_rid, "my_texture", render_target_rid)

	# Setze die gerenderte Textur als Albedo-Textur im Material
	var material = get_surface_override_material(0)
	if material:
		material.albedo_texture = ImageTexture.create_from_image(Image.create(texture_size.x, texture_size.y, false, Image.FORMAT_RGBA8))

func create_quad():
	var mesh = ArrayMesh.new()

	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)

	arrays[Mesh.ARRAY_VERTEX] = PackedVector3Array([
		Vector3(-1, -1, 0),
		Vector3(1, -1, 0),
		Vector3(1, 1, 0),
		Vector3(-1, 1, 0)
	])

	arrays[Mesh.ARRAY_TEX_UV] = PackedVector2Array([
		Vector2(0, 1),
		Vector2(1, 1),
		Vector2(1, 0),
		Vector2(0, 0)
	])

	arrays[Mesh.ARRAY_INDEX] = PackedInt32Array([0, 1, 2, 0, 2, 3])

	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	#set_mesh(mesh)
	
	# Parameter setzen
	#RenderingServer.material_set_param(material_rid, "my_texture", texture_rid)

	#RenderingServer.material
	#set_surface_override_material(0, material_rid)

func _process(delta):
	# Erstelle ein neues Bild und fülle es mit Farbwerten (z.B. Farbverlauf)
	var image = Image.create(texture_size.x, texture_size.y, false, Image.FORMAT_RGBA8)
	image.fill(Color(randf(), randf(), randf(), 1.0))
	
	# Aktualisiere die Texturen
	#RenderingServer.texture_2d_update(texture_rid, image,0)
	#RenderingServer.texture_2d_update(render_target_rid, image,0)
