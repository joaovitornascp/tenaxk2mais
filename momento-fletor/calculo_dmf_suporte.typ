// =============================================================================
//  Suporte de gasoduto sob viaduto — cálculo passo a passo dos esforços
//  internos da viga AF (DEC e DMF).
//
//  Compilar:  typst compile calculo_dmf_suporte.typ
//  (documento autossuficiente: não usa pacotes externos)
// =============================================================================

#set page(paper: "a4", margin: (x: 2.2cm, y: 2.0cm), numbering: "1 / 1")
#set text(lang: "pt", size: 10.5pt)
#set par(justify: true, leading: 0.72em)
#set heading(numbering: "1.")
#show heading: it => block(above: 1.1em, below: 0.7em)[#text(fill: rgb("#1f4e79"))[#it]]
#show link: it => text(fill: rgb("#1f4e79"))[#it]
#set math.equation(numbering: "(1)")

#let azul = rgb("#1f4e79")
#let verm = rgb("#b3261e")
#let cinz = rgb("#8a8a8a")

#let destaque(corpo) = block(
  width: 100%, inset: 8pt, radius: 3pt, breakable: false,
  fill: rgb("#f2f6fa"), stroke: 0.6pt + rgb("#c9d8e6"),
  corpo,
)

// --- utilitários de desenho (Typst nativo, sem CeTZ) -------------------------
#let ux = 4cm            // escala horizontal: 1 vão "a" = 4 cm

// seta vertical de (x, y0) até (x, y1); y cresce para baixo
#let seta-v(x, y0, y1, col, lw: 1.3pt) = {
  let d = if y1 > y0 { 1 } else { -1 }
  place(dx: x, dy: y0, line(start: (0pt, 0pt), end: (0pt, y1 - y0), stroke: lw + col))
  place(dx: x, dy: y1, polygon(fill: col, stroke: none,
    (0pt, 0pt), (-2.4pt, -7pt * d), (2.4pt, -7pt * d)))
}

// linha de cota horizontal com texto
#let cota(x0, x1, y, rot) = {
  place(dx: x0, dy: y, line(start: (0pt, 0pt), end: (x1 - x0, 0pt), stroke: 0.5pt + cinz))
  place(dx: x0, dy: y - 3pt, line(start: (0pt, 0pt), end: (0pt, 6pt), stroke: 0.5pt + cinz))
  place(dx: x1, dy: y - 3pt, line(start: (0pt, 0pt), end: (0pt, 6pt), stroke: 0.5pt + cinz))
  place(dx: x0 + (x1 - x0) / 2 - 6pt, dy: y + 4pt, text(9pt, fill: cinz)[#rot])
}

#let rotulo(x, y, corpo, dx: -6pt) = place(dx: x + dx, dy: y, corpo)

// =============================================================================
#align(center)[
  #text(16pt, weight: "bold", fill: azul)[
    Suporte da tubulação de um gasoduto sob viaduto
  ]
  #v(-4pt)
  #text(12.5pt)[Cálculo passo a passo dos esforços internos da viga AF]
  #v(-2pt)
  #text(9.5pt, fill: cinz)[Diagrama de esforço cortante (DEC) e diagrama de momento fletor (DMF)]
]
#v(6pt)
#line(length: 100%, stroke: 0.8pt + azul)

= Descrição do problema e dados

A tubulação do gasoduto é fixada sob o viaduto por suportes formados por *duas
barras* verticais ($A B$ e $C D$) e *uma viga* horizontal ($A F$). As barras são
elásticas lineares, de mesma geometria: área de seção transversal $A$ e
comprimento $L$. A tubulação apoia-se sobre a viga no ponto $E$, transmitindo a
força vertical $F$, dirigida para baixo.

Os pontos notáveis da viga são igualmente espaçados de $a$:

$ x_A = 0, quad x_C = a, quad x_E = 2a, quad x_F = 3a. $

