@tool
extends SceneTree

const TILE_SIZE := 32
const MAP_W := 80
const MAP_H := 60
const OUT_DIR := "res://assets/tiles/town_exterior"
const TILESET_PATH := "res://resources/tilesets/town_exterior_tileset.tres"
const SCENE_PATH := "res://scenes/world/town_exterior.tscn"
const ATLAS_PATH := "res://assets/tiles/town_exterior/town_exterior_tiles.png"

const T := {
	"grass": Vector2i(0, 0),
	"grass_var": Vector2i(1, 0),
	"stone_road": Vector2i(2, 0),
	"square_paving": Vector2i(3, 0),
	"alley_paving": Vector2i(4, 0),
	"market_paving": Vector2i(5, 0),
	"workshop_ground": Vector2i(6, 0),
	"archive_path": Vector2i(7, 0),
	"gov_courtyard": Vector2i(0, 1),
	"wall": Vector2i(1, 1),
	"roof_red": Vector2i(2, 1),
	"roof_blue": Vector2i(3, 1),
	"roof_gray": Vector2i(4, 1),
	"door": Vector2i(5, 1),
	"window": Vector2i(6, 1),
	"step": Vector2i(7, 1),
	"tree": Vector2i(0, 2),
	"shrub": Vector2i(1, 2),
	"lamp": Vector2i(2, 2),
	"bench": Vector2i(3, 2),
	"notice_board": Vector2i(4, 2),
	"crate": Vector2i(5, 2),
	"barrel": Vector2i(6, 2),
	"market_stall": Vector2i(7, 2),
	"fence": Vector2i(0, 3),
	"roadblock": Vector2i(1, 3),
	"shadow": Vector2i(2, 3),
	"work_pile": Vector2i(3, 3),
	"sign": Vector2i(4, 3),
	"chimney": Vector2i(5, 3),
	"flag": Vector2i(6, 3),
	"edge_veg": Vector2i(7, 3),
}

var tile_set: TileSet
var layers := {}
var collision_parent: Node2D
var tile_atlas_image: Image

func _init() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUT_DIR))
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("res://scenes/world"))
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("res://resources/tilesets"))
	_create_tile_atlas()
	_create_tileset()
	_create_scene()
	print("Generated town exterior scene: %s" % SCENE_PATH)
	quit()

func _create_tile_atlas() -> void:
	var atlas := Image.create(TILE_SIZE * 8, TILE_SIZE * 4, false, Image.FORMAT_RGBA8)
	atlas.fill(Color(0, 0, 0, 0))
	for name in T:
		_draw_tile(atlas, T[name], name)
	tile_atlas_image = atlas
	atlas.save_png(ATLAS_PATH)

