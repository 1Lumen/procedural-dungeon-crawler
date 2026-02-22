class_name Shield
extends ActiveItem


func use(character: Character):
	pass


func load_model(model_name: String) -> PackedScene:
	return Preloads.Models.shields[model_name]


func get_stats() -> ShieldStats:
	return stats as ShieldStats
