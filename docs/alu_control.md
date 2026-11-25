# ALU y ALU Control (Sprint 3)

## Señal ALUOp (3 bits)
La diapositiva 23 usa ALUOp de 2 bits (lw/sw, beq y tipo R), pero nuestro set también tiene
`addi`, `andi`, `ori` y `slti`, que necesitan otras operaciones. Por eso ALUOp pasa a **3 bits**
(el datapath de la diapositiva 17 también dibuja ALUOp con 3 bits).

| ALUOp | Instrucciones | Acción de la ALU | ALUctl |
|---|---|---|---|
| 000 | lw, sw, addi | suma | 0010 |
| 001 | beq, bne, bgtz | resta | 0110 |
| 010 | tipo R | según `funct` | ver abajo |
| 011 | andi | AND | 0000 |
| 100 | ori | OR | 0001 |
| 101 | slti | slt | 0111 |

## Tipo R (ALUOp = 010)

| funct | Instrucción | ALUctl |
|---|---|---|
| 100000 | add | 0010 |
| 100010 | sub | 0110 |
| 100100 | and | 0000 |
| 100101 | or  | 0001 |
| 100111 | nor | 1100 |
| 101010 | slt | 0111 |
| otro (000000 = nop) | – | 0000 |

## Cambios a la `MIPSALU` hecha en clase
1. `slt` ahora compara **con signo** (`$signed`). Con la versión de clase, `-3 < 2` daba 0 porque
   comparaba como números sin signo, y `slti` fallaría con inmediatos negativos.
2. Dentro del `always @*` se cambió `<=` por `=` (es lógica combinacional).

## Limitación conocida
El datapath solo tiene extensor de **signo**. `andi` y `ori` se probarán con inmediatos entre 0 y 32767;
con valores mayores el inmediato se extendería con unos y el resultado no sería el de MIPS real.

## Pendiente para el Sprint 4 (Unidad de Control)
- `beq`: toma el salto si `Zero = 1`.
- `bne`: toma el salto si `Zero = 0`.
- `bgtz`: `rt` vale 0, así que la ALU calcula `rs - 0`; se toma el salto si `Zero = 0` y `ALUOut[31] = 0`
  (distinto de cero y no negativo).
