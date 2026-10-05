package Main

import "core:fmt"
import "core:math"

import Raylib "vendor:raylib"

import Engine "src/engine"
import Math "src/math"
import Render "src/render"
import Window "src/window"

// =========================================================
// ENGINE
// =========================================================

CoreEngine := Engine.CoreProcedure {
	Start  = Start,
	Update = Update,
}

// =========================================================
// WINDOW
// =========================================================

CoreWindow := Window.Initialization {
	width  = 1000,
	heigth = 700,
	title  = "Explorador de Funcoes",
}

// =========================================================
// CONSTANTES
// =========================================================

LAUNCH_X :: cast(f32)-4
TRAJECTORY_SEGMENTS :: 96

// =========================================================
// TIPOS DE GRÁFICO
// =========================================================

Graph_Kind :: enum {
	QUADRATIC,
	LINEAR,
	CUBIC,
	LOGARITHMIC,
	LIMIT,
}

// =========================================================
// MAIN
// =========================================================

main :: proc() {
	CoreEngine.Start()
	CoreEngine.Update(Raylib.GetFrameTime())
}

// =========================================================
// START
// =========================================================

Start :: proc() {
	Raylib.InitWindow(
		CoreWindow.width,
		CoreWindow.heigth,
		CoreWindow.title,
	)

	Raylib.SetTargetFPS(Engine.TARGET_FPS)
}

// =========================================================
// FUNÇÃO USADA PARA DEMONSTRAR LIMITE
//
// f(x) = 1 / (x - 1)
//
// Em x = 1 existe uma assíntota vertical.
// =========================================================

Limit_Function :: proc(x: f32) -> f32 {
	if math.abs(x - 1) < 0.00001 {
		return 0
	}

	return 1 / (x - 1)
}

// =========================================================
// UPDATE
// =========================================================

