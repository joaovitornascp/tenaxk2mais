// =============================================================================
//  Tensões no ponto P da seção transversal de um eixo submetido
//  simultaneamente a força normal N_x, torque T_x e momento fletor M_z.
//
//  Compilar:  typst compile analise_tensoes_ponto_P.typ
//  (documento autossuficiente: não usa pacotes externos)
// =============================================================================

#set page(paper: "a4", margin: (x: 2.2cm, y: 2.0cm), numbering: "1 / 1")
#set text(lang: "pt", size: 10.5pt)
#set par(justify: true, leading: 0.72em)
#set heading(numbering: "1.")
#show heading: it => block(above: 1.1em, below: 0.7em)[#text(fill: rgb("#1f4e79"))[#it]]
#set math.equation(numbering: "(1)")

#let azul = rgb("#1f4e79")
#let verm = rgb("#b3261e")
#let verd = rgb("#1e7a4d")
#let cinz = rgb("#8a8a8a")

#let destaque(corpo) = block(
  width: 100%, inset: 8pt, radius: 3pt, breakable: false,
  fill: rgb("#f2f6fa"), stroke: 0.6pt + rgb("#c9d8e6"),
  corpo,
)

// --- utilitários de desenho (Typst nativo, sem CeTZ) -------------------------
// seta reta de (x0,y0) a (x1,y1) — apenas horizontal ou vertical
#let seta(x0, y0, x1, y1, col, lw: 1.2pt, cabeca: 6.5pt) = {
  place(dx: x0, dy: y0, line(start: (0pt, 0pt), end: (x1 - x0, y1 - y0), stroke: lw + col))
  if x0 == x1 {
    let d = if y1 > y0 { 1 } else { -1 }
    place(dx: x1, dy: y1, polygon(fill: col, stroke: none,
      (0pt, 0pt), (-2.3pt, -cabeca * d), (2.3pt, -cabeca * d)))
  } else {
    let d = if x1 > x0 { 1 } else { -1 }
    place(dx: x1, dy: y1, polygon(fill: col, stroke: none,
      (0pt, 0pt), (-cabeca * d, -2.3pt), (-cabeca * d, 2.3pt)))
  }
}

// =============================================================================
#align(center)[
  #text(15.5pt, weight: "bold", fill: azul)[
    Estado de tensão no ponto P de um eixo de engrenagem helicoidal
  ]
  #v(-4pt)
  #text(12pt)[Esforços combinados: força normal $N_x$, torque $T_x$ e momento fletor $M_z$]
]
#v(4pt)
#line(length: 100%, stroke: 0.8pt + azul)

= Enunciado

#figure(
  image("enunciado.png", width: 78%),
  caption: [Questão proposta: seção transversal do eixo e o ponto $P$.],
)

#destaque[
  *Alternativas*
  #grid(columns: (1fr, 1fr), gutter: 6pt,
    [(A) $sigma_x > 0$ e $tau_(x z) = 0$ \
     (B) $sigma_y = 0$ e $tau_(x z) = 0$ \
     (C) $sigma_z eq.not 0$ e $tau_(x z) eq.not 0$],
    [(D) $sigma_x < 0$ e $tau_(x z) eq.not 0$ \
     (E) $sigma_x < 0$ e $tau_(x z) = 0$],
  )
]

= Passo 1 — Situar o ponto P e o sistema de eixos

O eixo $x$ é o *eixo longitudinal* do eixo-árvore, logo a seção transversal está
contida no plano $y z$ e sua *normal é $x$*. O ponto $P$ está:

- na *superfície externa* do eixo (raio $rho = R = d \/ 2$);
- na *base* da seção, sobre o eixo $y$ negativo: $ (y_P, z_P) = (-R, 0) . $

