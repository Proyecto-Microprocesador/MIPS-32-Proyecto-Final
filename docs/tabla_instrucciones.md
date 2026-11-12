# Set de instrucciones (completa la diapositiva 25)

## Formatos

| Tipo | 31-26  | 25-21      | 20-16  | 15-11                   | 10-6      | 5-0       |
| ---- | ------ | ---------- | ------ | ----------------------- | --------- | --------- |
| R    | op (6) | rs (5)     | rt (5) | rd (5)                  | shamt (5) | funct (6) |
| I    | op (6) | rs (5)     | rt (5) | inmediato / offset (16) |           |           |
| J    | op (6) | index (26) |        |                         |           |           |

## Instrucciones

| Instrucción | Tipo | Sintaxis               | op     | funct  | Operación                          |
| ----------- | ---- | ---------------------- | ------ | ------ | ---------------------------------- |
| add         | R    | `add $rd, $rs, $rt`    | 000000 | 100000 | rd = rs + rt                       |
| sub         | R    | `sub $rd, $rs, $rt`    | 000000 | 100010 | rd = rs - rt                       |
| and         | R    | `and $rd, $rs, $rt`    | 000000 | 100100 | rd = rs & rt                       |
| or          | R    | `or $rd, $rs, $rt`     | 000000 | 100101 | rd = rs \| rt                      |
| nor         | R    | `nor $rd, $rs, $rt`    | 000000 | 100111 | rd = ~(rs \| rt)                   |
| slt         | R    | `slt $rd, $rs, $rt`    | 000000 | 101010 | rd = (rs < rt) ? 1 : 0             |
| lw          | I    | `lw $rt, offset($rs)`  | 100011 | –      | rt = Mem[rs + offset]              |
| sw          | I    | `sw $rt, offset($rs)`  | 101011 | –      | Mem[rs + offset] = rt              |
| addi        | I    | `addi $rt, $rs, imm`   | 001000 | –      | rt = rs + imm                      |
| andi        | I    | `andi $rt, $rs, imm`   | 001100 | –      | rt = rs & imm                      |
| ori         | I    | `ori $rt, $rs, imm`    | 001101 | –      | rt = rs \| imm                     |
| slti        | I    | `slti $rt, $rs, imm`   | 001010 | –      | rt = (rs < imm) ? 1 : 0            |
| beq         | I    | `beq $rs, $rt, offset` | 000100 | –      | si rs == rt: PC = PC+4 + offset\*4 |
| bne         | I    | `bne $rs, $rt, offset` | 000101 | –      | si rs != rt: PC = PC+4 + offset\*4 |
| bgtz        | I    | `bgtz $rs, offset`     | 000111 | –      | si rs > 0: PC = PC+4 + offset\*4   |
| j           | J    | `j etiqueta`           | 000010 | –      | PC = {PC+4[31:28], index, 00}      |
| nop         | R    | `nop`                  | 000000 | 000000 | no hace nada (palabra 0x00000000)  |

## Códigos de la ALU (reutilizamos `MIPSALU` de clase, control de 4 bits)

| ALUctl | Operación |
| ------ | --------- |
| 0000   | AND       |
| 0001   | OR        |
| 0010   | suma      |
| 0110   | resta     |
| 0111   | slt       |
| 1100   | NOR       |
