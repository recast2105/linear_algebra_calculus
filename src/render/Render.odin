package Render

import "core:fmt"
import Raylib "vendor:raylib"


// =========================================================
// CONFIGURAÇÃO DA GRADE
// =========================================================

WORLD_GRID_SIZE :: 62
WORLD_GRID_COLOR :: Raylib.LIGHTGRAY

// Distância entre cada unidade matemática na tela.
UNIT_SIZE_DISTANCE :: cast(f32)50


// =========================================================
// GRADE VISUAL
// =========================================================

DrawGrid :: proc(
	gridSize: int,
	windowScreenSize: [2]int,
	colorGrid: Raylib.Color,
) {
	for xAxis := 0; xAxis <= windowScreenSize.x; xAxis += gridSize {
		Raylib.DrawLine(
			cast(i32)xAxis,
			0,
			cast(i32)xAxis,
			cast(i32)windowScreenSize.y,
			colorGrid,
		)
	}

	for yAxis := 0; yAxis <= windowScreenSize.y; yAxis += gridSize {
		Raylib.DrawLine(
			0,
			cast(i32)yAxis,
			cast(i32)windowScreenSize.x,
			cast(i32)yAxis,
			colorGrid,
		)
	}
}


// =========================================================
// GRADE MATEMÁTICA
// =========================================================

// Grade alinhada à origem matemática.
//
// center representa a origem:
//
//       +Y
//        |
//        |
// -X ----+---- +X
//        |
//        |
//       -Y
//
DrawCoordinateGrid :: proc(center: [2]f32) {
	size := UNIT_SIZE_DISTANCE * 5

	for unit := -5; unit <= 5; unit += 1 {
		position_x := center.x +
			cast(f32)unit * UNIT_SIZE_DISTANCE

		position_y := center.y -
			cast(f32)unit * UNIT_SIZE_DISTANCE

		// Linha vertical
		Raylib.DrawLine(
			cast(i32)position_x,
			cast(i32)(center.y - size),
			cast(i32)position_x,
			cast(i32)(center.y + size),
			Raylib.LIGHTGRAY,
		)

		// Linha horizontal
		Raylib.DrawLine(
			cast(i32)(center.x - size),
			cast(i32)position_y,
			cast(i32)(center.x + size),
			cast(i32)position_y,
			Raylib.LIGHTGRAY,
		)
	}
}


// =========================================================
// EIXOS E NÚMEROS
// =========================================================

DrawGraph :: proc(center: [2]f32) {
	x := center.x
	y := center.y

	size := cast(f32)250
	thickness := cast(f32)1.5


	// ---------------------------------------------------------
	// EIXO Y
	// ---------------------------------------------------------

	Raylib.DrawLineEx(
		Raylib.Vector2{x, y - size},
		Raylib.Vector2{x, y + size},
		thickness,
		Raylib.RED,
	)


	// ---------------------------------------------------------
	// EIXO X
	// ---------------------------------------------------------

	Raylib.DrawLineEx(
		Raylib.Vector2{x - size, y},
		Raylib.Vector2{x + size, y},
		thickness,
		Raylib.RED,
	)


	// ---------------------------------------------------------
	// NÚMEROS DO EIXO X
	// ---------------------------------------------------------

	for number := -5; number <= 5; number += 1 {
		if number == 0 {
			continue
		}

		position_x := x +
			cast(f32)number * UNIT_SIZE_DISTANCE

		Raylib.DrawText(
			fmt.ctprint(number),
			cast(i32)position_x - 5,
			cast(i32)y + 10,
			20,
			Raylib.BLACK,
		)
	}


	// ---------------------------------------------------------
	// NÚMEROS DO EIXO Y
	// ---------------------------------------------------------

	for number := -5; number <= 5; number += 1 {
		if number == 0 {
			continue
		}

		// O eixo Y da tela é invertido.
		position_y := y -
			cast(f32)number * UNIT_SIZE_DISTANCE

		Raylib.DrawText(
			fmt.ctprint(number),
			cast(i32)x + 10,
			cast(i32)position_y - 10,
			20,
			Raylib.BLACK,
		)
	}
}


// =========================================================
// PONTOS
// =========================================================

DrawPoint :: proc(
	point: [2]f32,
	center: [2]f32,
) {
	DrawColoredPoint(
		point,
		center,
		Raylib.GREEN,
	)
}


DrawColoredPoint :: proc(
	point: [2]f32,
	center: [2]f32,
	color: Raylib.Color,
) {
	// Limite atual do espaço matemático visível.
	if point.x > 5 ||
	   point.x < -5 ||
	   point.y > 5 ||
	   point.y < -5 {
		return
	}

	// Conversão:
	//
	// coordenada matemática
	//          ↓
	// coordenada da tela

	position_x := center.x +
		point.x * UNIT_SIZE_DISTANCE

	position_y := center.y -
		point.y * UNIT_SIZE_DISTANCE

	radius := cast(f32)7

	Raylib.DrawCircle(
		cast(i32)position_x,
		cast(i32)position_y,
		radius,
		color,
	)
}


// =========================================================
// LINHA NO ESPAÇO MATEMÁTICO
// =========================================================

