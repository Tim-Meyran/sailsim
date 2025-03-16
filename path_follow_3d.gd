extends PathFollow3D

@export var speed: float = 0.05   # Geschwindigkeit der Neigung

func _process(delta: float) -> void:
	pass
	progress += speed * delta
	#if(progress > 1.0):
	#	progress = 0.0
	print(progress)