#figure(
  block(breakable: false, width: 12.5cm, height: 6.0cm, {
    let cx = 6.0cm     // centro do círculo
    let cy = 2.8cm
    let R = 2.0cm
    // eixos
    seta(cx, cy, cx, cy - 2.55cm, black, lw: 0.9pt)          // y para cima
    place(dx: cx + 5pt, dy: cy - 2.8cm, text(10pt)[$y$])
    seta(cx, cy, cx - 3.1cm, cy, black, lw: 0.9pt)           // z para a esquerda
    place(dx: cx - 3.5cm, dy: cy - 16pt, text(10pt)[$z$])
    place(dx: cx - 8pt, dy: cy + 6pt, text(9pt, fill: cinz)[$O$])
    place(dx: cx + R + 0.15cm, dy: cy - R - 0.25cm,
      text(8.5pt, fill: cinz)[$x$ sai do papel])
    // seção
    place(dx: cx - R, dy: cy - R, circle(radius: R, stroke: 1.4pt + black, fill: rgb("#f7f7f7")))
    place(dx: cx - 3pt, dy: cy - 3pt, circle(radius: 3pt, fill: black))
    // raio
    place(dx: cx, dy: cy, line(start: (0pt, 0pt), end: (0pt, R),
      stroke: (paint: cinz, thickness: 0.7pt, dash: "dashed")))
    place(dx: cx + 5pt, dy: cy + 0.8cm, text(9pt, fill: cinz)[$R = d\/2$])
    // ponto P
    place(dx: cx - 3.5pt, dy: cy + R - 3.5pt, circle(radius: 3.5pt, fill: verm))
    place(dx: cx - 24pt, dy: cy + R - 7pt, text(11pt, weight: "bold", fill: verm)[$P$])
    // tensao de cisalhamento de torcao: tangente em P (direcao z)
    seta(cx + 0.15cm, cy + R, cx + 1.5cm, cy + R, verd, lw: 1.5pt)
    place(dx: cx + 1.6cm, dy: cy + R - 8pt, text(10pt, fill: verd)[$tau = T_x R \/ J$])
    place(dx: cx + 0.15cm, dy: cy + R + 10pt,
      text(8.5pt, fill: verd)[tangente em $P$ $=>$ direção $z$])
    // distribuicao de sigma_x da flexao (linear em y), desenhada a esquerda
    let bx = 1.6cm
    place(dx: bx, dy: cy - R, line(start: (0pt, 0pt), end: (0pt, 2 * R), stroke: 0.8pt + cinz))
    place(dx: bx, dy: cy - R, polygon(fill: rgb("#dfe9f3"), stroke: 0.9pt + azul,
      (0pt, 0pt), (1.1cm, 0pt), (0pt, R)))
    place(dx: bx - 1.1cm, dy: cy + R - 0.0cm, polygon(fill: rgb("#f3dcda"), stroke: 0.9pt + verm,
      (0pt, 0pt), (1.1cm, 0pt), (1.1cm, -R)))
    place(dx: bx + 0.1cm, dy: cy - R - 16pt, text(9pt, fill: azul)[tração])
    place(dx: bx - 1.5cm, dy: cy + R + 6pt, text(9pt, fill: verm)[compressão])
    place(dx: bx - 1.75cm, dy: cy - 0.2cm, text(9pt, fill: cinz)[$sigma_x (M_z)$])
  }),
  caption: [Seção transversal vista de $+x$: $P$ é fibra extrema da flexão
    (distribuição linear à esquerda) e ponto de $tau$ máxima da torção.],
)

= Passo 2 — Contribuição de cada esforço

== Força normal $N_x$ — gera $sigma_x$ uniforme

$ sigma_x^((N)) = N_x / A, quad A = (pi d^2)/4 $

Na figura do enunciado a seta de $N_x$ aponta *contra a face da seção*, isto é,
*comprime* o eixo:

$ sigma_x^((N)) = - (4 abs(N_x))/(pi d^2) < 0 $

== Momento fletor $M_z$ — gera $sigma_x$ linear em $y$

Flexão em torno de $z$ produz tensão normal na direção $x$, variando
linearmente com a distância à linha neutra (que é o próprio eixo $z$):

$ sigma_x^((M)) = - (M_z y)/I_z, quad I_z = (pi d^4)/64 $

Como $P$ está na *fibra extrema* ($y = -R$), aí a tensão de flexão é *máxima em
módulo*:

$ abs(sigma_x^((M))) = (M_z R)/I_z = (32 M_z)/(pi d^3) $

Com o sentido de $M_z$ indicado, a fibra inferior (onde está $P$) é a
*comprimida* — ela se soma à compressão de $N_x$.