func _draw_tile(atlas: Image, coord: Vector2i, name: String) -> void:
	var x0 := coord.x * TILE_SIZE
	var y0 := coord.y * TILE_SIZE
	match name:
		"grass":
			_fill(atlas, x0, y0, Color("#556f4b"))
			_noise(atlas, x0, y0, Color("#6f895d"), 22)
		"grass_var":
			_fill(atlas, x0, y0, Color("#60784e"))
			_noise(atlas, x0, y0, Color("#7b9562"), 35)
		"stone_road":
			_fill(atlas, x0, y0, Color("#817d72"))
			_bricks(atlas, x0, y0, Color("#9b968a"), Color("#666257"))
		"square_paving":
			_fill(atlas, x0, y0, Color("#8d887c"))
			_grid(atlas, x0, y0, 8, Color("#706b62"))
			_noise(atlas, x0, y0, Color("#aaa395"), 8)
		"alley_paving":
			_fill(atlas, x0, y0, Color("#4a4b51"))
			_bricks(atlas, x0, y0, Color("#5a5b62"), Color("#34353c"))
		"market_paving":
			_fill(atlas, x0, y0, Color("#927e67"))
			_grid(atlas, x0, y0, 8, Color("#705f51"))
			_noise(atlas, x0, y0, Color("#b19578"), 10)
		"workshop_ground":
			_fill(atlas, x0, y0, Color("#776c5c"))
			_noise(atlas, x0, y0, Color("#a18461"), 24)
		"archive_path":
			_fill(atlas, x0, y0, Color("#787f7d"))
			_grid(atlas, x0, y0, 8, Color("#626866"))
		"gov_courtyard":
			_fill(atlas, x0, y0, Color("#8b8a84"))
			_grid(atlas, x0, y0, 16, Color("#65645f"))
			_line(atlas, x0, y0 + 15, x0 + 31, y0 + 15, Color("#aaa9a2"))
		"wall":
			_fill(atlas, x0, y0, Color("#9b8f80"))
			_bricks(atlas, x0, y0, Color("#b2a797"), Color("#756c61"))
		"roof_red":
			_fill(atlas, x0, y0, Color("#7b3642"))
			_roof_lines(atlas, x0, y0, Color("#9c4a55"), Color("#4b2029"))
		"roof_blue":
			_fill(atlas, x0, y0, Color("#40566f"))
			_roof_lines(atlas, x0, y0, Color("#58718f"), Color("#283749"))
		"roof_gray":
			_fill(atlas, x0, y0, Color("#696c72"))
			_roof_lines(atlas, x0, y0, Color("#858891"), Color("#45474c"))
		"door":
			_fill(atlas, x0, y0, Color("#8d7a66"))
			_rect(atlas, x0 + 9, y0 + 7, 14, 22, Color("#4b2d24"))
			_rect(atlas, x0 + 20, y0 + 18, 2, 2, Color("#d6a85a"))
		"window":
			_fill(atlas, x0, y0, Color("#8d7a66"))
			_rect(atlas, x0 + 7, y0 + 8, 18, 14, Color("#e7b766"))
			_line(atlas, x0 + 16, y0 + 8, x0 + 16, y0 + 21, Color("#5d473b"))
			_line(atlas, x0 + 7, y0 + 15, x0 + 24, y0 + 15, Color("#5d473b"))
		"step":
			_fill(atlas, x0, y0, Color("#9b958a"))
			_line(atlas, x0, y0 + 10, x0 + 31, y0 + 10, Color("#706b62"))
			_line(atlas, x0, y0 + 20, x0 + 31, y0 + 20, Color("#706b62"))
		"tree":
			_fill(atlas, x0, y0, Color(0, 0, 0, 0))
			_circle(atlas, x0 + 16, y0 + 13, 12, Color("#41643d"))
			_circle(atlas, x0 + 10, y0 + 17, 8, Color("#547b49"))
			_circle(atlas, x0 + 22, y0 + 18, 8, Color("#365534"))
			_rect(atlas, x0 + 13, y0 + 20, 6, 10, Color("#6b4b32"))
		"shrub":
			_fill(atlas, x0, y0, Color(0, 0, 0, 0))
			_circle(atlas, x0 + 11, y0 + 19, 7, Color("#557d4c"))
			_circle(atlas, x0 + 20, y0 + 18, 8, Color("#456b42"))
		"lamp":
			_fill(atlas, x0, y0, Color(0, 0, 0, 0))
			_rect(atlas, x0 + 14, y0 + 8, 4, 20, Color("#3e3430"))
			_rect(atlas, x0 + 10, y0 + 5, 12, 8, Color("#f0c76f"))
			_rect(atlas, x0 + 9, y0 + 27, 14, 3, Color("#3e3430"))
		"bench":
			_fill(atlas, x0, y0, Color(0, 0, 0, 0))
			_rect(atlas, x0 + 5, y0 + 13, 22, 5, Color("#815f42"))
			_rect(atlas, x0 + 6, y0 + 20, 20, 4, Color("#6c4c35"))
			_rect(atlas, x0 + 7, y0 + 24, 3, 5, Color("#3f332c"))
			_rect(atlas, x0 + 22, y0 + 24, 3, 5, Color("#3f332c"))
		"notice_board":
			_fill(atlas, x0, y0, Color(0, 0, 0, 0))
			_rect(atlas, x0 + 5, y0 + 7, 22, 15, Color("#7c5638"))
			_rect(atlas, x0 + 8, y0 + 10, 16, 9, Color("#d8c99d"))
			_rect(atlas, x0 + 9, y0 + 22, 4, 8, Color("#553a28"))
			_rect(atlas, x0 + 20, y0 + 22, 4, 8, Color("#553a28"))
		"crate":
			_fill(atlas, x0, y0, Color(0, 0, 0, 0))
			_rect(atlas, x0 + 6, y0 + 10, 20, 18, Color("#9a6f45"))
			_rect_outline(atlas, x0 + 6, y0 + 10, 20, 18, Color("#5f422c"))
			_line(atlas, x0 + 6, y0 + 10, x0 + 25, y0 + 27, Color("#5f422c"))
		"barrel":
			_fill(atlas, x0, y0, Color(0, 0, 0, 0))
			_rect(atlas, x0 + 10, y0 + 7, 12, 22, Color("#87603e"))
			_rect(atlas, x0 + 8, y0 + 10, 16, 4, Color("#5c4434"))
			_rect(atlas, x0 + 8, y0 + 22, 16, 4, Color("#5c4434"))
		"market_stall":
			_fill(atlas, x0, y0, Color(0, 0, 0, 0))
			_rect(atlas, x0 + 4, y0 + 12, 24, 13, Color("#8d5b3b"))
			_rect(atlas, x0 + 3, y0 + 6, 26, 8, Color("#b74747"))
			_rect(atlas, x0 + 8, y0 + 6, 5, 8, Color("#e1c97a"))
			_rect(atlas, x0 + 18, y0 + 6, 5, 8, Color("#e1c97a"))
		"fence":
			_fill(atlas, x0, y0, Color(0, 0, 0, 0))
			for px in [5, 15, 25]:
				_rect(atlas, x0 + px, y0 + 7, 3, 22, Color("#684d36"))
			_rect(atlas, x0 + 2, y0 + 14, 28, 4, Color("#815f42"))
			_rect(atlas, x0 + 2, y0 + 23, 28, 4, Color("#815f42"))
		"roadblock":
			_fill(atlas, x0, y0, Color(0, 0, 0, 0))
			_rect(atlas, x0 + 3, y0 + 13, 26, 8, Color("#6d5142"))
			_rect(atlas, x0 + 5, y0 + 15, 6, 4, Color("#d1b85d"))
			_rect(atlas, x0 + 17, y0 + 15, 6, 4, Color("#d1b85d"))
		"shadow":
			_fill(atlas, x0, y0, Color("#303138"))
			_noise(atlas, x0, y0, Color("#3c3d45"), 20)
		"work_pile":
			_fill(atlas, x0, y0, Color(0, 0, 0, 0))
			_rect(atlas, x0 + 5, y0 + 17, 22, 9, Color("#8e714e"))
			_rect(atlas, x0 + 8, y0 + 11, 16, 7, Color("#b2865b"))
			_rect_outline(atlas, x0 + 5, y0 + 17, 22, 9, Color("#5b422c"))
		"sign":
			_fill(atlas, x0, y0, Color(0, 0, 0, 0))
			_rect(atlas, x0 + 7, y0 + 7, 18, 10, Color("#a2784f"))
			_rect(atlas, x0 + 15, y0 + 17, 3, 13, Color("#5c3f2a"))
		"chimney":
			_fill(atlas, x0, y0, Color(0, 0, 0, 0))
			_rect(atlas, x0 + 11, y0 + 4, 10, 24, Color("#765044"))
			_rect(atlas, x0 + 9, y0 + 4, 14, 5, Color("#4b3330"))
		"flag":
			_fill(atlas, x0, y0, Color(0, 0, 0, 0))
			_rect(atlas, x0 + 13, y0 + 5, 3, 24, Color("#4b3d38"))
			_rect(atlas, x0 + 16, y0 + 6, 11, 8, Color("#7e4050"))
		"edge_veg":
			_fill(atlas, x0, y0, Color("#374c36"))
			_noise(atlas, x0, y0, Color("#5d764f"), 55)

