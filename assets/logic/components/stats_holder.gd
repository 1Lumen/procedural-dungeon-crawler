class_name StatsHolder
extends Node

signal stats_changed(stats: Stats)

@export var base_stats: Stats

var stats: Stats:
	set(value):
		stats = value.duplicate_deep()
		stats_changed.emit(stats)
var stat_buffs: Array[StatBuff]


func _ready() -> void:
	if base_stats and not stats:
		stats = base_stats


func apply_buff(buff: StatBuff) -> void:
	stat_buffs.append(buff)
