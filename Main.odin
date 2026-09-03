package Main

// ------------ Buit-in ------------

import "core:fmt"
import Raylib "vendor:raylib"

// ------------ Abstraction ------------
import Engine "src/engine"
import Render "src/render"
import Window "src/window"
// ------------ Core Engine Parameters ------------

// ------------ Core Engine Constants ------------

// * Tecnicamente não é uma constante, mas o valor não sera alterado
delta := Raylib.GetFrameTime() // ! Não alterar o valor | declarar outro valor.

// ------------ Core Engine Structs ------------

CoreEngine := Engine.CoreProcedure {
	Start  = Start,
	Update = Update,
}

CoreWindow := Window.Initialization {
	width  = 800,
	heigth = 600,
	title  = "A3 Algebra Linear",
}

main :: proc() {
	CoreEngine.Start()
	CoreEngine.Update(delta)
}

Start :: proc() {
	Raylib.InitWindow(CoreWindow.width, CoreWindow.heigth, CoreWindow.title)

	Raylib.SetTargetFPS(Engine.TARGET_FPS)
}

Update :: proc(delta: f32) {

	defer Raylib.CloseWindow()

	for !Raylib.WindowShouldClose() {
		Raylib.BeginDrawing()
		Raylib.ClearBackground(Raylib.RAYWHITE)

		// ------------ World Grid ------------

		Render.DrawGrid(
			Render.WORLD_GRID_SIZE,
			{cast(int)CoreWindow.width, cast(int)CoreWindow.heigth},
			Render.WORLD_GRID_COLOR,
		)

		// ------------ Draw Graph ------------

		Render.DrawGraph()

		Raylib.DrawText(fmt.ctprint("FPS:", Raylib.GetFPS()), 10, 10, 20, Raylib.GREEN)
		Raylib.EndDrawing()
	}
}
