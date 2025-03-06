extends TileMap

const MAP_SIZE = 215
const TILE_SIZE = 32
const TILE_DIRT = Vector2i(0, 0)
const TILE_WATER = Vector2i(1, 0)
const TILE_SAND = Vector2i(2, 0)
var noise = FastNoiseLite.new()

func _ready():
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.frequency = 0.01
	noise.seed = randi()
	
	generate_map()

func get_simplex_noise(pos: Vector2):
	return noise.get_noise_2d(pos.x, pos.y)

func generate_map():
	var map_center = Vector2(MAP_SIZE / 2, MAP_SIZE / 2)
	
	for x in range(-(MAP_SIZE / 2), (MAP_SIZE / 2)):
		for y in range(-(MAP_SIZE / 2), (MAP_SIZE / 2)):
			var pos = Vector2(x, y)
			var noise_value = get_simplex_noise(pos)
			
			noise_value -= pos.distance_to(map_center) / 750.0
			
			var tile = TILE_WATER
			if noise_value > -0.4:
				tile = TILE_SAND
			if noise_value > -0.2:
				tile = TILE_DIRT
			set_cell(0, Vector2i(x, y), 1, tile)
