`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////
// Sumador
// Se usa 2 veces en el datapath:
//   1) PC + 4                       (siguiente instruccion)
//   2) (PC + 4) + offset desplazado (direccion de salto en beq/bne/bgtz)
// El parametro N permite reutilizarlo con otros anchos (por defecto 32 bits)
//////////////////////////////////////////////////////////////////////////////
module Sumador #(
	parameter N = 32
)(
	input  [N-1:0] A,
	input  [N-1:0] B,
	output [N-1:0] Suma
);

assign Suma = A + B;

endmodule
