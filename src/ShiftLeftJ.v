`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////
// Shift Left 2 (para jump)
// Es el bloque "Shift Left" del datapath completo: toma el campo index
// de 26 bits [25:0] y lo convierte a 28 bits agregando "00" al final.
// Despues se concatena con PC+4[31:28] para formar la direccion de salto.
//////////////////////////////////////////////////////////////////////////////
module ShiftLeftJ(
	input  [25:0] in,
	output [27:0] out
);

assign out = {in, 2'b00};

endmodule
