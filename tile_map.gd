extends TileMap

const MAP_SIZE = 512
const TILE_SIZE = 32
const TILE_DIRT = 0
const TILE_WATER = 1
const TILE_SAND = 2

var noise = FastNoiseLite.new()

func _ready():
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.frequency = 0.01
	noise.seed = randi()
	
	generate_map()

func get_simplex_noise(pos: Vector2):
	return noise.get_noise_2d(pos.x, pos.y)
	
func generate_map():
	var map_center = Vector2i(MAP_SIZE / 2, MAP_SIZE / 2)
	
	var listWater: Array[Vector2i] = []
	var listSand: Array[Vector2i] = []
	var listDirt: Array[Vector2i] = []

	for x in range(-MAP_SIZE / 2, MAP_SIZE / 2):
		for y in range(-MAP_SIZE/ 2, MAP_SIZE / 2):
			var pos = Vector2i(x, y)
			var noise_value = get_simplex_noise(Vector2(x, y))

			noise_value -= pos.distance_to(map_center) / 750.0

			if noise_value > -0.2:
				listDirt.append(pos)
			elif noise_value > -0.4:
				listSand.append(pos)
			else:
				listWater.append(pos)
	for value in listDirt:
		set_cell(0, value, 1, Vector2i(TILE_DIRT, 0))
	for value in listWater:
		set_cell(0, value, 1, Vector2i(TILE_WATER, 0))
	for value in listSand:
		set_cell(0, value, 1, Vector2i(TILE_SAND, 0))
	# print("Generated Water Tiles:", listWater.size())
	# print("Generated Sand Tiles:", listSand.size())
	# print("Generated Dirt Tiles:", listDirt.size())
	# if listWater.size() > 0:
	#	set_cells_terrain_path(0, listWater, 0, TILE_WATER)
	# if listDirt.size() > 0:
	# 	set_cells_terrain_path(0, listDirt, 0, TILE_DIRT)
	# if listSand.size() > 0:
	# 	set_cells_terrain_path(0, listSand, 0, TILE_SAND)

	notify_runtime_tile_data_update()
