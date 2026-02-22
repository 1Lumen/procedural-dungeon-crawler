@abstract
class_name Weapon
extends ActiveItem
## Base class for all weapons. Loads in the correct model.

enum Type { MELEE, RANGED }
enum Handed { ONE_HANDED, TWO_HANDED, DUALWIELD }
enum Class { SWORD, AXE, DAGGER }

var combo_index: int = 0


static func get_weapon_scene(weapon_stats: WeaponStats) -> PackedScene:
	return Preloads.Scenes.weapons[weapon_stats.scene_name]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	stats = (%StatsHolder.stats as WeaponStats)


func use(character: Character) -> void:
	attack(character)


@abstract func attack(character: Character) -> void


func load_model(model_name: String) -> PackedScene:
	return Preloads.Models.weapons[model_name]


func get_stats() -> WeaponStats:
	return stats as WeaponStats