func _create_tileset() -> void:
	var tex := ImageTexture.create_from_image(tile_atlas_image)
	tile_set = TileSet.new()
	tile_set.tile_size = Vector2i(TILE_SIZE, TILE_SIZE)
	var source := TileSetAtlasSource.new()
	source.texture = tex
	source.texture_region_size = Vector2i(TILE_SIZE, TILE_SIZE)
	for coord in T.values():
		source.create_tile(coord)
	tile_set.add_source(source, 0)
	ResourceSaver.save(tile_set, TILESET_PATH)
	tile_set = ResourceLoader.load(TILESET_PATH) as TileSet

func _create_scene() -> void:
	var root := Node2D.new()
	root.name = "TownExterior"
	root.set_meta("map_size_tiles", Vector2i(MAP_W, MAP_H))
	root.set_meta("tile_size_px", TILE_SIZE)
	root.set_meta("phase_scope", "Phase 1-2 exterior map only: no player, camera, NPCs, interiors, weather, day-night, or entrance triggers.")
	_make_layer(root, "GroundBaseLayer", 0)
	_make_layer(root, "RoadLayer", 1)
	_make_layer(root, "GroundDetailLayer", 2)
	_make_layer(root, "BuildingBaseLayer", 3)
	_make_layer(root, "BuildingRoofLayer", 4)
	_make_layer(root, "PropBackLayer", 5)
	_make_layer(root, "PropFrontLayer", 6)
	_make_layer(root, "BoundaryLayer", 7)
	collision_parent = Node2D.new()
	collision_parent.name = "WorldCollision"
	root.add_child(collision_parent)
	collision_parent.owner = root
	var markers := Node2D.new()
	markers.name = "LocationMarkers"
	root.add_child(markers)
	markers.owner = root
	_fill_base()
	_build_roads_and_square()
	_build_locations()
	_build_boundaries()
	_add_location_markers(markers, root)
	var scene := PackedScene.new()
	scene.pack(root)
	ResourceSaver.save(scene, SCENE_PATH)

