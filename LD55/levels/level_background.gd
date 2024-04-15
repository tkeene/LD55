extends TextureRect

func _ready():
	material = material.duplicate()

func _process(delta):
	if get_tree().paused or Engine.time_scale == 0.0:
		material.set_shader_parameter("Color", Vector4(0.1,0.3,0.5,1.0))
	else:
		material.set_shader_parameter("Color", Vector4(1.0,1.0,1.0,1.0))
