package Render

import "core:fmt"
import Raylib "vendor:raylib"

WORLD_GRID_SIZE :: 62
WORLD_GRID_COLOR :: Raylib.LIGHTGRAY

DrawGrid :: proc(gridSize: int, windowScreenSize: [2]int, colorGrid: Raylib.Color) {

	for xAxis := 0; xAxis <= windowScreenSize.x; xAxis += gridSize {
		Raylib.DrawLine(cast(i32)xAxis, 0, cast(i32)xAxis, cast(i32)windowScreenSize.y, colorGrid)
	}

	for yAxis := 0; yAxis <= windowScreenSize.y; yAxis += gridSize {
		Raylib.DrawLine(0, cast(i32)yAxis, cast(i32)windowScreenSize.x, cast(i32)yAxis, colorGrid)
	}
}

// Distância entre cada número (Posição Vetorial)
UNIT_SIZE_DISTANCE :: cast(f32)50

DrawGraph :: proc(center: [2]f32) {
	x := center.x
	y := center.y

	size := cast(f32)250
	thickness := cast(f32)1.5

	// ------------ Y Axis ------------

	Raylib.DrawLineEx({x, y - size}, {x, y + size}, thickness, Raylib.RED)

	// ------------ X Axis ------------

	Raylib.DrawLineEx({x - size, y}, {x + size, y}, thickness, Raylib.RED)

	// ------------ X Axis Numbers ------------

	for number := -5; number <= 5; number += 1 {

		if number == 0 {
			continue
		}

		positionX := x + cast(f32)number * UNIT_SIZE_DISTANCE

		Raylib.DrawText(
			fmt.ctprint(number),
			cast(i32)positionX - 5,
			cast(i32)y + 10,
			20,
			Raylib.BLACK,
		)
	}

	// ------------ Y Axis Numbers ------------

	for number := -5; number <= 5; number += 1 {

		if number == 0 {
			continue
		}

		// Y é invertido na tela
		positionY := y - cast(f32)number * UNIT_SIZE_DISTANCE

		Raylib.DrawText(
			fmt.ctprint(number),
			cast(i32)x + 10,
			cast(i32)positionY - 10,
			20,
			Raylib.BLACK,
		)
	}
}


DrawPoint :: proc(point: [2]f32, center: [2]f32) {
	// ! Limite de tela por equanto
	if (point.x > 5 || point.x < -5 || point.y > 5 || point.y < -5) {
		return
	}

	// Converção
	// Coordenada matemática -> Coordenada da tela
	positionX := center.x + cast(f32)point.x * UNIT_SIZE_DISTANCE
	positionY := center.y - cast(f32)point.y * UNIT_SIZE_DISTANCE

	radius := cast(f32)7

	Raylib.DrawCircle(cast(i32)positionX, cast(i32)positionY, radius, Raylib.GREEN)
}
