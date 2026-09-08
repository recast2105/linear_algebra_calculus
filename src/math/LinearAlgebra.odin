package Math

// ------------ Todas as equações de álgebra linear estão contidas neste arquivo ------------

// Equação -> f(x) = a * x + b
// Origem -> quando b == 0, a reta passa pela origem
// Função linear -> f(x) = a * x
// Quando a > 0, a reta cresce da esquerda para a direita.
// Quando a < 0, a reta decresce da esquerda para a direita.
// O valor da função em x = 0 é f(0) = b.
// O coeficiente b representa onde a reta corta o eixo Y.
// O zero da função é o valor de x onde f(x) = 0.
Affine :: proc(a: f32, b: f32, x: f32) -> [2]f32 {

	return (a * x) + b
}
