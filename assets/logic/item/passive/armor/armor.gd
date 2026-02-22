class_name Armor
extends PassiveItem

enum Type { LIGHT, HEAVY } # Not decided what those should be.


static func get_armor_scene(armor_stats: ArmorStats) -> PackedScene:
	return Preloads.Scenes.armor[armor_stats.scene_name]


func load_model(model_name: String) -> PackedScene:
	return Preloads.Models.armor[model_name]


func get_stats() -> ArmorStats:
	return stats as ArmorStats
