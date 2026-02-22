class_name Character
extends CharacterBody3D
## Base class for all player characters, enemies, NPCs.
##
## Loads in the model.

## Referece to the stats resource stored in the StatsHolder component.
@export var stats: CharacterStats

@onready var character_animation_tree: CharacterAnimationTree = %CharacterAnimationTree
@onready var primary_attack_range: CylinderShape3D = %PrimaryAttackRange.get_child(0).shape
@onready var secondary_attack_range: CylinderShape3D = %SecondaryAttackRange.get_child(0).shape

var forward: Vector3:
	get():
		return basis * Vector3.FORWARD
## The current character model. This might change when armor is switched.
var model: CharacterModel
## The currently equipped melee (primary) weapon.
var primary_weapon: Weapon
## The currently equipped ranged (secondary) weapon.
var secondary_weapon: Weapon
var armor: Armor
var equipped_weapon: Weapon


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Sets up stats in stats holder component.
	await get_tree().process_frame
	%StatsHolder.stats = stats
	stats = %StatsHolder.stats as CharacterStats
	
	load_model(stats.model_name)
	character_animation_tree.init(model)
	give_starting_gear()


## Equips the character with their starting gear.
func give_starting_gear() -> void:
	if stats.primary_starting_weapon and not primary_weapon:
		equip_weapon(stats.primary_starting_weapon, true)
	if stats.secondary_starting_weapon and not secondary_weapon:
		equip_weapon(stats.secondary_starting_weapon, false)
	if stats.starting_armor and not armor:
		equip_armor(stats.starting_armor)
	character_animation_tree.save_tree()


func equip_weapon(weapon_stats: WeaponStats, primary: bool = true):
	var weapon_scene = Weapon.get_weapon_scene(weapon_stats)
	var weapon = weapon_scene.instantiate() as Weapon
	weapon.stats = weapon_stats
	if primary:
		primary_weapon = weapon
		model.right_hand.add_child(weapon)
		character_animation_tree.set_primary_weapon(weapon_stats)
		primary_attack_range.radius = weapon_stats.range
	else:
		secondary_weapon = weapon
		model.left_hand.add_child(weapon)
		character_animation_tree.set_secondary_weapon(weapon_stats)
		secondary_attack_range.radius = weapon_stats.range
		secondary_weapon.hide()


func equip_armor(armor_stats: ArmorStats):
	var armor_scene = Armor.get_armor_scene(armor_stats)
	armor = armor_scene.instantiate() as Armor
	armor.stats = armor_stats
	# TODO: Add armor model to character skeleton.


func load_model(model_name: String) -> void:
	var model_scene = Preloads.Models.characters.get(model_name)
	assert(model_scene, "No valid model %s found for character %s" % [model_name, stats.name])
	
	if model: # Delete the old model.
		model.queue_free()
	
	model = model_scene.instantiate()
	add_child(model)
