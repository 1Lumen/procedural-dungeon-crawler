@abstract
class_name Item
extends Node3D

@onready var stats_holder: StatsHolder = %StatsHolder


func _ready() -> void:
	stats_holder.stats_changed.connect(update_model)


@abstract func load_model(model_name: String) -> PackedScene


func update_model(stats: Stats):
	if stats is ItemStats:
		add_model(load_model(stats.model_name))


func add_model(model_scene: PackedScene):
	var model = model_scene.instantiate()
	add_child(model)


## Override to convert to subclass stats type.
## Only use to access subclass' specific stats, not stats from stat system.
@abstract func get_stats()
