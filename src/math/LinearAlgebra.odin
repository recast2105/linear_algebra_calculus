package Math

import "core:math"


// ============================================================
// FUNÇÕES BÁSICAS
// ============================================================

Affine :: proc(a, b, x: f32) -> f32 {
	return a * x + b
}


Quadratic :: proc(a, b, c, x: f32) -> f32 {
	return a*x*x + b*x + c
}


Cubic :: proc(a, b, c, d, x: f32) -> f32 {
	return a*x*x*x + b*x*x + c*x + d
}


// ============================================================
// LOGARITMOS
// ============================================================

// log_base(x)
Logarithm :: proc(base, x: f32) -> f32 {
	if x <= 0 || base <= 0 || base == 1 {
		return 0
	}

	return math.log(x, base)
}


// ln(x)
Natural_Logarithm :: proc(x: f32) -> f32 {
	if x <= 0 {
		return 0
	}

	return math.log(x, math.E)
}


// log10(x)
Log10 :: proc(x: f32) -> f32 {
	if x <= 0 {
		return 0
	}

	return math.log(x, 10)
}


// ============================================================
// EXPONENCIAL
// ============================================================

Exponential :: proc(base, x: f32) -> f32 {
	return math.pow(base, x)
}


// ============================================================
// EQUAÇÃO QUADRÁTICA
// ============================================================

Quadratic_Roots :: proc(a, b, c: f32) -> [2]f32 {
	discriminant := b*b - 4*a*c

	if discriminant < 0 {
		return {0, 0}
	}

	sqrt_discriminant := math.sqrt(discriminant)

	x1 := (-b + sqrt_discriminant) / (2*a)
	x2 := (-b - sqrt_discriminant) / (2*a)

	return {x1, x2}
}


Solve_Quadratic :: proc(a, b, c, x: f32) -> f32 {
	return Quadratic(a, b, c, x)
}


// ============================================================
// LIMITES
// ============================================================

Approximate_Limit :: proc(
	function: proc(x: f32) -> f32,
	point: f32,
	distance: f32,
) -> f32 {
	left := function(point - distance)
	right := function(point + distance)

	return (left + right) * 0.5
}


// ============================================================
// FÍSICA
// ============================================================

GRAVITY :: f32(9.81)


Projectile_Height :: proc(
	initial_height: f32,
	initial_velocity: f32,
	time: f32,
) -> f32 {
	return initial_height +
		initial_velocity*time -
		0.5*GRAVITY*time*time
}


Projectile_Vertical_Velocity :: proc(
	initial_velocity: f32,
	time: f32,
) -> f32 {
	return initial_velocity - GRAVITY*time
}


Projectile_Flight_Time :: proc(
	initial_height: f32,
	initial_velocity: f32,
) -> f32 {
	discriminant := initial_velocity*initial_velocity +
		2*GRAVITY*initial_height

	if discriminant < 0 {
		return 0
	}

	return (
		initial_velocity +
		math.sqrt(discriminant)
	) / GRAVITY
}
