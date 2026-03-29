class_name StatsHolder
extends Node

signal stats_changed(stats: Stats)

@export var base_stats: Stats

var stats: Stats:
	set(value):
		if value:
			stats = value.duplicate_deep()
		stats_changed.emit(stats)
var stat_buffs: Array[StatBuff]


## Initialize the stats by copying the base stats. 
## This is done to keep the base stats of e.g. an enemy type but to allow modifications
## to an instance of that enemy.
func _ready() -> void:
	stats_changed.connect(print.bind("stats changed"))
	if base_stats and not stats:
		stats = base_stats
	stats_changed.emit(stats)


func get_stat(type: Stat.Type) -> float:
	var value = stats.get_stat(type)
	for buff in stat_buffs:
		if buff.stat.type == type:
			value = buff.apply(value, stats.power)
	return value


func apply_buff(buff: StatBuff) -> void:
	stat_buffs.append(buff)


func remove_buff(buff: StatBuff) -> void:
	stat_buffs.erase(buff)
