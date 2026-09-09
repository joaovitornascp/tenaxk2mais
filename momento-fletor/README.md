# Suporte do gasoduto — DEC e DMF da viga AF

Estrutura: viga horizontal `AF` pendurada no viaduto por duas barras elásticas
verticais `AB` e `CD` (rotuladas nas duas extremidades, área `A`, comprimento `L`).
A tubulação aplica a força `F`, vertical para baixo, no ponto `E`.

```
A(0) --- a --- C(a) --- a --- E(2a) --- a --- F(3a)
```

## 1. Grau de hiperestaticidade

As barras são elementos de dois nós (só transmitem força axial), logo há duas
incógnitas: `N_AB` e `N_CD`. Para carregamento no plano restam duas equações
úteis (`ΣFy = 0` e `ΣM = 0`). **Sistema isostático** — as forças não dependem
de `E`, `A` nem `L`; a rigidez das barras só influencia os deslocamentos.

## 2. Equilíbrio da viga

```
ΣM_A = 0 :  N_CD · a − F · 2a = 0     →  N_CD = +2F   (tração)
ΣFy  = 0 :  N_AB + N_CD − F = 0       →  N_AB = −F    (compressão)
```

Forças aplicadas na viga: `F ↓` em A, `2F ↑` em C, `F ↓` em E.

## 3. Esforço cortante (V positivo = resultante das forças à esquerda para cima)

| Trecho | V |
|--------|---|
| A–C | −F |
| C–E | +F |
| E–F | 0 |

## 4. Momento fletor (positivo traciona a fibra inferior)

| Trecho | M(x) |
|--------|------|
| A–C (0 ≤ x ≤ a) | `M = −F·x` |
| C–E (a ≤ x ≤ 2a) | `M = −F·x + 2F(x − a) = F·x − 2F·a` |
| E–F (2a ≤ x ≤ 3a) | `M = 0` |

Valores notáveis: `M_A = 0`, **`M_C = −F·a`**, `M_E = 0`, `M_F = 0`.

O diagrama é triangular, com máximo em módulo `|M|max = F·a` na seção C, sempre
negativo — **fibra tracionada é a superior** — e nulo no balanço EF.

## 5. Deslocamentos (efeito das barras elásticas)

Encurtamento/alongamento das barras (`δ = N·L / (E·A)`):

```
δ_A = −F·L/(E·A)   (desce)      δ_C = +2F·L/(E·A)   (sobe)
```

Considerando a viga rígida, a rotação do suporte é
`θ = (δ_C − δ_A)/a = 3F·L/(E·A·a)` e o deslocamento vertical em E vale
`v_E = δ_A + 2(δ_C − δ_A) = 5F·L/(E·A)` (para cima).

## Como reproduzir

```bash
pip install matplotlib numpy
python3 dmf_suporte_gasoduto.py    # imprime os valores e gera dmf_suporte_gasoduto.png
```