func _make_layer(root: Node2D, name: String, z: int) -> void:
	var layer := TileMapLayer.new()
	layer.name = name
	layer.tile_set = tile_set
	layer.z_index = z
	root.add_child(layer)
	layer.owner = root
	layers[name] = layer

func _fill_base() -> void:
	for x in MAP_W:
		for y in MAP_H:
			var coord := T["grass"] if ((x + y) % 7 != 0) else T["grass_var"]
			_paint("GroundBaseLayer", x, y, coord)

func _build_roads_and_square() -> void:
	_rect_tiles("RoadLayer", Rect2i(28, 26, 27, 17), T["square_paving"])
	_rect_tiles("RoadLayer", Rect2i(0, 31, 80, 6), T["stone_road"])
	_rect_tiles("RoadLayer", Rect2i(38, 0, 6, 60), T["stone_road"])
	_rect_tiles("RoadLayer", Rect2i(15, 17, 48, 5), T["stone_road"])
	_rect_tiles("RoadLayer", Rect2i(14, 18, 6, 16), T["stone_road"])
	_rect_tiles("RoadLayer", Rect2i(19, 47, 42, 5), T["stone_road"])
	_rect_tiles("RoadLayer", Rect2i(60, 22, 6, 30), T["stone_road"])
	_rect_tiles("RoadLayer", Rect2i(45, 10, 7, 20), T["alley_paving"])
	_rect_tiles("RoadLayer", Rect2i(53, 10, 23, 15), T["market_paving"])
	_rect_tiles("RoadLayer", Rect2i(8, 10, 17, 11), T["gov_courtyard"])
	_rect_tiles("RoadLayer", Rect2i(9, 45, 17, 8), T["archive_path"])
	_rect_tiles("RoadLayer", Rect2i(55, 44, 21, 10), T["workshop_ground"])
	# Door approach pads
	_rect_tiles("RoadLayer", Rect2i(16, 18, 5, 3), T["step"])
	_rect_tiles("RoadLayer", Rect2i(34, 19, 5, 3), T["step"])
	_rect_tiles("RoadLayer", Rect2i(15, 44, 5, 3), T["step"])
	_rect_tiles("RoadLayer", Rect2i(63, 43, 5, 3), T["step"])

