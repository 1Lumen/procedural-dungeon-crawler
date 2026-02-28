@tool
class_name NewCharacterStats
extends NewStats


func create_resource() -> Stats:
	var stats = CharacterStats.new()
	
	stats.stats.append(Stat.Builder.new().type(Stat.Type.WALK_SPEED).precision(0).value(0).build())
	stats.stats.append(Stat.Builder.new().type(Stat.Type.RUN_SPEED).precision(0).value(0).build())
	stats.stats.append(Stat.Builder.new().type(Stat.Type.TURN_SPEED).precision(0).value(0).build())
	stats.stats.append(Stat.Builder.new().type(Stat.Type.).precision(0).value(0).build())
	stats.stats.append(Stat.Builder.new().type(Stat.Type.WALK_SPEED).precision(0).value(0).build())
	stats.stats.append(Stat.Builder.new().type(Stat.Type.WALK_SPEED).precision(0).value(0).build())
	stats.stats.append(Stat.Builder.new().type(Stat.Type.WALK_SPEED).precision(0).value(0).build())
	stats.stats.append(Stat.Builder.new().type(Stat.Type.WALK_SPEED).precision(0).value(0).build())
	
	return stats