#v(2pt)
#figure(
  block(breakable: false, width: 13.2cm, height: 4.9cm, {
    let yv = 0.35cm      // viaduto
    let yb = 3.0cm       // viga
    // viaduto (hachura de engaste)
    place(dx: -0.4cm, dy: yv, line(start: (0pt, 0pt), end: (13.2cm, 0pt), stroke: 2.4pt + black))
    for i in range(0, 15) {
      place(dx: -0.4cm + i * 0.95cm, dy: yv - 6pt,
        line(start: (0pt, 6pt), end: (5pt, 0pt), stroke: 0.5pt + cinz))
    }
    place(dx: 11.6cm, dy: yv - 20pt, text(9pt, fill: cinz)[viaduto])
    // barras AB e CD
    for (x, nome, nb) in ((0cm, "AB", "B"), (ux, "CD", "D")) {
      place(dx: x, dy: yv, line(start: (0pt, 0pt), end: (0pt, yb - yv), stroke: 1.6pt + cinz))
      place(dx: x - 22pt, dy: yv + 0.95cm, text(9pt, fill: cinz)[#nome])
      place(dx: x - 3pt, dy: yv - 3pt, circle(radius: 3pt, stroke: 0.7pt + cinz, fill: white))
      place(dx: x + 5pt, dy: yv - 14pt, text(9pt, fill: cinz)[#nb])
    }
    // viga
    place(dx: 0cm, dy: yb, line(start: (0pt, 0pt), end: (3 * ux, 0pt), stroke: 4pt + black))
    for (x, nome) in ((0cm, "A"), (ux, "C"), (2 * ux, "E"), (3 * ux, "F")) {
      place(dx: x - 3pt, dy: yb - 3pt, circle(radius: 3pt, stroke: 0.7pt + black, fill: white))
      place(dx: x - 4pt, dy: yb + 8pt, text(10pt, weight: "bold")[#nome])
    }
    // carga da tubulação em E
    place(dx: 2 * ux - 0.62cm, dy: yb - 1.5cm,
      circle(radius: 0.62cm, stroke: 3pt + rgb("#c9c9c9")))
    seta-v(2 * ux, yb - 1.7cm, yb - 3pt, verm, lw: 1.6pt)
    place(dx: 2 * ux + 8pt, dy: yb - 1.0cm, text(11pt, weight: "bold", fill: verm)[$F$])
    // cotas
    cota(0cm, ux, yb + 1.15cm, [$a$])
    cota(ux, 2 * ux, yb + 1.15cm, [$a$])
    cota(2 * ux, 3 * ux, yb + 1.15cm, [$a$])
  }),
  caption: [Modelo do suporte: viga $A F$ pendurada no viaduto pelas barras $A B$ e $C D$.],
)

= Hipóteses do modelo estrutural

#destaque[
  - As barras $A B$ e $C D$ são *rotuladas nas duas extremidades* (ver os pinos
    em $A$, $B$, $C$ e $D$ na figura do enunciado). Logo, são *elementos de dois
    nós*: transmitem apenas *força normal*, não transmitem momento nem cortante.
  - O viaduto funciona como apoio indeslocável para os nós $B$ e $D$.
  - Carregamento vertical e coplanar; peso próprio desprezado frente a $F$.
  - Convenção de sinais: força para cima positiva; *momento fletor positivo
    traciona a fibra inferior*.
]

= Passo 1 — Grau de estaticidade

As incógnitas do problema são apenas as forças normais nas duas barras,
$N_(A B)$ e $N_(C D)$ (ambas verticais). Para um corpo rígido carregado no plano,
com todas as forças verticais, restam *duas* equações úteis de equilíbrio:

$ sum F_y = 0 quad "e" quad sum M = 0 . $

#destaque[
  *Incógnitas = 2  e  equações = 2 $=>$ estrutura isostática.*
  Consequência importante: $N_(A B)$ e $N_(C D)$ — e portanto o DEC e o DMF —
  *não dependem* de $E$, $A$ nem $L$. A elasticidade das barras só influencia os
  *deslocamentos* (Seção 8).
]

= Passo 2 — Diagrama de corpo livre da viga

Isolando a viga $A F$ e substituindo as barras pelas forças que elas aplicam
sobre ela (adotadas positivas para cima, isto é, barras tracionadas):

#align(center)[
  #block(breakable: false, width: 13.0cm, height: 3.2cm, {
    let yb = 1.5cm
    place(dx: 0cm, dy: yb, line(start: (0pt, 0pt), end: (3 * ux, 0pt), stroke: 4pt + black))
    for (x, nome) in ((0cm, "A"), (ux, "C"), (2 * ux, "E"), (3 * ux, "F")) {
      place(dx: x - 3pt, dy: yb - 3pt, circle(radius: 3pt, stroke: 0.7pt + black, fill: white))
      place(dx: x - 4pt, dy: yb + 8pt, text(10pt, weight: "bold")[#nome])
    }
    seta-v(0cm, yb - 4pt, yb - 1.35cm, azul)
    place(dx: 6pt, dy: yb - 1.55cm, text(10.5pt, fill: azul)[$N_(A B)$])
    seta-v(ux, yb - 4pt, yb - 1.35cm, azul)
    place(dx: ux + 6pt, dy: yb - 1.55cm, text(10.5pt, fill: azul)[$N_(C D)$])
    seta-v(2 * ux, yb - 1.35cm, yb - 4pt, verm)
    place(dx: 2 * ux + 6pt, dy: yb - 1.55cm, text(10.5pt, fill: verm)[$F$])
  })
]

Note que a carga $F$ aponta *para baixo*; as forças $N_(A B)$ e $N_(C D)$ foram
arbitradas *para cima* (tração nas barras). O sinal obtido no cálculo dirá o
sentido verdadeiro.

= Passo 3 — Equilíbrio: forças nas barras

*Equação de momentos em $A$* (sentido anti-horário positivo), que elimina
$N_(A B)$:

$ sum M_A = 0: quad N_(C D) dot a - F dot 2a = 0
  quad ==> quad #box(fill: rgb("#eef4fa"), inset: 3pt)[$N_(C D) = + 2 F$] $

*Equação de forças verticais:*

$ sum F_y = 0: quad N_(A B) + N_(C D) - F = 0
  quad ==> quad N_(A B) = F - 2F
  quad ==> quad #box(fill: rgb("#eef4fa"), inset: 3pt)[$N_(A B) = - F$] $

#destaque[
  *Interpretação dos sinais*
  - $N_(C D) = +2F$: sentido igual ao arbitrado (para cima). A barra $C D$ *puxa*
    a viga para cima $=>$ *barra tracionada*.
  - $N_(A B) = -F$: sentido contrário ao arbitrado. A barra $A B$ *empurra* a viga
    para baixo $=>$ *barra comprimida*.

  A barra $A B$ comprimida é o resultado esperado: como a carga está no trecho
  em balanço (à direita de $C$), a viga tende a girar em torno de $C$ e a barra
  $A B$ precisa "segurar" o levantamento da extremidade $A$.
]

*Verificação em $C$:*
$ sum M_C = -N_(A B) dot a - F dot a = -(-F) dot a - F dot a = 0 quad checkmark $

Portanto, as forças externas aplicadas à viga são:

#align(center)[
  #table(
    columns: 4, align: center, inset: 6pt, stroke: 0.5pt + rgb("#c9d8e6"),
    fill: (_, y) => if y == 0 { rgb("#eef4fa") },
    [*Ponto*], [$x$], [*Força na viga*], [*Situação da barra*],
    [$A$], [$0$],  [$F$ para baixo],   [$A B$ comprimida ($N = -F$)],
    [$C$], [$a$],  [$2F$ para cima],   [$C D$ tracionada ($N = +2F$)],
    [$E$], [$2a$], [$F$ para baixo],   [carga da tubulação],
    [$F$], [$3a$], [—],               [extremidade livre],
  )
]