func _build_locations() -> void:
	_building(Rect2i(9, 6, 14, 9), "gov")
	_building(Rect2i(30, 9, 12, 8), "tavern")
	_building(Rect2i(9, 40, 13, 8), "archive")
	_building(Rect2i(58, 39, 14, 8), "workshop")
	# Market shop fronts and stalls
	_building(Rect2i(55, 7, 8, 5), "market_shop")
	_building(Rect2i(67, 8, 7, 5), "market_shop")
	_prop_line("PropFrontLayer", [Vector2i(55, 17), Vector2i(59, 17), Vector2i(68, 18), Vector2i(72, 18)], "market_stall")
	# Alley walls and details
	_rect_tiles("BuildingBaseLayer", Rect2i(43, 8, 2, 21), T["wall"])
	_rect_tiles("BuildingBaseLayer", Rect2i(52, 8, 2, 21), T["wall"])
	_prop_line("PropFrontLayer", [Vector2i(45, 12), Vector2i(51, 15), Vector2i(46, 23), Vector2i(51, 26)], "crate")
	_prop_line("PropFrontLayer", [Vector2i(50, 11), Vector2i(46, 18)], "barrel")
	_rect_tiles("GroundDetailLayer", Rect2i(45, 10, 7, 20), T["shadow"])
	# Square civic marker and seating, sparse.
	_paint("PropFrontLayer", 40, 33, T["notice_board"])
	_paint("PropFrontLayer", 35, 38, T["bench"])
	_paint("PropFrontLayer", 47, 38, T["bench"])
	# Lamps: enough for future night without blocking paths.
	for p in [Vector2i(30, 27), Vector2i(52, 27), Vector2i(30, 42), Vector2i(52, 42), Vector2i(27, 18), Vector2i(50, 18), Vector2i(12, 31), Vector2i(67, 31)]:
		_paint("PropFrontLayer", p.x, p.y, T["lamp"])
	# Sparse trees and shrubs, mostly away from main corridors.
	for p in [Vector2i(4, 7), Vector2i(26, 6), Vector2i(4, 22), Vector2i(25, 45), Vector2i(5, 53), Vector2i(31, 50), Vector2i(75, 34), Vector2i(76, 54), Vector2i(51, 4), Vector2i(77, 7)]:
		_paint("PropBackLayer", p.x, p.y, T["tree"])
	for p in [Vector2i(23, 20), Vector2i(27, 25), Vector2i(54, 26), Vector2i(24, 52), Vector2i(74, 43)]:
		_paint("PropBackLayer", p.x, p.y, T["shrub"])
	# Workshop props.
	for p in [Vector2i(56, 50), Vector2i(72, 49), Vector2i(70, 53)]:
		_paint("PropFrontLayer", p.x, p.y, T["work_pile"])
	_paint("PropFrontLayer", 68, 39, T["chimney"])
	# Government flags.
	_paint("PropFrontLayer", 8, 16, T["flag"])
	_paint("PropFrontLayer", 23, 16, T["flag"])
	# Signs as text-free future label anchors.
	for p in [Vector2i(34, 18), Vector2i(62, 13), Vector2i(15, 49), Vector2i(64, 48)]:
		_paint("PropFrontLayer", p.x, p.y, T["sign"])

func _building(rect: Rect2i, kind: String) -> void:
	var roof := T["roof_gray"]
	if kind == "tavern":
		roof = T["roof_red"]
	elif kind == "archive":
		roof = T["roof_blue"]
	elif kind == "workshop":
		roof = T["roof_gray"]
	elif kind == "market_shop":
		roof = T["roof_red"]
	for x in range(rect.position.x, rect.position.x + rect.size.x):
		for y in range(rect.position.y, rect.position.y + rect.size.y):
			if y < rect.position.y + 3:
				_paint("BuildingRoofLayer", x, y, roof)
			else:
				_paint("BuildingBaseLayer", x, y, T["wall"])
	var door_x := rect.position.x + int(rect.size.x / 2)
	var door_y := rect.position.y + rect.size.y - 1
	_paint("BuildingBaseLayer", door_x, door_y, T["door"])
	if door_x - 3 >= rect.position.x:
		_paint("BuildingBaseLayer", door_x - 3, door_y - 1, T["window"])
	if door_x + 3 < rect.position.x + rect.size.x:
		_paint("BuildingBaseLayer", door_x + 3, door_y - 1, T["window"])
	_add_collision_rect(kind + "_building_collision", rect)

