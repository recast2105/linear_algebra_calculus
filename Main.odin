package Main

// ------------ Buit-in ------------
import "core:fmt"
import Raylib "vendor:raylib"

// ------------ Abstraction ------------
import Engine "src/engine"
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
   width = 800, 
   heigth = 600,
   title = "A3 Algebra Linear" 
}

main :: proc() {
	CoreEngine.Start()
	CoreEngine.Update(delta)
}

Start :: proc() {

}

Update :: proc(delta: f32) {

}