= Passo 4 — Esforço cortante (método das seções)

Adota-se $V(x) = sum F_y^"esq"$ (soma, para cima positiva, das forças à esquerda
da seção). Como só há cargas concentradas, $V$ é constante em cada trecho e sofre
saltos nos pontos de aplicação.

*Trecho $A C$* $(0 < x < a)$ — à esquerda só existe a força $F$ para baixo em $A$:
$ V_(A C) = -F $

*Trecho $C E$* $(a < x < 2a)$ — acrescenta-se $2F$ para cima em $C$:
$ V_(C E) = -F + 2F = +F $

*Trecho $E F$* $(2a < x < 3a)$ — acrescenta-se $F$ para baixo em $E$:
$ V_(E F) = -F + 2F - F = 0 $

O cortante nulo no trecho $E F$ confirma que a extremidade $F$ é um trecho
*descarregado*: nada além de $F$ atua à direita de $E$.

= Passo 5 — Momento fletor (equações por trecho)

$M(x) = sum M^"esq"$, momento das forças à esquerda da seção, positivo quando
traciona a fibra inferior.

*Trecho $A C$* $(0 <= x <= a)$:
$ M_(A C)(x) = -F dot x $
$ M(0) = 0, quad M(a) = -F a $

*Trecho $C E$* $(a <= x <= 2a)$:
$ M_(C E)(x) = -F dot x + 2F dot (x - a) = F x - 2 F a = F (x - 2a) $
$ M(a) = -F a, quad M(2a) = 0 $