func _build_boundaries() -> void:
	for x in MAP_W:
		_paint("BoundaryLayer", x, 0, T["edge_veg"])
		_paint("BoundaryLayer", x, MAP_H - 1, T["edge_veg"])
	for y in MAP_H:
		_paint("BoundaryLayer", 0, y, T["edge_veg"])
		_paint("BoundaryLayer", MAP_W - 1, y, T["edge_veg"])
	# Block unfinished expansion roads while making them visible.
	for p in [Vector2i(40, 1), Vector2i(78, 33), Vector2i(39, 58)]:
		_paint("BoundaryLayer", p.x, p.y, T["roadblock"])
	# Boundary collision as four long rectangles, leaving no off-map exit.
	_add_collision_rect("north_edge_collision", Rect2i(0, 0, MAP_W, 1))
	_add_collision_rect("south_edge_collision", Rect2i(0, MAP_H - 1, MAP_W, 1))
	_add_collision_rect("west_edge_collision", Rect2i(0, 0, 1, MAP_H))
	_add_collision_rect("east_edge_collision", Rect2i(MAP_W - 1, 0, 1, MAP_H))
	_add_collision_rect("north_expansion_roadblock_collision", Rect2i(39, 0, 3, 2))
	_add_collision_rect("east_expansion_roadblock_collision", Rect2i(77, 31, 3, 5))
	_add_collision_rect("south_expansion_roadblock_collision", Rect2i(38, 57, 4, 3))
	# Prop collisions intentionally sparse and small-ish.
	for p in [Vector2i(4, 7), Vector2i(26, 6), Vector2i(4, 22), Vector2i(25, 45), Vector2i(5, 53), Vector2i(31, 50), Vector2i(75, 34), Vector2i(76, 54), Vector2i(51, 4), Vector2i(77, 7)]:
		_add_collision_rect("tree_collision_%d_%d" % [p.x, p.y], Rect2i(p.x, p.y, 1, 1))
	for p in [Vector2i(55, 17), Vector2i(59, 17), Vector2i(68, 18), Vector2i(72, 18)]:
		_add_collision_rect("market_stall_collision_%d_%d" % [p.x, p.y], Rect2i(p.x, p.y, 1, 1))
	for p in [Vector2i(56, 50), Vector2i(72, 49), Vector2i(70, 53)]:
		_add_collision_rect("work_pile_collision_%d_%d" % [p.x, p.y], Rect2i(p.x, p.y, 1, 1))
	for p in [Vector2i(43, 8), Vector2i(52, 8)]:
		_add_collision_rect("alley_wall_collision_%d_%d" % [p.x, p.y], Rect2i(p.x, p.y, 2, 21))

func _add_location_markers(markers: Node2D, root: Node2D) -> void:
	var data := {
		"GovernmentHallMarker": Vector2(16, 18),
		"TavernMarker": Vector2(36, 19),
		"AlleyMarker": Vector2(48, 18),
		"MarketMarker": Vector2(65, 18),
		"ArchiveMarker": Vector2(16, 49),
		"WorkshopMarker": Vector2(65, 48),
		"SquareMarker": Vector2(40, 34),
		"ExpansionNorthMarker": Vector2(40, 2),
		"ExpansionEastMarker": Vector2(77, 33),
		"ExpansionSouthMarker": Vector2(40, 57),
	}
	for name in data:
		var marker := Marker2D.new()
		marker.name = name
		marker.position = data[name] * TILE_SIZE + Vector2(TILE_SIZE / 2, TILE_SIZE / 2)
		markers.add_child(marker)
		marker.owner = root

func _add_collision_rect(name: String, tile_rect: Rect2i) -> void:
	var body := StaticBody2D.new()
	body.name = name
	body.collision_layer = 2
	body.collision_mask = 0
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(tile_rect.size.x * TILE_SIZE, tile_rect.size.y * TILE_SIZE)
	shape.shape = rect
	shape.position = Vector2(tile_rect.position.x * TILE_SIZE, tile_rect.position.y * TILE_SIZE) + rect.size / 2.0
	body.add_child(shape)
	collision_parent.add_child(body)
	body.owner = collision_parent.get_parent()
	shape.owner = collision_parent.get_parent()

func _paint(layer_name: String, x: int, y: int, tile_coord: Vector2i) -> void:
	if x < 0 or y < 0 or x >= MAP_W or y >= MAP_H:
		return
	layers[layer_name].set_cell(Vector2i(x, y), 0, tile_coord)

