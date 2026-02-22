@tool
class_name DamageNumber
extends Label3D

@export_group("Spawn")
@export var color = Color.WHITE
@export var crit_color = Color.YELLOW
@export var max_damage_scaling := 100000
@export var min_font_size := 16
@export var max_font_size := 22
@export var size_map: Curve
@export var min_duration := 0.2
@export var max_duration := 2.0
@export var duration_map: Curve
@export_group("Lifetime")
@export var size_curve: Curve
@export var fade_curve: Curve
@export var displacement_curve: Curve
@export var displacement_offset: float

@onready var life_timer: Timer = %LifeTimer
@onready var base_pixel_size := pixel_size


func init(damage: int, critical: bool = false) -> void:
	text = str(damage)
	modulate = color if not critical else crit_color
	font_size = get_number_font_size(damage)
	life_timer.wait_time = get_duration(damage)
	life_timer.timeout.connect(queue_free)
	life_timer.start()


func _process(delta: float) -> void:
	var normalized_time = (life_timer.wait_time - life_timer.time_left) / life_timer.wait_time
	transparency = fade_curve.sample(normalized_time)
	pixel_size = base_pixel_size * size_curve.sample(normalized_time)
	offset.y = displacement_curve.sample(normalized_time) * displacement_offset


func get_number_font_size(damage: int) -> int:
	var x = remap(damage, 0, max_damage_scaling, 0, 1)
	return lerp(min_font_size, max_font_size, size_map.sample(x))


func get_duration(damage: int) -> float:
	var x = remap(damage, 0.0, max_damage_scaling, 0.0, 1.0)
	return lerp(min_duration, max_duration, duration_map.sample(x))
