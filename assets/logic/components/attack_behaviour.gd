class_name AttackBehaviour
extends Node

@onready var character: Character = get_parent()
@onready var character_animation_tree: CharacterAnimationTree = %CharacterAnimationTree
@onready var primary_attack_range: Area3D = %PrimaryAttackRange
@onready var secondary_attack_range: Area3D = %SecondaryAttackRange
@onready var enemy_group: StringName = "Enemies" if character.is_in_group("Player") else "Player"

var enemies: Array[Character]
var attacking := false


func _ready() -> void:
	primary_attack_range.body_entered.connect(_on_range_entered)
	primary_attack_range.body_entered.connect(_on_range_exited)


# TODO: Block attack start when already attacking.
func start_attacking(weapon: Weapon) -> void:
	if attacking or weapon.attack_finished.is_connected(weapon.use):
		return
	weapon.attack_finished.connect(weapon.use.bind(character))
	attacking = true
	weapon.use(character)


func stop_attacking(weapon: Weapon) -> void:
	if weapon.attack_finished.is_connected(weapon.use):
		weapon.attack_finished.disconnect(weapon.use)
	await weapon.attack_finished
	attacking = false


func start_primary_attack() -> void:
	start_attacking(character.primary_weapon)


func start_secondary_attack() -> void:
	start_attacking(character.secondary_weapon)


func stop_primary_attack() -> void:
	stop_attacking(character.primary_weapon)


func stop_secondary_attack() -> void:
	stop_attacking(character.secondary_weapon)


func _on_range_entered(body: Node3D) -> void:
	if body.is_in_group(enemy_group):
		enemies.append(body as Character)


func _on_range_exited(body: Node3D) -> void:
	if body.is_in_group(enemy_group):
		enemies.erase(body as Character)