== Torque $T_x$ — gera cisalhamento tangencial

Na torção de seção circular, a tensão de cisalhamento é *tangente à
circunferência* e cresce linearmente com o raio:

$ tau = (T_x rho)/J, quad J = (pi d^4)/32
  quad ==> quad tau_max = (T_x R)/J = (16 T_x)/(pi d^3) quad "em" rho = R $

#destaque[
  *Este é o ponto-chave da questão.* Em $P$ (sobre o eixo $y$), a *tangente à
  circunferência é horizontal*, ou seja, aponta na *direção $z$*. Como a tensão
  de cisalhamento da torção é tangencial, ela se decompõe em $P$ como:

  $ tau_(x z) = (16 T_x)/(pi d^3) eq.not 0, quad quad tau_(x y) = 0 $

  (em um ponto sobre o eixo $z$ seria o contrário: $tau_(x y) eq.not 0$ e
  $tau_(x z) = 0$.)
]

= Passo 3 — Estado de tensão resultante em P

Superpondo as três contribuições, e lembrando que $P$ está na *superfície livre*
do eixo (não há carga aplicada na lateral, logo $sigma_y = sigma_z = tau_(y z) = 0$):

$ sigma_x = - (4 abs(N_x))/(pi d^2) - (32 M_z)/(pi d^3) < 0,
  quad quad tau_(x z) = (16 T_x)/(pi d^3) eq.not 0 $

$ [sigma] = mat(sigma_x, 0, tau_(x z); 0, 0, 0; tau_(x z), 0, 0),
  quad "com" sigma_x < 0 " e " tau_(x z) eq.not 0 $

Ou seja, o cubo representativo em $P$ está em *estado plano de tensão no plano
$x z$*: compressão axial acompanhada de cisalhamento.

#figure(
  block(breakable: false, width: 12.0cm, height: 5.6cm, {
    let x0 = 4.2cm
    let y0 = 1.2cm
    let L = 2.6cm
    // elemento
    place(dx: x0, dy: y0, rect(width: L, height: L, fill: rgb("#f7f7f7"), stroke: 1.2pt + black))
    // sigma_x: setas apontando para DENTRO (compressao) nas faces de normal x
    seta(x0 - 1.15cm, y0 + L / 2, x0 - 0.12cm, y0 + L / 2, verm, lw: 1.5pt)
    seta(x0 + L + 1.15cm, y0 + L / 2, x0 + L + 0.12cm, y0 + L / 2, verm, lw: 1.5pt)
    place(dx: x0 - 1.5cm, dy: y0 + L / 2 - 22pt, text(10.5pt, fill: verm)[$sigma_x < 0$])
    place(dx: x0 + L + 0.3cm, dy: y0 + L / 2 - 22pt, text(10.5pt, fill: verm)[$sigma_x < 0$])
    // tau_xz nas faces de normal x (verticais) e complementares nas de normal z
    seta(x0 - 0.06cm, y0 + 0.35cm, x0 - 0.06cm, y0 + L - 0.35cm, verd, lw: 1.4pt)
    seta(x0 + L + 0.06cm, y0 + L - 0.35cm, x0 + L + 0.06cm, y0 + 0.35cm, verd, lw: 1.4pt)
    seta(x0 + 0.35cm, y0 - 0.06cm, x0 + L - 0.35cm, y0 - 0.06cm, verd, lw: 1.4pt)
    seta(x0 + L - 0.35cm, y0 + L + 0.06cm, x0 + 0.35cm, y0 + L + 0.06cm, verd, lw: 1.4pt)
    place(dx: x0 + L / 2 - 14pt, dy: y0 - 24pt, text(10.5pt, fill: verd)[$tau_(x z)$])
    // eixos locais
    seta(1.0cm, 4.6cm, 2.0cm, 4.6cm, black, lw: 0.9pt)
    place(dx: 2.1cm, dy: 4.6cm - 8pt, text(9.5pt)[$x$])
    seta(1.0cm, 4.6cm, 1.0cm, 3.6cm, black, lw: 0.9pt)
    place(dx: 1.1cm, dy: 3.35cm, text(9.5pt)[$z$])
    place(dx: 0.55cm, dy: 4.75cm, text(8.5pt, fill: cinz)[($y$ sai do papel)])
    place(dx: x0 - 0.1cm, dy: y0 + L + 0.5cm,
      text(9pt, fill: cinz)[faces de normal $z$: livres $=>$ $sigma_z = 0$])
  }),
  caption: [Elemento representativo em $P$, no plano $x z$: compressão axial
    $sigma_x < 0$ e cisalhamento de torção $tau_(x z) eq.not 0$ (com as
    tensões complementares $tau_(z x) = tau_(x z)$).],
)

