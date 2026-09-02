package Engine

TARGET_FPS :: 60

CoreProcedure :: struct {
	Start:  proc(),
	Update: proc(_: f32),
}
