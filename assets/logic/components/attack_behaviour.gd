class_name AttackBehaviour
extends Node

@onready var character: Character = get_parent()
@onready var character_animation_tree: CharacterAnimationTree = %CharacterAnimationTree
@onready var primary_attack_range: Area3D = %PrimaryAttackRange
@onready var secondary_attack_range: Area3D = %SecondaryAttackRange
@onready var enemy_group: StringName = "Enemies" if character.is_in_group("Player") else "Player"

var enemies: Array[Character]


func _ready() -> void:
	primary_attack_range.body_entered.connect(_on_range_entered)
	primary_attack_range.body_entered.connect(_on_range_exited)


func start_primary_attack() -> void:
	#character_animation_tree.start_attacking(true)
	character.primary_weapon.use(character)


func start_secondary_attack() -> void:
	character_animation_tree.start_attacking(false)


func stop_primary_attack() -> void:
	character_animation_tree.stop_attacking()


func stop_secondary_attack() -> void:
	character_animation_tree.stop_attacking()


func _on_range_entered(body: Node3D) -> void:
	if body.is_in_group(enemy_group):
		enemies.append(body as Character)


func _on_range_exited(body: Node3D) -> void:
	if body.is_in_group(enemy_group):
		enemies.erase(body as Character)