= Passo 4 — Análise das alternativas

#align(center)[
  #table(
    columns: (auto, 1fr, auto),
    align: (center, left, center), inset: 6pt, stroke: 0.5pt + rgb("#c9d8e6"),
    fill: (_, y) => if y == 0 { rgb("#eef4fa") },
    [*Alt.*], [*Verificação*], [*Veredito*],
    [(A)],
    [$sigma_x > 0$ é falso ($N_x$ e $M_z$ comprimem $P$) e $tau_(x z) = 0$ é
     falso (o torque $T_x$ gera cisalhamento tangencial, que em $P$ é justamente
     na direção $z$).],
    [#text(fill: verm)[errada]],
    [(B)],
    [$sigma_y = 0$ é #emph[verdadeiro] (superfície livre), mas $tau_(x z) = 0$ é
     falso pelo mesmo motivo acima. Basta uma parte falsa para invalidar.],
    [#text(fill: verm)[errada]],
    [(C)],
    [$tau_(x z) eq.not 0$ é verdadeiro, mas $sigma_z eq.not 0$ é falso: $P$ está
     na superfície externa, livre de carregamento, logo $sigma_z = 0$
     (e $sigma_y = 0$).],
    [#text(fill: verm)[errada]],
    [(D)],
    [$sigma_x < 0$: compressão de $N_x$ somada à flexão que comprime a fibra
     inferior. $tau_(x z) eq.not 0$: torção com tangente na direção $z$ em $P$.
     *As duas afirmações são verdadeiras.*],
    [#text(fill: verd, weight: "bold")[correta]],
    [(E)],
    [$sigma_x < 0$ é verdadeiro, mas $tau_(x z) = 0$ ignora o torque $T_x$.],
    [#text(fill: verm)[errada]],
  )
]

#v(4pt)
#destaque[
  #align(center)[#text(13pt, weight: "bold", fill: verd)[Resposta: alternativa (D)]]
  #align(center)[$sigma_x < 0 quad "e" quad tau_(x z) eq.not 0$]
]

= Observações complementares

- *Por que a torção não some em $P$?* A tensão de torção é tangencial e *máxima
  em toda a superfície externa* ($rho = R$) — não existe ponto da superfície com
  $tau = 0$. O que muda de ponto para ponto é apenas *em qual direção* ela se
  projeta: em $P$ (sobre $y$) ela é $tau_(x z)$; em um ponto sobre o eixo $z$
  seria $tau_(x y)$.

- *Por que $P$ é um ponto crítico?* Ali se somam a compressão de $N_x$, a
  *máxima* tensão de flexão (fibra extrema) e a *máxima* tensão de torção
  (superfície). Além disso, a força normal das engrenagens helicoidais é
  justamente o esforço axial $N_x$ que aparece nesse tipo de transmissão.

- *Verificação de resistência* (estado plano com $sigma_x$ e $tau_(x z)$),
  por von Mises:
  $ sigma_(v m) = sqrt(sigma_x^2 + 3 tau_(x z)^2) <= sigma_e / n $
  e as tensões principais valem
  $ sigma_(1,2) = sigma_x / 2 plus.minus sqrt((sigma_x / 2)^2 + tau_(x z)^2) . $

- Se o sentido de $M_z$ fosse invertido, a flexão *tracionaria* a fibra inferior
  e o sinal de $sigma_x$ em $P$ passaria a depender das magnitudes relativas de
  $N_x$ e $M_z$ — mas $tau_(x z) eq.not 0$ continuaria valendo, o que já
  eliminaria (A), (B) e (E) de qualquer forma.
