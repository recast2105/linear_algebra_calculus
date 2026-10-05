# Explorador de Funções

Aplicação interativa em [Odin](https://odin-lang.org/) com Raylib para visualizar funções e conceitos matemáticos em um plano cartesiano de pequena escala.

O projeto oferece uma experiência simples, inspirada em calculadoras gráficas como o Desmos: escolha uma família de funções, ajuste seus parâmetros e observe o gráfico mudar imediatamente.

O objetivo principal do projeto é **estudar programação, matemática e visualização gráfica na prática**, implementando as funções e seus modelos matemáticos manualmente.

## Modos disponíveis

### Função linear

Exibe uma função afim:

```text
f(x) = a*x + b
```

Use os controles para alterar:

* `a`: inclinação da reta;
* `b`: intercepto no eixo Y.

A bolinha laranja percorre a reta para destacar como um ponto da função muda conforme `x` varia.

---

### Função quadrática: lançamento de projétil

Modela a trajetória de uma bola lançada sem resistência do ar:

```text
h(t) = h0 + v0y*t - (g/2)*t²
```

Onde:

```text
g = 9,81 m/s²
```

Os controles permitem alterar:

* `v0y`: velocidade vertical inicial;
* `vx`: velocidade horizontal;
* `h0`: altura inicial.

O tempo de voo é calculado resolvendo a equação quadrática da altura.

A trajetória é desenhada como uma parábola. A bolinha laranja representa a posição atual da bola durante a animação, enquanto os pontos indicam o lançamento e o final da trajetória.

---

### Função cúbica

Exibe um polinômio de terceiro grau:

```text
f(x) = a*x³ + b*x² + c*x + d
```

Os quatro sliders controlam seus coeficientes:

* `a`
* `b`
* `c`
* `d`

Esse modo permite observar curvas de terceiro grau e como seus coeficientes alteram seu comportamento.

---

### Função logarítmica

Exibe uma função logarítmica:

```text
f(x) = log_b(x)
```

A base `b` determina o comportamento da função:

```text
b > 1     → função crescente
0 < b < 1 → função decrescente
b = 1     → inválido
```

O domínio da função é:

```text
x > 0
```

A implementação utiliza a mudança de base:

```text
log_b(x) = ln(x) / ln(b)
```

Esse modo permite estudar visualmente a relação entre a base e o crescimento da função.

---

### Limite

Exibe a função:

```text
f(x) = 1 / (x - 1)
```

A função possui uma assíntota vertical em:

```text
x = 1
```

O controle permite escolher o ponto `a` para o qual a função se aproxima.

A aplicação estima o limite avaliando a função dos dois lados:

```text
f(a - ε)
f(a + ε)
```

e calculando a média dos dois valores.

Quando o ponto se aproxima da assíntota `x = 1`, o programa indica que o limite não está definido nesse ponto.

## Controles

1. Clique em um dos modos no painel à esquerda:

   * `Quadratica`
   * `Linear`
   * `Cubica`
   * `Log`
   * `Limite`

2. Arraste a bolinha de qualquer slider para alterar seus parâmetros.

3. O gráfico e os valores exibidos são atualizados em tempo real.

## Plano cartesiano

O gráfico utiliza uma conversão entre coordenadas matemáticas e coordenadas de tela.

A escala atual é:

```text
1 unidade matemática = 50 pixels
```

O eixo Y é invertido durante a conversão porque, na tela, o eixo Y cresce de cima para baixo.

Por exemplo:

```text
coordenada matemática:
(2, 3)

coordenada na tela:
x = centro.x + 2 * escala
y = centro.y - 3 * escala
```

## Executar

É necessário ter o compilador [Odin](https://odin-lang.org/docs/install/) instalado.

A aplicação utiliza a Raylib através do pacote:

```text
vendor:raylib
```

Para executar utilizando o Makefile:

```sh
make run
```

Ou diretamente pelo Odin:

```sh
odin run .
```

Para apenas compilar:

```sh
make build
```

## Estrutura

```text
.
├── Main.odin
├── Makefile
├── README.md
└── src
    ├── engine
    │   └── Engine.odin
    ├── math
    │   └── LinearAlgebra.odin
    ├── render
    │   └── Render.odin
    └── window
        └── Window.odin
```

### `Main.odin`

Responsável pela aplicação principal:

* inicialização da janela;
* loop principal;
* estado dos controles;
* seleção do modo;
* parâmetros das funções;
* animações;
* integração entre matemática e renderização.

### `src/engine/Engine.odin`

Contém a estrutura básica do ciclo de execução da aplicação:

```text
Start
Update
```

Também define configurações gerais, como o FPS desejado.

### `src/math/LinearAlgebra.odin`

Contém as implementações matemáticas utilizadas pela aplicação:

* função afim;
* função quadrática;
* função cúbica;
* logaritmos;
* exponencial;
* resolução de equações quadráticas;
* limites aproximados;
* trajetória de projéteis;
* velocidade vertical;
* tempo de voo.

### `src/render/Render.odin`

Responsável pelos elementos visuais:

* grade cartesiana;
* eixos X/Y;
* números dos eixos;
* curvas;
* segmentos;
* pontos;
* sliders;
* botões de seleção.

### `src/window/Window.odin`

Contém a configuração básica da janela:

* largura;
* altura;
* título;
* cálculo do centro da janela.

## Objetivo do projeto

Este projeto é principalmente um **projeto de estudo**.

A ideia é utilizar uma aplicação gráfica pequena para praticar conceitos de:

* Odin;
* programação modular;
* matemática;
* álgebra;
* funções;
* equações;
* física básica;
* coordenadas cartesianas;
* conversão de coordenadas;
* renderização 2D;
* interação com mouse;
* animação;
* organização de código.

O projeto pode ser expandido futuramente com novas funções, transformações, vetores, derivadas, integrais e outros conceitos matemáticos.
