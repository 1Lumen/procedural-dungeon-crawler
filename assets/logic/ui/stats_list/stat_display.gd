@tool
class_name StatDisplay
extends VBoxContainer

@export var stat_type: Stat.Type:
	set(value):
		stat_type = value
		stat_name.text = str(Stat.Type.keys()[stat_type]).replace("_", " ")
@export var min_value := 0.0
@export var max_value := 100.0
@export_group("Test")
@export var value: float
@export var difference: float
@export_tool_button("Set values", "ProgressBar") var set_button = _test_set

@onready var stat_name: Label = %Name
@onready var value_label: Label = %Value
@onready var less_bar: ProgressBar = %LessBar
@onready var more_bar: ProgressBar = %MoreBar
@onready var value_bar: ProgressBar = %ValueBar


func _ready() -> void:
	stat_type = stat_type


## Sets the value of the progress bar.
func set_value(value: float, difference: float) -> void:
	value_label.text = Utils.value_to_text(value)
	if sign(difference) >= 0:
		value_bar.value = value - difference
		more_bar.value = value
		less_bar.value = 0
	else:
		value_bar.value = value + difference
		more_bar.value = 0
		less_bar.value = value


## Sets the ranges of the progress bars.
func set_min_max(min: float, max: float) -> void:
	less_bar.min_value = min
	more_bar.min_value = min
	value_bar.min_value = min
	less_bar.max_value = max
	more_bar.max_value = max
	value_bar.max_value = max


func _test_set():
	set_value(value, difference)
