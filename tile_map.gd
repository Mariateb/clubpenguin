extends TileMap

const MAP_SIZE = 215
const TILE_SIZE = 32
const TILE_DIRT = Vector2i(0, 0)
const TILE_WATER = Vector2i(1, 0)

func _ready():
	generate_map()

func generate_map():
	for x in range(MAP_SIZE):
		for y in range(MAP_SIZE):
			var tile = TILE_DIRT if randf() > 0.3 else TILE_WATER
			set_cell(0, Vector2i(x, y), 1, tile)
