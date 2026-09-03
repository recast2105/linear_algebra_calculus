package Render

import Raylib "vendor:raylib"

// ------------ Focus in everything related to rendering ------------

WORLD_GRID_SIZE :: 62
WORLD_GRID_COLOR :: Raylib.LIGHTGRAY

DrawGrid :: proc(gridSize: int, windowScreenSize: [2]int, colorGrid: Raylib.Color) {

	// Draw vertical lines

	for xAxis := 0; xAxis <= windowScreenSize.x; xAxis += gridSize {
		Raylib.DrawLine(cast(i32)xAxis, 0, cast(i32)xAxis, cast(i32)windowScreenSize.y, colorGrid)
	}

	// Draw horizontal lines

	for yAxis := 0; yAxis <= windowScreenSize.y; yAxis += gridSize {
		Raylib.DrawLine(0, cast(i32)yAxis, cast(i32)windowScreenSize.x, cast(i32)yAxis, colorGrid)
	}
}

// TODO: Maybe refactor latter then points calculation
// * For now it's Okay'is
DrawGraph :: proc() {

	x := cast(f32)400
	y := cast(f32)300
	size := cast(f32)250
	thickness := cast(f32)1.5

	// ------------ Horizontal ------------
	Raylib.DrawLineEx({x, y - size}, {x, y + size}, thickness, Raylib.RED)
	// ------------ Vertical ------------
	Raylib.DrawLineEx({x - size, y}, {x + size, y}, thickness, Raylib.RED)

}
