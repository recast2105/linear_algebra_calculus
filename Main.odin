package Main

// ------------ Buit-In Package ------------

import "core:fmt"
import Raylib "vendor:raylib"

// ------------ Custom Package ------------

import Engine "src/engine"
import Math "src/math"
import Render "src/render"
import Window "src/window"

Delta := Raylib.GetFrameTime()

CoreEngine := Engine.CoreProcedure {
	Start  = Start,
	Update = Update,
}

CoreWindow := Window.Initialization {
	width  = 1000,
	heigth = 700,
	title  = "Explorador de Funcoes",
}

// Aplicação prática: lançamento de uma bola sem resistência do ar.
// A velocidade vertical é uma função afim; a altura é uma função quadrática.
LAUNCH_X :: f32(-4)
TRAJECTORY_SEGMENTS :: 96

Graph_Kind :: enum {
	QUADRATIC,
	LINEAR,
	CUBIC,
}

main :: proc() {
	CoreEngine.Start()
	CoreEngine.Update(Delta)
}

Start :: proc() {
	Raylib.InitWindow(CoreWindow.width, CoreWindow.heigth, CoreWindow.title)

	Raylib.SetTargetFPS(Engine.TARGET_FPS)
}

Update :: proc(delta: f32) {

	defer Raylib.CloseWindow()
	initial_height := f32(0)
	initial_vertical_velocity := f32(8)
	horizontal_velocity := f32(3)
	linear_a := f32(1)
	linear_b := f32(0)
	cubic_a := f32(0.01)
	cubic_b := f32(-0.04)
	cubic_c := f32(0.3)
	cubic_d := f32(0)
	selected_graph := Graph_Kind.QUADRATIC

	for !Raylib.WindowShouldClose() {

		Raylib.BeginDrawing()
		Raylib.ClearBackground(Raylib.Color {248, 250, 252, 255})
		Raylib.DrawRectangle(0, 0, CoreWindow.width, 72, Raylib.DARKBLUE)
		Raylib.DrawText("Explorador de Funcoes", 24, 17, 28, Raylib.RAYWHITE)
		Raylib.DrawText("funcoes lineares e quadraticas em uma escala compacta", 26, 47, 15, Raylib.SKYBLUE)

		// O painel ocupa a lateral esquerda; o plano cartesiano fica livre à direita.
		center := [2]f32 {650, 390}
		Render.DrawCoordinateGrid(center)
		Render.DrawGraph(center)
		Raylib.DrawText("y", 640, 104, 18, Raylib.RED)
		Raylib.DrawText("x", 914, 370, 18, Raylib.RED)
		// Painel interativo: escolha uma família de funções e arraste os controles.
		Raylib.DrawRectangle(18, 92, 300, 350, Raylib.RAYWHITE)
		Raylib.DrawRectangleLines(18, 92, 300, 350, Raylib.LIGHTGRAY)
		Raylib.DrawText("FUNCAO ATIVA", 34, 108, 14, Raylib.DARKGRAY)
		if Render.DrawModeButton("Quadratica", 34, 132, 84, selected_graph == .QUADRATIC) {
			selected_graph = .QUADRATIC
		}
		if Render.DrawModeButton("Linear", 124, 132, 84, selected_graph == .LINEAR) {
			selected_graph = .LINEAR
		}
		if Render.DrawModeButton("Cubica", 214, 132, 84, selected_graph == .CUBIC) {
			selected_graph = .CUBIC
		}

		if selected_graph == .QUADRATIC {
			Raylib.DrawText("Lancamento de projetil", 34, 176, 18, Raylib.DARKBLUE)
			Raylib.DrawText("A altura forma uma parabola", 34, 198, 14, Raylib.DARKGRAY)
			Render.DrawSlider("v0y (m/s)", &initial_vertical_velocity, 3, 8, 34, 220, 264)
			Render.DrawSlider("vx (m/s)", &horizontal_velocity, 1, 5, 34, 268, 264)
			Render.DrawSlider("h0 (m)", &initial_height, 0, 1, 34, 316, 264)

			flight_time := Math.Projectile_Flight_Time(initial_height, initial_vertical_velocity)
			previous := [2]f32 {LAUNCH_X, initial_height}
			for segment := 1; segment <= TRAJECTORY_SEGMENTS; segment += 1 {
				time := flight_time * cast(f32)segment / cast(f32)TRAJECTORY_SEGMENTS
				current := [2]f32 {LAUNCH_X + horizontal_velocity * time, Math.Projectile_Height(initial_height, initial_vertical_velocity, time)}
				Render.DrawWorldLine(previous, current, center, 3, Raylib.BLUE)
				previous = current
			}

			animation_time := cast(f32)Raylib.GetTime()
			for animation_time > flight_time { animation_time -= flight_time }
			ball := [2]f32 {LAUNCH_X + horizontal_velocity * animation_time, Math.Projectile_Height(initial_height, initial_vertical_velocity, animation_time)}
			Render.DrawPoint({LAUNCH_X, initial_height}, center)
			Render.DrawPoint(previous, center)
			Render.DrawColoredPoint(ball, center, Raylib.ORANGE)
			Raylib.DrawText(fmt.ctprintf("h(t) = %.1f + %.1f*t - 4.9*t^2", initial_height, initial_vertical_velocity), 350, 655, 20, Raylib.BLUE)
		} else if selected_graph == .LINEAR {
			Raylib.DrawText("Funcao afim", 34, 176, 18, Raylib.DARKBLUE)
			Raylib.DrawText("Uma reta controlada por a e b", 34, 198, 14, Raylib.DARKGRAY)
			Render.DrawSlider("a", &linear_a, -2, 2, 34, 230, 264)
			Render.DrawSlider("b", &linear_b, -3, 3, 34, 282, 264)

			previous := [2]f32 {-5, Math.Affine(linear_a, linear_b, -5)}
			for segment := 1; segment <= TRAJECTORY_SEGMENTS; segment += 1 {
				x := -5 + 10 * cast(f32)segment / cast(f32)TRAJECTORY_SEGMENTS
				current := [2]f32 {x, Math.Affine(linear_a, linear_b, x)}
				Render.DrawWorldLine(previous, current, center, 3, Raylib.DARKBLUE)
				previous = current
			}

			animation_x := -5 + cast(f32)Raylib.GetTime()
			for animation_x > 5 { animation_x -= 10 }
			Render.DrawColoredPoint({animation_x, Math.Affine(linear_a, linear_b, animation_x)}, center, Raylib.ORANGE)
			Raylib.DrawText(fmt.ctprintf("f(x) = %.1f*x + %.1f", linear_a, linear_b), 350, 655, 20, Raylib.DARKBLUE)
		} else {
			Raylib.DrawText("Funcao cubica", 34, 176, 18, Raylib.DARKBLUE)
			Raylib.DrawText("Uma curva de terceiro grau", 34, 198, 14, Raylib.DARKGRAY)
			Render.DrawSlider("a", &cubic_a, -0.01, 0.01, 34, 220, 264)
			Render.DrawSlider("b", &cubic_b, -0.04, 0.04, 34, 268, 264)
			Render.DrawSlider("c", &cubic_c, -0.30, 0.30, 34, 316, 264)
			Render.DrawSlider("d", &cubic_d, -1, 1, 34, 364, 264)

			previous := [2]f32 {-5, Math.Cubic(cubic_a, cubic_b, cubic_c, cubic_d, -5)}
			for segment := 1; segment <= TRAJECTORY_SEGMENTS; segment += 1 {
				x := -5 + 10 * cast(f32)segment / cast(f32)TRAJECTORY_SEGMENTS
				current := [2]f32 {x, Math.Cubic(cubic_a, cubic_b, cubic_c, cubic_d, x)}
				Render.DrawWorldLine(previous, current, center, 3, Raylib.ORANGE)
				previous = current
			}

			animation_x := -5 + cast(f32)Raylib.GetTime()
			for animation_x > 5 { animation_x -= 10 }
			Render.DrawColoredPoint({animation_x, Math.Cubic(cubic_a, cubic_b, cubic_c, cubic_d, animation_x)}, center, Raylib.DARKBLUE)
			Raylib.DrawText(fmt.ctprintf("f(x) = %.2f*x^3 + %.2f*x^2 + %.2f*x + %.2f", cubic_a, cubic_b, cubic_c, cubic_d), 260, 655, 20, Raylib.ORANGE)
		}

		Raylib.DrawText("Arraste os controles para atualizar o grafico", 24, 620, 16, Raylib.DARKGRAY)
		Raylib.DrawText(fmt.ctprintf("FPS: %d", Raylib.GetFPS()), 900, 48, 14, Raylib.SKYBLUE)
		Raylib.EndDrawing()
	}
}
