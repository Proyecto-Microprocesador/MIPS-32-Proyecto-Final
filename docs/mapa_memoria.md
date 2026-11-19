# Mapa de memoria y direccionamiento (Sprint 2)

## Memoria de Instrucciones
- 256 palabras de 32 bits, se carga de `instrucciones.txt` (una instrucción binaria por línea).
- El PC trabaja en **bytes** (0, 4, 8, ...). La memoria usa `Dir[9:2]`, es decir PC/4.
- Lo que no está en el archivo vale 0, que se interpreta como `nop`.

## Banco de Registros
- 32 registros de 32 bits. Lectura combinacional, escritura en flanco de subida con `RegWrite = 1`.
- `$0` siempre vale 0 aunque se intente escribir en él.

## Memoria de Datos
- 256 palabras de 32 bits, se carga de `datos.txt`.
- Se direcciona **por palabra**: dirección = `$rs + offset`, igual que el ejemplo de las diapositivas 26 y 27
  (por ejemplo `lw $t, 0($15)` con `$15 = 20` lee el dato de la dirección 20 = 500).
- Si el maestro quiere direccionamiento por byte, se cambia `Direccion[7:0]` por `Direccion[9:2]` en `MemoriaDatos.v`.

## Programa de prueba actual (`programas/instrucciones.txt`)

| PC | Instrucción | Qué comprueba |
|---|---|---|
| 0  | `addi $t0, $zero, 5`  | inmediato positivo |
| 4  | `addi $t1, $zero, 3`  | |
| 8  | `add  $t2, $t0, $t1`  | tipo R, $t2 = 8 |
| 12 | `sub  $t3, $t0, $t1`  | $t3 = 2 |
| 16 | `sw   $t2, 20($zero)` | escritura en memoria de datos |
| 20 | `lw   $t4, 20($zero)` | lectura, $t4 = 8 |
| 24 | `slt  $t5, $t1, $t0`  | $t5 = 1 |
| 28 | `beq  $t2, $t4, 1`    | iguales: salta la instrucción siguiente |
| 32 | `addi $t6, $zero, 99` | NO debe ejecutarse |
| 36 | `nop`                 | |
| 40 | `j    0`              | regresa al inicio |
