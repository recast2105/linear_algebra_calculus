package Math

import "core:math"

// ------------ Todas as equações de álgebra linear estão contidas neste arquivo ------------

// Equação -> f(x) = a * x + b
// Origem -> quando b == 0, a reta passa pela origem
// Função linear -> f(x) = a * x
// Quando a > 0, a reta cresce da esquerda para a direita.
// Quando a < 0, a reta decresce da esquerda para a direita.
// O valor da função em x = 0 é f(0) = b.
// O coeficiente b representa onde a reta corta o eixo Y.
// O zero da função é o valor de x onde f(x) = 0.
Affine :: proc(a: f32, b: f32, x: f32) -> f32 {

	return (a * x) + b
}

// Equação quadrática -> f(x) = a * x² + b * x + c
Quadratic :: proc(a: f32, b: f32, c: f32, x: f32) -> f32 {
	return a * x * x + b * x + c
}

// Equação cúbica -> f(x) = a*x³ + b*x² + c*x + d
Cubic :: proc(a: f32, b: f32, c: f32, d: f32, x: f32) -> f32 {
	return a * x * x * x + b * x * x + c * x + d
}

Quadratic_Roots :: struct {
	has_real_roots: bool,
	first:          f32,
	second:         f32,
}

// Resolve a*x² + b*x + c = 0. Para a = 0, trata a expressão como linear.
Solve_Quadratic :: proc(a: f32, b: f32, c: f32) -> Quadratic_Roots {
	if a == 0 {
		if b == 0 {
			return {}
		}

		root := -c / b
		return {has_real_roots = true, first = root, second = root}
	}

	discriminant := b * b - 4 * a * c
	if discriminant < 0 {
		return {}
	}

	square_root := math.sqrt(discriminant)
	return {
		has_real_roots = true,
		first          = (-b + square_root) / (2 * a),
		second         = (-b - square_root) / (2 * a),
	}
}

// Modelo físico simplificado, sem resistência do ar. A gravidade é em m/s².
GRAVITY :: f32(9.81)

Projectile_Height :: proc(initial_height: f32, initial_vertical_velocity: f32, time: f32) -> f32 {
	// h(t) = h0 + v0y*t - (g/2)*t²
	return Quadratic(-GRAVITY * 0.5, initial_vertical_velocity, initial_height, time)
}

Projectile_Vertical_Velocity :: proc(initial_vertical_velocity: f32, time: f32) -> f32 {
	// vy(t) = v0y - g*t
	return Affine(-GRAVITY, initial_vertical_velocity, time)
}

Projectile_Flight_Time :: proc(initial_height: f32, initial_vertical_velocity: f32) -> f32 {
	roots := Solve_Quadratic(-GRAVITY * 0.5, initial_vertical_velocity, initial_height)
	if !roots.has_real_roots {
		return 0
	}

	// O instante físico de impacto é a maior raiz não negativa.
	if roots.first > roots.second {
		return roots.first
	}
	return roots.second
}
