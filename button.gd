extends Button

var value = 0

func set_value(new_value):
	value = new_value
	if value == 0:
		text = ""
	else:
		text = str(value)