*Trecho $E F$* $(2a <= x <= 3a)$:
$ M_(E F)(x) = -F x + 2F (x - a) - F (x - 2a) = 0 $

#destaque[
  *Resultado principal*
  $ M_A = 0, quad #text(fill: verm)[$bold(M_C = - F a)$], quad M_E = 0,
    quad M_F = 0 $
  $ abs(M)_"máx" = F a quad "na seção" C, quad "com" M < 0
    ==> "fibra tracionada é a SUPERIOR." $
]

= Passo 6 — Verificações

*(a) Relação diferencial $ dif M \/ dif x = V$:*

$ "trecho" A C: dif/(dif x)(-F x) = -F = V_(A C) quad checkmark $
$ "trecho" C E: dif/(dif x)(F x - 2 F a) = +F = V_(C E) quad checkmark $
$ "trecho" E F: dif/(dif x)(0) = 0 = V_(E F) quad checkmark $

*(b) Área do DEC = variação de $M$:*

$ M_C - M_A = V_(A C) dot a = -F a quad checkmark
  quad ; quad M_E - M_C = V_(C E) dot a = +F a quad checkmark $

*(c) Extremidade livre:* em $F$ não há carga aplicada além da extremidade, logo
$V_F = 0$ e $M_F = 0$. #h(4pt) $checkmark$

= Passo 7 — Traçado dos diagramas

#figure(
  block(breakable: false, width: 13.4cm, height: 4.6cm, {
    let y0 = 1.9cm            // linha de referência
    let h = 1.0cm
    // trecho A-C: V = -F (abaixo do eixo)
    place(dx: 0cm, dy: y0, rect(width: ux, height: h,
      fill: rgb("#dbe6f0"), stroke: 1.2pt + azul))
    place(dx: ux / 2 - 12pt, dy: y0 + h + 6pt, text(10pt, fill: azul, weight: "bold")[$-F$])
    // trecho C-E: V = +F (acima do eixo)
    place(dx: ux, dy: y0 - h, rect(width: ux, height: h,
      fill: rgb("#dbe6f0"), stroke: 1.2pt + azul))
    place(dx: 1.5 * ux - 12pt, dy: y0 - h - 16pt, text(10pt, fill: azul, weight: "bold")[$+F$])
    // trecho E-F: V = 0
    place(dx: 2.5 * ux - 6pt, dy: y0 - 18pt, text(10pt, fill: azul, weight: "bold")[$0$])
    // eixo
    place(dx: -0.3cm, dy: y0, line(start: (0pt, 0pt), end: (3 * ux + 0.6cm, 0pt), stroke: 1pt + black))
    for (x, nome) in ((0cm, "A"), (ux, "C"), (2 * ux, "E"), (3 * ux, "F")) {
      place(dx: x, dy: y0 - 1.35cm, line(start: (0pt, 0pt), end: (0pt, 1.75cm),
        stroke: (paint: rgb("#c0c0c0"), thickness: 0.5pt, dash: "dotted")))
      place(dx: x - 4pt, dy: y0 + 1.62cm, text(9.5pt, weight: "bold")[#nome])
    }
  }),
  caption: [Diagrama de esforço cortante (DEC).],
)

#figure(
  block(breakable: false, width: 13.4cm, height: 4.4cm, {
    let y0 = 2.9cm            // linha de referência
    let h = 1.6cm
    // DMF traçado do lado tracionado: M negativo desenhado acima do eixo
    place(dx: 0cm, dy: y0, polygon(fill: rgb("#f3dcda"), stroke: 1.4pt + verm,
      (0pt, 0pt), (ux, -h), (2 * ux, 0pt)))
    place(dx: 2 * ux, dy: y0, line(start: (0pt, 0pt), end: (ux, 0pt), stroke: 1.4pt + verm))
    place(dx: ux + 6pt, dy: y0 - h - 6pt, text(10.5pt, fill: verm, weight: "bold")[$M_C = -F a$])
    place(dx: 2.35 * ux, dy: y0 - 20pt, text(9.5pt, fill: cinz)[trecho $E F$: $M = 0$])
    // eixo
    place(dx: -0.3cm, dy: y0, line(start: (0pt, 0pt), end: (3 * ux + 0.6cm, 0pt), stroke: 1pt + black))
    for (x, nome) in ((0cm, "A"), (ux, "C"), (2 * ux, "E"), (3 * ux, "F")) {
      place(dx: x, dy: y0 - h - 0.2cm, line(start: (0pt, 0pt), end: (0pt, h + 0.4cm),
        stroke: (paint: rgb("#c0c0c0"), thickness: 0.5pt, dash: "dotted")))
      place(dx: x - 4pt, dy: y0 + 6pt, text(9.5pt, weight: "bold")[#nome])
    }
    place(dx: 0cm, dy: y0 + 0.7cm,
      text(9pt, fill: cinz, style: "italic")[
        diagrama traçado do lado tracionado $=>$ fibra superior ($M < 0$) em todo o trecho $A E$
      ])
  }),
  caption: [Diagrama de momento fletor (DMF), com $abs(M)_"máx" = F a$ na seção $C$.],
)

#align(center)[
  #table(
    columns: 4, align: center, inset: 6pt, stroke: 0.5pt + rgb("#c9d8e6"),
    fill: (_, y) => if y == 0 { rgb("#eef4fa") },
    [*Trecho*], [*$V$*], [*$M(x)$*], [*Forma do DMF*],
    [$A C$], [$-F$], [$-F x$],     [reta descendente até $-F a$],
    [$C E$], [$+F$], [$F(x - 2a)$], [reta ascendente até $0$],
    [$E F$], [$0$],  [$0$],         [nulo],
  )
]

