package Render

import Raylib "vendor:raylib"

// ------------ Focus in everything related to rendering ------------

GRID_SIZE :: 62
GRID_COLOR :: Raylib.LIGHTGRAY

DrawGrid :: proc(gridSize: int, windowScreenSize: [2]int) {

	// Draw vertical lines

	for xAxis := 0; xAxis <= windowScreenSize.x; xAxis += gridSize {
		Raylib.DrawLine(cast(i32)xAxis, 0, cast(i32)xAxis, cast(i32)windowScreenSize.y, GRID_COLOR)
	}

	// Draw horizontal lines

	for yAxis := 0; yAxis <= windowScreenSize.y; yAxis += gridSize {
		Raylib.DrawLine(0, cast(i32)yAxis, cast(i32)windowScreenSize.x, cast(i32)yAxis, GRID_COLOR)
	}
}
