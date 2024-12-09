extends Control

@onready var state = $"../State"
@onready var container = $GridContainer

func _ready():
	setup_board()

@export var grid_size = 4 # 4x4 grid
@export var tile_size = Vector2(64, 64)
@export var margin = 5.0

var grid = []

func setup_board():
	container.columns = grid_size
	grid.clear()
	
	# Create an empty grid
	for y in range(grid_size):
		var row = []
		for x in range(grid_size):
			var tile = preload("res://Button.tscn").instantiate()
			tile.set_value(0) # Empty tile
			container.add_child(tile)
			row.append(tile)
		grid.append(row)
	
	spawn_tile()
	spawn_tile()

func spawn_tile():
	var empty_tiles = []
	
	# Find empty tiles
	for y in range(grid_size):
		for x in range(grid_size):
			if grid[y][x].value == 0:
				empty_tiles.append(Vector2(x, y))
	
	if empty_tiles.size() > 0:
		var pos = empty_tiles[randi() % empty_tiles.size()]
		grid[pos.y][pos.x].set_value(2 if randf() < 0.9 else 4)

func _input(event):
	if not state.in_2048_game:
		return
	var moved = false
	if event.is_action_pressed("ui_cancel"):
		setup_board()
		state.in_2048_game = false
		self.set_visible(false)
		return
	if event.is_action_pressed("forward"):
		print("W")
		for x in range(grid_size):
			moved = move_column(x, Vector2(0, 1)) or moved
	elif event.is_action_pressed("backward"):
		print("S")
		for x in range(grid_size):
			moved = move_column(x, Vector2(0, -1)) or moved
	elif event.is_action_pressed("left"):
		print("A")
		for y in range(grid_size):
			moved = move_row(y, Vector2(1, 0)) or moved
	elif event.is_action_pressed("right"):
		print("D")
		for y in range(grid_size):
			moved = move_row(y, Vector2(-1, 0)) or moved
	
	if moved:
		spawn_tile()
		for y in range(grid_size):
			for x in range(grid_size):
				if grid[y][x].text == "128":
					state.in_2048_game = false
					self.set_visible(false)
					state.won_2048 = true
					return
				

func move_row(y, direction: Vector2) -> bool:
	var moved = false
	var row = []
	var new_row = []

	# Collect all non-zero tiles in the row
	for x in range(grid_size):
		var current_x = x if direction.x >= 0 else (grid_size - 1 - x)
		if grid[y][current_x].value != 0:
			row.append(grid[y][current_x])

	# Merge tiles in the row
	var skip = false
	for i in range(row.size()):
		if skip:
			skip = false
			continue

		if i < row.size() - 1 and row[i].value == row[i + 1].value:
			var merged_tile = row[i].value * 2
			new_row.append(merged_tile)
			row[i + 1].set_value(0) # Mark the next tile as merged
			skip = true
		else:
			new_row.append(row[i].value)

	# Fill the rest of the row with zeros
	while new_row.size() < grid_size:
		new_row.append(0)

	# Update the row in the grid
	for x in range(grid_size):
		var current_x = x if direction.x >= 0 else (grid_size - 1 - x)
		if grid[y][current_x].value != new_row[x]:
			grid[y][current_x].set_value(new_row[x])
			moved = true

	return moved

func move_column(x, direction: Vector2) -> bool:
	var moved = false
	var column = []
	var new_column = []

	# Collect all non-zero tiles in the column
	for y in range(grid_size):
		var current_y = y if direction.y >= 0 else (grid_size - 1 - y)
		if grid[current_y][x].value != 0:
			column.append(grid[current_y][x])

	# Merge tiles in the column
	var skip = false
	for i in range(column.size()):
		if skip:
			skip = false
			continue

		if i < column.size() - 1 and column[i].value == column[i + 1].value:
			var merged_tile = column[i].value * 2
			new_column.append(merged_tile)
			column[i + 1].set_value(0) # Mark the next tile as merged
			skip = true
		else:
			new_column.append(column[i].value)

	# Fill the rest of the column with zeros
	while new_column.size() < grid_size:
		new_column.append(0)

	# Update the column in the grid
	for y in range(grid_size):
		var current_y = y if direction.y >= 0 else (grid_size - 1 - y)
		if grid[current_y][x].value != new_column[y]:
			grid[current_y][x].set_value(new_column[y])
			moved = true

	return moved
