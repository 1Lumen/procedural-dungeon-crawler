class_name Hitbox
extends Area3D
## Makes objects attackable. Emits a signal when attacked containing infos about the hit.

## Emitted after being hit.
signal hit(hit_info: Hit)

## I-frames in seconds.
@export var invulnerability_duration := 0.2
@export var hit_flash_duration := 0.05
@export var canvas_item_to_flash: CanvasItem

#@onready var hit_flash_material = preload("res://assets/materials/hit_flash.tres")

var invulnerable := false


func _init() -> void:
	monitoring = false


## Registers a hit event at this hitbox.
func register_hit(hit_info: Hit):
	if invulnerable:
		return
	hit.emit(hit_info)
	animate_hit()
	
	# Hanlde i-frames.
	invulnerable = true
	await get_tree().create_timer(invulnerability_duration).timeout
	invulnerable = false


func enable():
	monitorable = true


func disable():
	monitorable = false


func animate_hit():
	if not canvas_item_to_flash:
		return
	
	var previous_material
	if canvas_item_to_flash.material:
		previous_material = canvas_item_to_flash.material.duplicate()
	#canvas_item_to_flash.material = hit_flash_material
	
	await get_tree().create_timer(hit_flash_duration).timeout
	
	canvas_item_to_flash.material = previous_material