// Desenha um segmento utilizando coordenadas matemáticas.
//
// Exemplo:
//
// start = {-2, 1}
// end   = { 3, 4}
//
// O Render converte essas coordenadas para pixels.
DrawWorldLine :: proc(
	start: [2]f32,
	end: [2]f32,
	center: [2]f32,
	thickness: f32,
	color: Raylib.Color,
) {
	start_screen := Raylib.Vector2{
		center.x + start.x * UNIT_SIZE_DISTANCE,
		center.y - start.y * UNIT_SIZE_DISTANCE,
	}

	end_screen := Raylib.Vector2{
		center.x + end.x * UNIT_SIZE_DISTANCE,
		center.y - end.y * UNIT_SIZE_DISTANCE,
	}

	Raylib.DrawLineEx(
		start_screen,
		end_screen,
		thickness,
		color,
	)
}


// =========================================================
// SLIDER
// =========================================================

// Controle inspirado em calculadoras gráficas.
//
// O valor é alterado arrastando a bolinha.
DrawSlider :: proc(
	label: cstring,
	value: ^f32,
	minimum: f32,
	maximum: f32,
	x: i32,
	y: i32,
	width: i32,
) {
	mouse := Raylib.GetMousePosition()

	track_y := cast(f32)y + 30
	track_x := cast(f32)x
	track_width := cast(f32)width


	// ---------------------------------------------------------
	// INTERAÇÃO
	// ---------------------------------------------------------

	if Raylib.IsMouseButtonDown(.LEFT) &&
	   mouse.x >= track_x - 10 &&
	   mouse.x <= track_x + track_width + 10 &&
	   mouse.y >= track_y - 12 &&
	   mouse.y <= track_y + 12 {

		ratio := (mouse.x - track_x) / track_width

		if ratio < 0 {
			ratio = 0
		}

		if ratio > 1 {
			ratio = 1
		}

		value^ = minimum +
			ratio * (maximum - minimum)
	}


	// ---------------------------------------------------------
	// POSIÇÃO DO KNOB
	// ---------------------------------------------------------

	ratio := (value^ - minimum) /
		(maximum - minimum)

	if ratio < 0 {
		ratio = 0
	}

	if ratio > 1 {
		ratio = 1
	}

	knob_x := track_x +
		ratio * track_width


	// ---------------------------------------------------------
	// TEXTO
	// ---------------------------------------------------------

	Raylib.DrawText(
		fmt.ctprintf(
			"%s = %.1f",
			label,
			value^,
		),
		x,
		y,
		17,
		Raylib.DARKGRAY,
	)


	// Valor mínimo

	Raylib.DrawText(
		fmt.ctprintf(
			"%.2f",
			minimum,
		),
		x,
		cast(i32)track_y + 10,
		12,
		Raylib.DARKGRAY,
	)


	// Valor máximo

	Raylib.DrawText(
		fmt.ctprintf(
			"%.2f",
			maximum,
		),
		x + width - 28,
		cast(i32)track_y + 10,
		12,
		Raylib.DARKGRAY,
	)


	// ---------------------------------------------------------
	// BARRA
	// ---------------------------------------------------------

	Raylib.DrawRectangle(
		x,
		cast(i32)track_y - 3,
		width,
		6,
		Raylib.LIGHTGRAY,
	)


	// Parte preenchida

	Raylib.DrawRectangle(
		x,
		cast(i32)track_y - 3,
		cast(i32)(ratio * track_width),
		6,
		Raylib.SKYBLUE,
	)


	// ---------------------------------------------------------
	// KNOB
	// ---------------------------------------------------------

	Raylib.DrawCircle(
		cast(i32)knob_x,
		cast(i32)track_y,
		9,
		Raylib.DARKBLUE,
	)

	Raylib.DrawCircleLines(
		cast(i32)knob_x,
		cast(i32)track_y,
		9,
		Raylib.RAYWHITE,
	)
}


// =========================================================
// BOTÃO DE MODO
// =========================================================

// Retorna true somente quando o botão é clicado.
//
// O estado "selected" é controlado pelo chamador.
DrawModeButton :: proc(
	label: cstring,
	x: i32,
	y: i32,
	width: i32,
	selected: bool,
) -> bool {
	mouse := Raylib.GetMousePosition()

	hovered :=
		mouse.x >= cast(f32)x &&
		mouse.x <= cast(f32)(x + width) &&
		mouse.y >= cast(f32)y &&
		mouse.y <= cast(f32)(y + 28)


	color := Raylib.LIGHTGRAY
	text_color := Raylib.BLACK


	if selected {
		color = Raylib.DARKBLUE
		text_color = Raylib.RAYWHITE
	} else if hovered {
		color = Raylib.SKYBLUE
	}


	// Corpo do botão

	Raylib.DrawRectangle(
		x,
		y,
		width,
		28,
		color,
	)


	// Borda

	Raylib.DrawRectangleLines(
		x,
		y,
		width,
		28,
		Raylib.DARKGRAY,
	)


	// Texto

	Raylib.DrawText(
		label,
		x + 10,
		y + 6,
		16,
		text_color,
	)


	return hovered &&
		Raylib.IsMouseButtonPressed(.LEFT)
}
