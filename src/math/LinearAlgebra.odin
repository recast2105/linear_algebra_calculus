package Math

// ------------ All the linear algebra equation is contain in this file ------------

// Equation -> f(y) = a*x + b
// Origin -> (b != 0)
// Linear function -> f(x) = a*x
// * Quando A > 0 the line is to the right A < 0 Left
// * 0 of the func is y(0)
// * First step find the sqrt -> b
// * Cut the Y(point - up or down)
Affine :: proc(a: f32, b: f32) -> [2]f32 {
	x: f32 = 1
	equation := (a * x) + b

	return {equation, b}
}
