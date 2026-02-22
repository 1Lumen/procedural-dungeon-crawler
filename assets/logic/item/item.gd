@abstract
class_name Item
extends Node3D

var stats: ItemStats:
	set(resource):
		if resource != stats and resource != null:
			stats = resource
			add_model(load_model(stats.model_name))


@abstract func load_model(model_name: String) -> PackedScene


func add_model(model_scene: PackedScene):
	var model = model_scene.instantiate()
	add_child(model)


@abstract func get_stats()