func _rect_tiles(layer_name: String, rect: Rect2i, tile_coord: Vector2i) -> void:
	for x in range(rect.position.x, rect.position.x + rect.size.x):
		for y in range(rect.position.y, rect.position.y + rect.size.y):
			_paint(layer_name, x, y, tile_coord)

func _prop_line(layer_name: String, points: Array, tile_name: String) -> void:
	for p in points:
		_paint(layer_name, p.x, p.y, T[tile_name])

func _fill(img: Image, x0: int, y0: int, color: Color) -> void:
	for x in TILE_SIZE:
		for y in TILE_SIZE:
			img.set_pixel(x0 + x, y0 + y, color)

func _rect(img: Image, x: int, y: int, w: int, h: int, color: Color) -> void:
	for ix in range(x, x + w):
		for iy in range(y, y + h):
			if ix >= 0 and iy >= 0 and ix < img.get_width() and iy < img.get_height():
				img.set_pixel(ix, iy, color)

func _rect_outline(img: Image, x: int, y: int, w: int, h: int, color: Color) -> void:
	_line(img, x, y, x + w - 1, y, color)
	_line(img, x, y + h - 1, x + w - 1, y + h - 1, color)
	_line(img, x, y, x, y + h - 1, color)
	_line(img, x + w - 1, y, x + w - 1, y + h - 1, color)

func _line(img: Image, x0: int, y0: int, x1: int, y1: int, color: Color) -> void:
	var dx: int = abs(x1 - x0)
	var sx: int = 1 if x0 < x1 else -1
	var dy: int = -abs(y1 - y0)
	var sy: int = 1 if y0 < y1 else -1
	var err: int = dx + dy
	while true:
		if x0 >= 0 and y0 >= 0 and x0 < img.get_width() and y0 < img.get_height():
			img.set_pixel(x0, y0, color)
		if x0 == x1 and y0 == y1:
			break
		var e2: int = 2 * err
		if e2 >= dy:
			err += dy
			x0 += sx
		if e2 <= dx:
			err += dx
			y0 += sy

func _circle(img: Image, cx: int, cy: int, r: int, color: Color) -> void:
	for x in range(cx - r, cx + r + 1):
		for y in range(cy - r, cy + r + 1):
			if (x - cx) * (x - cx) + (y - cy) * (y - cy) <= r * r:
				if x >= 0 and y >= 0 and x < img.get_width() and y < img.get_height():
					img.set_pixel(x, y, color)

func _grid(img: Image, x0: int, y0: int, step: int, color: Color) -> void:
	for i in range(0, TILE_SIZE, step):
		_line(img, x0 + i, y0, x0 + i, y0 + TILE_SIZE - 1, color)
		_line(img, x0, y0 + i, x0 + TILE_SIZE - 1, y0 + i, color)

func _bricks(img: Image, x0: int, y0: int, light: Color, dark: Color) -> void:
	for y in range(0, TILE_SIZE, 8):
		_line(img, x0, y0 + y, x0 + TILE_SIZE - 1, y0 + y, dark)
		var offset := 0 if int(y / 8) % 2 == 0 else 8
		for x in range(offset, TILE_SIZE, 16):
			_line(img, x0 + x, y0 + y, x0 + x, min(y0 + y + 7, y0 + TILE_SIZE - 1), dark)
	_noise(img, x0, y0, light, 8)

func _roof_lines(img: Image, x0: int, y0: int, light: Color, dark: Color) -> void:
	for y in range(4, TILE_SIZE, 6):
		_line(img, x0, y0 + y, x0 + TILE_SIZE - 1, y0 + y, dark)
	for x in range(2, TILE_SIZE, 8):
		_line(img, x0 + x, y0, x0 + x + 12, y0 + TILE_SIZE - 1, light)

func _noise(img: Image, x0: int, y0: int, color: Color, count: int) -> void:
	for i in count:
		var x := x0 + int((i * 17 + x0 * 3 + y0) % TILE_SIZE)
		var y := y0 + int((i * 11 + y0 * 5 + x0) % TILE_SIZE)
		img.set_pixel(x, y, color)
