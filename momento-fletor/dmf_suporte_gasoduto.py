"""
Suporte de gasoduto sob viaduto - esforcos internos na viga AF.

Geometria (viga horizontal, sustentada pelas barras elasticas AB e CD):
    A (x=0) --- a --- C (x=a) --- a --- E (x=2a) --- a --- F (x=3a)

Carregamento: forca F (vertical, para baixo) aplicada pela tubulacao em E.
Barras AB e CD: bielas verticais rotuladas nas duas extremidades (elementos
de dois nos), area A e comprimento L.

Como ha apenas duas incognitas (N_AB, N_CD) e duas equacoes uteis de
equilibrio, a viga e ISOSTATICA: as reacoes nao dependem de E, A ou L.

    Sum M_A = 0 :  N_CD * a - F * 2a = 0   ->  N_CD = +2F  (tracao)
    Sum Fy  = 0 :  N_AB + N_CD - F  = 0    ->  N_AB = -F   (compressao)

Convencao adotada: momento positivo traciona a fibra inferior. O DMF e
tracado do lado tracionado (padrao brasileiro) - por isso o eixo M e
invertido no grafico.
"""

import os

import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

# ----------------------------------------------------------------- dados
F = 1.0   # forca da tubulacao (resultados saem em multiplos de F)
a = 1.0   # vao entre pontos (resultados saem em multiplos de a)

xA, xC, xE, xF = 0.0, a, 2 * a, 3 * a

# --------------------------------------------------------- forcas nas barras
N_CD = 2 * F    # tracao: a barra CD "puxa" a viga para cima em C
N_AB = -F       # compressao: a barra AB "empurra" a viga para baixo em A

# ------------------------------------------------- esforco cortante e momento
def V(x):
    """Cortante: soma das forcas verticais a esquerda da secao (para cima +)."""
    x = np.asarray(x, dtype=float)
    return N_AB * (x > xA) + N_CD * (x > xC) - F * (x > xE)


def M(x):
    """Momento fletor: positivo traciona a fibra inferior."""
    x = np.asarray(x, dtype=float)
    return (N_AB * np.clip(x - xA, 0, None)
            + N_CD * np.clip(x - xC, 0, None)
            - F * np.clip(x - xE, 0, None))


# amostragem com pontos duplicados nas descontinuidades do cortante
eps = 1e-9
x = np.unique(np.concatenate([
    np.linspace(0, 3 * a, 601),
    [xA, xA + eps, xC - eps, xC + eps, xE - eps, xE + eps, xF],
]))
Vx, Mx = V(x), M(x)

print("Forcas normais nas barras")
print(f"  N_AB = {N_AB:+.2f} F  (compressao)")
print(f"  N_CD = {N_CD:+.2f} F  (tracao)")
print("\nEsforco cortante")
print("  A-C: -F   |   C-E: +F   |   E-F: 0")
print("\nMomento fletor nos pontos notaveis")
for nome, xi in (("A", xA), ("C", xC), ("E", xE), ("F", xF)):
    print(f"  M({nome}) = {float(M(xi)):+.2f} F.a")
print(f"\n|M|max = {np.abs(Mx).max():.2f} F.a na secao C (tracao na fibra superior)")

# ------------------------------------------------------------------ grafico
fig, (ax0, ax1, ax2) = plt.subplots(
    3, 1, figsize=(10.0, 9.6), sharex=True,
    gridspec_kw={"height_ratios": [1.15, 0.95, 1.25], "hspace": 0.32},
)
AZ, VM, CZ = "#1f4e79", "#b3261e", "#9a9a9a"

# --- (1) esquema estatico ---------------------------------------------------
ax0.plot([-0.35, 3 * a + 0.35], [1.20, 1.20], lw=4, color="#404040")
ax0.text(3 * a + 0.30, 1.34, "viaduto", ha="right", fontsize=10, color="#555")
for xi, nome in ((xA, "AB"), (xC, "CD")):
    ax0.plot([xi, xi], [0, 1.20], lw=2.5, color=CZ, zorder=1)
    ax0.text(xi - 0.09, 0.95, nome, ha="right", va="center", fontsize=10, color="#666")
ax0.plot([0, 3 * a], [0, 0], lw=7, color="#404040", solid_capstyle="round", zorder=3)
for xi, nome, dx in ((xA, "A", -0.13), (xC, "C", -0.13), (xE, "E", 0.13), (xF, "F", 0.0)):
    ax0.plot(xi, 0, "o", ms=8, mfc="white", mec="#404040", mew=1.8, zorder=4)
    ax0.text(xi + dx, -0.13, nome, ha="center", va="top", fontsize=12, fontweight="bold")

# carga da tubulacao em E
ax0.annotate("", xy=(xE, 0.07), xytext=(xE, 1.00),
             arrowprops=dict(arrowstyle="-|>", lw=2.6, color=VM))
