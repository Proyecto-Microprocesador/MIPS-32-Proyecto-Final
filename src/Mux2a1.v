`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////
// Multiplexor 2 a 1 con ancho parametrizable
// Sel = 0 -> Y = D0      Sel = 1 -> Y = D1
// En el datapath se usa:
//   Mux2 (RegDst)   con N = 5   (elige el registro destino rt o rd)
//   Mux3 (ALUSrc)   con N = 32  (elige DR2 o el inmediato extendido)
//   Mux1 (MemtoReg) con N = 32  (elige resultado ALU o dato de memoria)
//   Mux4 / Mux5     con N = 32  (branch y jump)
//////////////////////////////////////////////////////////////////////////////
module Mux2a1 #(
	parameter N = 32
)(
	input  [N-1:0] D0,
	input  [N-1:0] D1,
	input          Sel,
	output [N-1:0] Y
);

assign Y = Sel ? D1 : D0;

endmodule