Update :: proc(delta: f32) {
	defer Raylib.CloseWindow()

	// -----------------------------------------------------
	// PROJÉTIL
	// -----------------------------------------------------

	initial_height := f32(0)
	initial_vertical_velocity := f32(8)
	horizontal_velocity := f32(3)

	// -----------------------------------------------------
	// LINEAR
	// -----------------------------------------------------

	linear_a := f32(1)
	linear_b := f32(0)

	// -----------------------------------------------------
	// CÚBICA
	// -----------------------------------------------------

	cubic_a := f32(0.01)
	cubic_b := f32(-0.04)
	cubic_c := f32(0.3)
	cubic_d := f32(0)

	// -----------------------------------------------------
	// LOGARITMO
	// -----------------------------------------------------

	log_base := f32(2)

	// -----------------------------------------------------
	// LIMITE
	// -----------------------------------------------------

	limit_point := f32(2)

	// -----------------------------------------------------
	// GRÁFICO SELECIONADO
	// -----------------------------------------------------

	selected_graph := Graph_Kind.QUADRATIC

	// -----------------------------------------------------
	// TEMPO LOCAL DA APLICAÇÃO
	// -----------------------------------------------------

	application_time := f32(0)

	for !Raylib.WindowShouldClose() {

		application_time += delta

		// =================================================
		// DESENHO
		// =================================================

		Raylib.BeginDrawing()

		Raylib.ClearBackground(
			Raylib.Color {248, 250, 252, 255},
		)

		// =================================================
		// HEADER
		// =================================================

		Raylib.DrawRectangle(
			0,
			0,
			CoreWindow.width,
			72,
			Raylib.DARKBLUE,
		)

		Raylib.DrawText(
			"Explorador de Funcoes",
			24,
			17,
			28,
			Raylib.RAYWHITE,
		)

		Raylib.DrawText(
			"funcoes e conceitos matematicos",
			26,
			47,
			15,
			Raylib.SKYBLUE,
		)

		// =================================================
		// PLANO CARTESIANO
		// =================================================

		center := [2]f32 {650, 390}

		Render.DrawCoordinateGrid(center)
		Render.DrawGraph(center)

		Raylib.DrawText(
			"y",
			640,
			104,
			18,
			Raylib.RED,
		)

		Raylib.DrawText(
			"x",
			914,
			370,
			18,
			Raylib.RED,
		)

		// =================================================
		// PAINEL
		// =================================================

		Raylib.DrawRectangle(
			18,
			92,
			300,
			500,
			Raylib.RAYWHITE,
		)

		Raylib.DrawRectangleLines(
			18,
			92,
			300,
			500,
			Raylib.LIGHTGRAY,
		)

		Raylib.DrawText(
			"FUNCAO ATIVA",
			34,
			108,
			14,
			Raylib.DARKGRAY,
		)

		// =================================================
		// BOTÕES - LINHA 1
		// =================================================

		if Render.DrawModeButton(
			"Quadratica",
			34,
			132,
			96,
			selected_graph == .QUADRATIC,
		) {
			selected_graph = .QUADRATIC
		}

		if Render.DrawModeButton(
			"Linear",
			136,
			132,
			76,
			selected_graph == .LINEAR,
		) {
			selected_graph = .LINEAR
		}

		if Render.DrawModeButton(
			"Cubica",
			218,
			132,
			80,
			selected_graph == .CUBIC,
		) {
			selected_graph = .CUBIC
		}

		// =================================================
		// BOTÕES - LINHA 2
		// =================================================

		if Render.DrawModeButton(
			"Log",
			34,
			166,
			76,
			selected_graph == .LOGARITHMIC,
		) {
			selected_graph = .LOGARITHMIC
		}

		if Render.DrawModeButton(
			"Limite",
			118,
			166,
			80,
			selected_graph == .LIMIT,
		) {
			selected_graph = .LIMIT
		}

		// =================================================
		// QUADRÁTICA
		// =================================================

		if selected_graph == .QUADRATIC {

			Raylib.DrawText(
				"Lancamento de projetil",
				34,
				210,
				18,
				Raylib.DARKBLUE,
			)

			Raylib.DrawText(
				"A altura forma uma parabola",
				34,
				232,
				14,
				Raylib.DARKGRAY,
			)

			Render.DrawSlider(
				"v0y (m/s)",
				&initial_vertical_velocity,
				3,
				8,
				34,
				260,
				264,
			)

			Render.DrawSlider(
				"vx (m/s)",
				&horizontal_velocity,
				1,
				5,
				34,
				308,
				264,
			)

			Render.DrawSlider(
				"h0 (m)",
				&initial_height,
				0,
				1,
				34,
				356,
				264,
			)

			flight_time := Math.Projectile_Flight_Time(
				initial_height,
				initial_vertical_velocity,
			)

			previous := [2]f32 {
				LAUNCH_X,
				initial_height,
			}

			for segment := 1; segment <= TRAJECTORY_SEGMENTS; segment += 1 {

				time := flight_time *
					cast(f32)segment /
					cast(f32)TRAJECTORY_SEGMENTS

				current := [2]f32 {
					LAUNCH_X +
						horizontal_velocity * time,

					Math.Projectile_Height(
						initial_height,
						initial_vertical_velocity,
						time,
					),
				}

				Render.DrawWorldLine(
					previous,
					current,
					center,
					3,
					Raylib.BLUE,
				)

				previous = current
			}

			animation_time := application_time

			if flight_time > 0 {
				for animation_time > flight_time {
					animation_time -= flight_time
				}
			}

			ball := [2]f32 {
				LAUNCH_X +
					horizontal_velocity * animation_time,

				Math.Projectile_Height(
					initial_height,
					initial_vertical_velocity,
					animation_time,
				),
			}

			Render.DrawPoint(
				{LAUNCH_X, initial_height},
				center,
			)

			Render.DrawColoredPoint(
				previous,
				center,
				Raylib.GREEN,
			)

			Render.DrawColoredPoint(
				ball,
				center,
				Raylib.ORANGE,
			)

			Raylib.DrawText(
				fmt.ctprintf(
					"h(t) = %.1f + %.1f*t - 4.9*t^2",
					initial_height,
					initial_vertical_velocity,
				),
				350,
				655,
				20,
				Raylib.BLUE,
			)
		}

		// =================================================
		// LINEAR
		// =================================================

		if selected_graph == .LINEAR {

			Raylib.DrawText(
				"Funcao afim",
				34,
				210,
				18,
				Raylib.DARKBLUE,
			)

			Raylib.DrawText(
				"Uma reta controlada por a e b",
				34,
				232,
				14,
				Raylib.DARKGRAY,
			)

			Render.DrawSlider(
				"a",
				&linear_a,
				-2,
				2,
				34,
				260,
				264,
			)

			Render.DrawSlider(
				"b",
				&linear_b,
				-3,
				3,
				34,
				308,
				264,
			)

			previous := [2]f32 {
				-5,
				Math.Affine(
					linear_a,
					linear_b,
					-5,
				),
			}

			for segment := 1; segment <= TRAJECTORY_SEGMENTS; segment += 1 {

				x := -5 +
					10 *
					cast(f32)segment /
					cast(f32)TRAJECTORY_SEGMENTS

				current := [2]f32 {
					x,
					Math.Affine(
						linear_a,
						linear_b,
						x,
					),
				}

				Render.DrawWorldLine(
					previous,
					current,
					center,
					3,
					Raylib.DARKBLUE,
				)

				previous = current
			}

			animation_x := -5 + application_time

			for animation_x > 5 {
				animation_x -= 10
			}

			Render.DrawColoredPoint(
				{
					animation_x,
					Math.Affine(
						linear_a,
						linear_b,
						animation_x,
					),
				},
				center,
				Raylib.ORANGE,
			)

			Raylib.DrawText(
				fmt.ctprintf(
					"f(x) = %.1f*x + %.1f",
					linear_a,
					linear_b,
				),
				350,
				655,
				20,
				Raylib.DARKBLUE,
			)
		}

		// =================================================
		// CÚBICA
		// =================================================

		if selected_graph == .CUBIC {

			Raylib.DrawText(
				"Funcao cubica",
				34,
				210,
				18,
				Raylib.DARKBLUE,
			)

			Raylib.DrawText(
				"Uma curva de terceiro grau",
				34,
				232,
				14,
				Raylib.DARKGRAY,
			)

			Render.DrawSlider(
				"a",
				&cubic_a,
				-0.01,
				0.01,
				34,
				260,
				264,
			)

			Render.DrawSlider(
				"b",
				&cubic_b,
				-0.04,
				0.04,
				34,
				308,
				264,
			)

			Render.DrawSlider(
				"c",
				&cubic_c,
				-0.30,
				0.30,
				34,
				356,
				264,
			)

			Render.DrawSlider(
				"d",
				&cubic_d,
				-1,
				1,
				34,
				404,
				264,
			)

			previous := [2]f32 {
				-5,
				Math.Cubic(
					cubic_a,
					cubic_b,
					cubic_c,
					cubic_d,
					-5,
				),
			}

			for segment := 1; segment <= TRAJECTORY_SEGMENTS; segment += 1 {

				x := -5 +
					10 *
					cast(f32)segment /
					cast(f32)TRAJECTORY_SEGMENTS

				current := [2]f32 {
					x,
					Math.Cubic(
						cubic_a,
						cubic_b,
						cubic_c,
						cubic_d,
						x,
					),
				}

				Render.DrawWorldLine(
					previous,
					current,
					center,
					3,
					Raylib.ORANGE,
				)

				previous = current
			}

			animation_x := -5 + application_time

			for animation_x > 5 {
				animation_x -= 10
			}

			Render.DrawColoredPoint(
				{
					animation_x,
					Math.Cubic(
						cubic_a,
						cubic_b,
						cubic_c,
						cubic_d,
						animation_x,
					),
				},
				center,
				Raylib.DARKBLUE,
			)

			Raylib.DrawText(
				fmt.ctprintf(
					"f(x) = %.2f*x^3 + %.2f*x^2 + %.2f*x + %.2f",
					cubic_a,
					cubic_b,
					cubic_c,
					cubic_d,
				),
				260,
				655,
				20,
				Raylib.ORANGE,
			)
		}

		// =================================================
		// LOGARITMO
		// =================================================

		if selected_graph == .LOGARITHMIC {

			Raylib.DrawText(
				"Funcao logaritmica",
				34,
				210,
				18,
				Raylib.DARKBLUE,
			)

			Raylib.DrawText(
				"f(x) = log_b(x)",
				34,
				232,
				14,
				Raylib.DARKGRAY,
			)

			Render.DrawSlider(
				"base",
				&log_base,
				1.1,
				10,
				34,
				260,
				264,
			)

			// O logaritmo só existe para x > 0.
			previous_valid := false
			previous := [2]f32{}

			for segment := 1; segment <= TRAJECTORY_SEGMENTS; segment += 1 {

				x := 0.1 +
					9.9 *
					cast(f32)segment /
					cast(f32)TRAJECTORY_SEGMENTS

				y := Math.Logarithm(
					log_base,
					x,
				)

				// Fora da área visível.
				if y < -5 || y > 5 {
					previous_valid = false
					continue
				}

				current := [2]f32{x, y}

				if previous_valid {
					Render.DrawWorldLine(
						previous,
						current,
						center,
						3,
						Raylib.DARKBLUE,
					)
				}

				previous = current
				previous_valid = true
			}

			animation_x := 0.1 + application_time

			for animation_x > 10 {
				animation_x -= 10
			}

			animation_y := Math.Logarithm(
				log_base,
				animation_x,
			)

			if animation_y >= -5 && animation_y <= 5 {

				Render.DrawColoredPoint(
					{
						animation_x,
						animation_y,
					},
					center,
					Raylib.ORANGE,
				)
			}

			Raylib.DrawText(
				fmt.ctprintf(
					"f(x) = log_%.2f(x)",
					log_base,
				),
				350,
				655,
				20,
				Raylib.DARKBLUE,
			)
		}

		// =================================================
		// LIMITE
		// =================================================

		if selected_graph == .LIMIT {

			Raylib.DrawText(
				"Limite",
				34,
				210,
				18,
				Raylib.DARKBLUE,
			)

			Raylib.DrawText(
				"f(x) = 1 / (x - 1)",
				34,
				232,
				14,
				Raylib.DARKGRAY,
			)

			Render.DrawSlider(
				"x ->",
				&limit_point,
				-4,
				4,
				34,
				260,
				264,
			)

			// ---------------------------------------------
			// GRÁFICO DA FUNÇÃO
			// ---------------------------------------------

			for segment := 0; segment < TRAJECTORY_SEGMENTS; segment += 1 {

				x1 := -5 +
					10 *
					cast(f32)segment /
					cast(f32)TRAJECTORY_SEGMENTS

				x2 := -5 +
					10 *
					cast(f32)(segment + 1) /
					cast(f32)TRAJECTORY_SEGMENTS

				// Não atravessar a assíntota x = 1.
				if (x1 < 1 && x2 >= 1) ||
					(x1 >= 1 && x2 < 1) {
					continue
				}

				y1 := Limit_Function(x1)
				y2 := Limit_Function(x2)

				// Não desenhar segmentos absurdamente grandes.
				if y1 < -5 || y1 > 5 {
					continue
				}

				if y2 < -5 || y2 > 5 {
					continue
				}

				Render.DrawWorldLine(
					{x1, y1},
					{x2, y2},
					center,
					3,
					Raylib.ORANGE,
				)
			}

			// ---------------------------------------------
			// APROXIMAÇÃO DO LIMITE
			// ---------------------------------------------

			// Evitamos exatamente x = 1 porque a função
			// possui uma assíntota nesse ponto.
			if math.abs(limit_point - 1) > 0.05 {

				limit_value := Math.Approximate_Limit(
					Limit_Function,
					limit_point,
					0.001,
				)

				Raylib.DrawText(
					fmt.ctprintf(
						"x -> %.2f",
						limit_point,
					),
					34,
					310,
					18,
					Raylib.DARKBLUE,
				)

				Raylib.DrawText(
					fmt.ctprintf(
						"aproximacao = %.4f",
						limit_value,
					),
					34,
					340,
					16,
					Raylib.DARKGRAY,
				)

				Render.DrawColoredPoint(
					{
						limit_point,
						limit_value,
					},
					center,
					Raylib.ORANGE,
				)
			} else {

				Raylib.DrawText(
					"x -> 1",
					34,
					310,
					18,
					Raylib.DARKBLUE,
				)

				Raylib.DrawText(
					"limite nao definido",
					34,
					340,
					16,
					Raylib.RED,
				)
			}

			Raylib.DrawText(
				"lim x -> a  1/(x-1)",
				350,
				655,
				20,
				Raylib.ORANGE,
			)
		}

		// =================================================
		// RODAPÉ
		// =================================================

		Raylib.DrawText(
			"Arraste os controles para atualizar o grafico",
			24,
			620,
			16,
			Raylib.DARKGRAY,
		)

		Raylib.DrawText(
			fmt.ctprintf(
				"FPS: %d",
				Raylib.GetFPS(),
			),
			900,
			48,
			14,
			Raylib.SKYBLUE,
		)

		Raylib.EndDrawing()
	}
}