ax0.text(xE - 0.09, 0.62, "F", color=VM, fontsize=14, fontweight="bold", ha="right")
# forcas que as barras aplicam na viga
ax0.annotate("", xy=(xA, -0.78), xytext=(xA, -0.05),
             arrowprops=dict(arrowstyle="-|>", lw=2.6, color=AZ))
ax0.text(xA + 0.10, -0.48, "F ↓  (compressão em AB)", color=AZ, fontsize=11, va="center")
ax0.annotate("", xy=(xC, 0.80), xytext=(xC, 0.05),
             arrowprops=dict(arrowstyle="-|>", lw=2.6, color=AZ))
ax0.text(xC + 0.10, 0.32, "2F ↑  (tração em CD)", color=AZ, fontsize=11, va="center")
# cotas
for x0, x1 in ((xA, xC), (xC, xE), (xE, xF)):
    ax0.annotate("", xy=(x0, -1.05), xytext=(x1, -1.05),
                 arrowprops=dict(arrowstyle="<|-|>", lw=1.1, color="#666"))
    ax0.text((x0 + x1) / 2, -1.18, "a", ha="center", va="top", fontsize=11, color="#444")
ax0.set_ylim(-1.60, 1.60)
ax0.set_title("Esquema estático da viga AF (isostática)", fontsize=12.5, fontweight="bold")
ax0.axis("off")

# --- (2) diagrama de esforco cortante (DEC) --------------------------------
ax1.fill_between(x, 0, Vx, color=AZ, alpha=0.20)
ax1.plot(x, Vx, color=AZ, lw=2.3)
ax1.axhline(0, color="k", lw=1.2)
ax1.text(0.5 * a, -1.32, "−F", ha="center", fontsize=12, color=AZ, fontweight="bold")
ax1.text(1.5 * a, 1.32, "+F", ha="center", fontsize=12, color=AZ, fontweight="bold")
ax1.text(2.5 * a, 0.30, "0", ha="center", fontsize=12, color=AZ, fontweight="bold")
ax1.set_ylabel("V", fontsize=13, fontweight="bold")
ax1.set_ylim(-1.85, 1.85)
ax1.set_yticks([-1, 0, 1])
ax1.set_yticklabels(["−F", "0", "+F"], fontsize=10)
ax1.set_title("Diagrama de esforço cortante (DEC)", fontsize=12)
ax1.grid(axis="y", ls=":", alpha=0.5)

# --- (3) diagrama de momento fletor (DMF) ----------------------------------
ax2.fill_between(x, 0, Mx, color=VM, alpha=0.20)
ax2.plot(x, Mx, color=VM, lw=2.5)
ax2.axhline(0, color="k", lw=1.2)
ax2.plot(xC, float(M(xC)), "o", ms=7, color=VM, zorder=5)
ax2.set_ylim(0.52, -1.30)                 # eixo invertido: DMF do lado tracionado
ax2.annotate(r"$M_C = -F\,a$   (máximo em módulo)",
             xy=(xC, float(M(xC))), xytext=(xC + 0.16, -0.86),
             fontsize=12.5, color=VM, fontweight="bold", va="center",
             arrowprops=dict(arrowstyle="-", lw=1.2, color=VM))
ax2.text(0.02, 0.16, "$M_A = 0$", fontsize=10.5, color="#444", va="top")
ax2.text(2.5 * a, 0.16, "trecho EF descarregado:  $M = 0$",
         ha="center", fontsize=10.5, color="#444", va="top")
ax2.text(1.5 * a, 0.44, "diagrama traçado do lado tracionado → fibra superior (M < 0)",
         ha="center", fontsize=10.5, color="#444", style="italic", va="bottom")
ax2.set_ylabel("M", fontsize=13, fontweight="bold")
ax2.set_yticks([0, -0.5, -1.0])
ax2.set_yticklabels(["0", "−0,5 F·a", "−F·a"], fontsize=10)
ax2.set_xlabel("posição ao longo da viga", fontsize=11)
ax2.set_title("Diagrama de momento fletor (DMF)", fontsize=12)
ax2.grid(axis="y", ls=":", alpha=0.5)

for ax in (ax1, ax2):
    for xi in (xA, xC, xE, xF):
        ax.axvline(xi, color="#c4c4c4", ls=":", lw=1)
ax2.set_xlim(-0.42, 3 * a + 0.42)
ax2.set_xticks([xA, xC, xE, xF])
ax2.set_xticklabels(["A\n0", "C\na", "E\n2a", "F\n3a"], fontsize=11)

fig.suptitle("Suporte da tubulação do gasoduto — esforços internos na viga AF",
             fontsize=14.5, fontweight="bold", y=0.985)
fig.subplots_adjust(top=0.92, bottom=0.08, left=0.10, right=0.97)
out = os.path.join(os.path.dirname(os.path.abspath(__file__)), "dmf_suporte_gasoduto.png")
fig.savefig(out, dpi=170)
print(f"\nFigura salva em: {out}")