= Passo 8 — Complemento: deslocamentos (efeito da elasticidade das barras)

Agora sim entram $E$, $A$ e $L$. Como as barras pendem do viaduto (nós $B$ e $D$
fixos), a variação de comprimento $delta = N L \/ (E A)$ desloca a extremidade
*inferior*: barra que alonga faz o ponto da viga *descer*; barra que encurta o
faz *subir*. Tomando o deslocamento vertical positivo para baixo:

$ delta_(C D) = (N_(C D) L)/(E A) = (2 F L)/(E A) quad (C "desce"), quad quad
  delta_(A B) = (N_(A B) L)/(E A) = -(F L)/(E A) quad (A "sobe") $

Considerando a viga rígida frente às barras, a rotação do suporte e o
deslocamento vertical do ponto de apoio da tubulação valem:

$ theta = (delta_(C D) - delta_(A B))/a = (3 F L)/(E A a), quad quad
  v_E = delta_(A B) + 2 (delta_(C D) - delta_(A B)) = (5 F L)/(E A)
  quad (E "desce") $

= Observações de projeto

#destaque[
  - A seção crítica é *$C$*, onde $abs(M) = F a$ e há inversão do
    cortante — é o ponto a verificar no dimensionamento
    ($sigma = M \/ W$, com $W$ o módulo resistente da viga).
  - Como $M < 0$ em todo o trecho $A E$, a *armadura/mesa tracionada fica em
    cima*: em viga de concreto, armadura negativa; em perfil metálico, verificar
    flambagem lateral da mesa comprimida (inferior).
  - A barra $A B$ trabalha à *compressão* ($F$): verificar *flambagem*
    ($N_"cr" = pi^2 E I \/ L^2$), o que normalmente governa seu dimensionamento.
    A barra $C D$ trabalha à *tração* ($2F$): governa o escoamento da seção e as
    ligações dos pinos.
  - O trecho $E F$ não recebe esforço algum — poderia ser suprimido, sendo
    mantido apenas por razões construtivas (folga para montagem da tubulação).
]

= Anexo — Diagramas gerados numericamente

Conferência dos resultados analíticos com o script `dmf_suporte_gasoduto.py`
(mesma convenção de sinais e de traçado):

#figure(
  image("dmf_suporte_gasoduto.png", width: 100%),
  caption: [Saída do script: esquema estático, DEC e DMF.],
)
