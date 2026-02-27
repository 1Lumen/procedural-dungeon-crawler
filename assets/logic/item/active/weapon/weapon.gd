@abstract
class_name Weapon
extends ActiveItem
## Base class for all weapons. Loads in the correct model.

signal attack_started
signal attack_finished
signal combo_started
signal combo_finished

enum Type { MELEE, RANGED }
enum Handed { ONE_HANDED, TWO_HANDED, DUALWIELD }
enum Class { SWORD, AXE, DAGGER }

@onready var combo_timer: Timer = %ComboTimer

var combo_index: int = 0:
	set(value):
		if value == 0:
			combo_finished.emit()
		elif value == 1:
			# TODO: Might need to make it more precise instead of on combo index increase.
			combo_started.emit()
		combo_index = max(0, value)
		if value >= get_stats().combo.length:
			combo_index = 0
var collision_layer: int
var collision_mask: int


static func get_weapon_scene(weapon_stats: WeaponStats) -> PackedScene:
	return Preloads.Scenes.weapons[weapon_stats.scene_name]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	stats = (%StatsHolder.stats as WeaponStats)
	
	combo_timer.timeout.connect(reset_combo)
	attack_started.connect(combo_timer.stop)


func init(user: Character) -> void:
	collision_layer = user.collision_layer
	collision_mask = user.collision_mask


@abstract func use(character: Character) -> void


func load_model(model_name: String) -> PackedScene:
	return Preloads.Models.weapons[model_name]


func get_stats() -> WeaponStats:
	return stats as WeaponStats


func reset_combo() -> void:
	print("Combo reset")
	combo_index = 0
