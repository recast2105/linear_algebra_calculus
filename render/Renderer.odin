package Render

TARGET_FPS :: 60

Engine :: struct {
	Start:  proc(),
	Update: proc(_: f32),
}
