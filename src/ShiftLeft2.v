`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////
// Shift Left 2 (para branch)
// Multiplica por 4 el offset (las instrucciones ocupan 4 bytes).
// Entra el inmediato ya extendido a 32 bits y sale desplazado 2 bits.
//////////////////////////////////////////////////////////////////////////////
module ShiftLeft2(
	input  [31:0] in,
	output [31:0] out
);

assign out = {in[29:0], 2'b00};

endmodule
