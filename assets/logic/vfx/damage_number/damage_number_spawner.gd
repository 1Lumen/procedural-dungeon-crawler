@tool
class_name DamageNumberSpawner
extends Node3D

@export_tool_button("Spawn") var spawn_button = spawn_number
@export var damage := 10
@export var continuous := false

@onready var scene = preload("uid://bd43hf53i56p2")


func _ready() -> void:
	spawn_number()


func spawn_number() -> void:
	var number = scene.instantiate() as DamageNumber
	add_child(number)
	number.init(damage)
	if continuous:
		number.tree_exited.connect(spawn_number)
