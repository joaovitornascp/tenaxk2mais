# Tensões no ponto P de um eixo sob N_x, T_x e M_z

Resolução passo a passo da questão sobre a transmissão por engrenagens
helicoidais: qual é o estado de tensão no cubo representativo do ponto `P`
(base da seção transversal, sobre o eixo `y` negativo).

**Resposta: alternativa (D) — `σx < 0` e `τxz ≠ 0`.**

Resumo do raciocínio:

| Esforço | Tensão que gera em P |
|---|---|
| `N_x` (comprimindo a seção) | `σx = −4|N_x|/(πd²) < 0`, uniforme |
| `M_z` (flexão em torno de z) | `σx = −M_z·y/I_z`; P é fibra extrema (`y = −R`) → `32M_z/(πd³)`, comprimindo a fibra inferior |
| `T_x` (torção) | `τ = T_x·ρ/J`, tangente à circunferência; em P a tangente é a direção `z` → **`τxz = 16T_x/(πd³) ≠ 0`** |

Como P está na superfície livre do eixo, `σy = σz = τyz = 0` e, por estar sobre
o eixo `y`, `τxy = 0`. O estado é plano no plano `x–z`.

| Arquivo | Conteúdo |
|---|---|
| `analise_tensoes_ponto_P.typ` | memorial em Typst (figuras desenhadas nativamente, sem pacotes externos) |
| `analise_tensoes_ponto_P.pdf` | PDF compilado |
| `enunciado.png` | imagem da questão |

```bash
typst compile analise_tensoes_ponto_P.typ    # Typst >= 0.13
```
