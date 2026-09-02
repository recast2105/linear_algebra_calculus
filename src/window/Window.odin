package Window

Initialization :: struct {
	width:  i32,
	heigth: i32,
	title:  cstring,
}

GetCenterWindow :: proc(window: Initialization) -> [2]f32 {
	return {cast(f32)window.width, cast(f32)window.heigth} * 0.5
}
