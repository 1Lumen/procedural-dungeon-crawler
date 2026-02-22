extends Node

signal input_mode_changed(mode: Mode)

const SWITCH_COOLDOWN := 1.0

enum Mode { MOUSE, CONTROLLER }

var input_device: Mode
var last_active_device: Mode
var switch_timer: Timer


func _ready() -> void:
	input_device = Mode.MOUSE
	last_active_device = input_device
	create_switch_timer()


func create_switch_timer() -> void:
	switch_timer = Timer.new()
	add_child(switch_timer)
	switch_timer.process_callback = Timer.TIMER_PROCESS_IDLE
	switch_timer.one_shot = true
	switch_timer.autostart = false
	switch_timer.ignore_time_scale = true
	switch_timer.wait_time = SWITCH_COOLDOWN
	switch_timer.timeout.connect(_on_switch_cooldown_timeout)


func _input(event: InputEvent) -> void:
	# Set input mode.
	var input: Mode
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		input = Mode.CONTROLLER
	else:
		input = Mode.MOUSE
	
	if input != last_active_device:
		last_active_device = input
		switch_timer.start()


func _on_switch_cooldown_timeout() -> void:
	input_device = last_active_device
	input_mode_changed.emit(input_device)
