# Microprocesador MIPS de 32 bits (monociclo)

Proyecto final de **Seminario de Solución de Problemas de Arquitectura de Computadoras**
Universidad de Guadalajara – CUCEI – División de Electrónica y Computación

## Equipo

| Integrante | Rol |
|---|---|
| Integrante 1 (Hector Manuel Rios Avalos) | Líder / README / integración (módulo top) |
| Integrante 2 () | Memorias y Banco de Registros |
| Integrante 3 () | ALU, ALU Control, extensor de signo y desplazadores |
| Integrante 4 (Sibilina Alejandra Julian Ramirez) | Unidad de Control y testbenches de integración |

## Descripción

Microprocesador MIPS de 32 bits de **un solo ciclo** (monociclo) descrito en Verilog y
simulado en ModelSim. Cada bloque del datapath es un módulo independiente con su propio
testbench; al final se conectan todos en el módulo `MIPS_Top`.

## Estructura del repositorio

```
├── README.md
├── src/          módulos Verilog (.v)
├── tb/           testbenches (nombre_tb.v)
├── docs/         tabla de instrucciones, diagramas
└── programas/    programas de prueba para el procesador
```

## Instrucciones soportadas

R: `add`, `sub`, `and`, `or`, `nor`, `slt`
I: `lw`, `sw`, `addi`, `andi`, `ori`, `slti`, `beq`, `bne`, `bgtz`
J: `j`
Especial: `nop`

Detalle de formatos, opcodes y sintaxis en [`docs/tabla_instrucciones.md`](docs/tabla_instrucciones.md).

## Avance por sprint

- [x] **Sprint 1** – Organización del repo y módulos básicos: `ProgramCounter`, `Sumador`, `Mux2a1`, `ExtensorSigno`, `ShiftLeft2`, `ShiftLeftJ`
- [x] **Sprint 2** – Memoria de Instrucciones, Banco de Registros, Memoria de Datos
- [ ] **Sprint 3** – ALU y ALU Control
- [ ] **Sprint 4** – Unidad de Control
- [ ] **Sprint 5** – Integración (`MIPS_Top`), programa de prueba y documentación final

## Cómo simular en ModelSim

1. Crear un proyecto nuevo y agregar los archivos de `src/` y el testbench que se quiere probar (`tb/`).
2. Compilar todo (`Compile > Compile All`).
3. `Simulate > Start Simulation`, elegir el testbench (por ejemplo `work.Sumador_tb`) y dar **Run -All**.
4. En la consola debe aparecer `TODO PASS` al final. Si aparece `FAIL`, la línea indica qué caso falló.

Todos los testbenches siguen el mismo formato: tarea `chequea(...)`, mensajes `PASS`/`FAIL`
y un resumen final con el número de errores.
