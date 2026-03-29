@tool
class_name Utils


static func value_to_text(value: float) -> String:
	if is_equal_approx(value, roundf(value)):
		return str(int(value))
	else:
		return str(round_to_dec(value, 1))


static func round_to_dec(value: float, digits: int) -> float:
	return round(value * pow(10.0, digits)) / pow(10.0, digits)
