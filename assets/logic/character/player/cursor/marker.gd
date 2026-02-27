extends MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.clicked_on_map.connect(func(x): global_position = x)
