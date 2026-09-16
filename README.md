# Explorador de funções lineares e quadráticas

Aplicação interativa em [Odin](https://odin-lang.org/) com Raylib para visualizar funções em um plano cartesiano de pequena escala. O projeto oferece uma experiência simples, inspirada em calculadoras gráficas como o Desmos: escolha uma família de funções, ajuste seus parâmetros e observe o gráfico mudar imediatamente.

## Modos disponíveis

### Função linear

Exibe uma função afim:

```text
f(x) = a*x + b
```

Use os controles para alterar:

- `a`: inclinação da reta;
- `b`: intercepto no eixo Y.

A bolinha laranja percorre a reta para destacar como um ponto da função muda conforme `x` varia.

### Função quadrática: lançamento de projétil

Modela a trajetória de uma bola lançada sem resistência do ar:

```text
h(t) = h0 + v0y*t - (g/2)*t²
```

Onde `g = 9,81 m/s²`. Os controles permitem alterar:

- `v0y`: velocidade vertical inicial, em m/s;
- `vx`: velocidade horizontal, em m/s;
- `h0`: altura inicial, em m.

O tempo de voo é calculado resolvendo a equação quadrática da altura. A bolinha laranja anima a posição da bola durante o lançamento, enquanto os pontos verdes representam lançamento e impacto.

### Função cúbica

Exibe um polinômio de terceiro grau:

```text
f(x) = a*x³ + b*x² + c*x + d
```

Os quatro sliders controlam seus coeficientes. Esse modo ajuda a observar curvas com até dois pontos de mudança de direção, algo que uma reta ou uma parábola não representa.

## Controles

1. Clique em `Quadratica`, `Linear` ou `Cubica` no painel à esquerda para trocar o modo.
2. Arraste a bolinha de qualquer slider para alterar o respectivo parâmetro.
3. O gráfico, a equação exibida e a animação são atualizados no mesmo instante.

## Executar

É necessário ter o compilador [Odin](https://odin-lang.org/docs/install/) instalado. A Raylib é fornecida pelo pacote `vendor:raylib` do Odin.

```sh
make run
```

Ou diretamente:

```sh
odin run .
```

## Estrutura

- `Main.odin`: janela, estado da interação e desenho dos modos.
- `src/math/LinearAlgebra.odin`: funções afim e quadrática, raízes reais e modelo de projétil.
- `src/render/Render.odin`: plano cartesiano, curvas, pontos, sliders e botões de modo.
