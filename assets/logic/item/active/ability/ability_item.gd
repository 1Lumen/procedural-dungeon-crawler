class_name AbilityItem
extends ActiveItem
## Items that can be used on a cooldown that give a temporary benefit or provide utility.


func use(character: Character):
	pass


func load_model(model_name: String) -> PackedScene:
	return Preloads.Models.ability_items[model_name]


func get_stats() -> AbilityItemStats:
	return stats as AbilityItemStats
