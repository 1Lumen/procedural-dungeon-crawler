class_name StatsHolder
extends Node

signal stats_changed(stats: Stats)

@export var base_stats: Stats

var stats: Stats:
	set(value):
		stats = value.duplicate_deep()
		stats_changed.emit(stats)


func _ready() -> void:
	# Might need to be changed to duplicate deep in the future if stats using data structures are used.
	if base_stats and not stats:
		stats = base_stats
