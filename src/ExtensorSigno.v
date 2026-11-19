`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////
// Extensor de signo (Sign Ext)
// Convierte el inmediato de 16 bits [15:0] de las instrucciones tipo I
// a 32 bits, repitiendo el bit de signo (bit 15) en los 16 bits superiores.
//   0x0005 -> 0x00000005      0xFFFB (-5) -> 0xFFFFFFFB
//////////////////////////////////////////////////////////////////////////////
module ExtensorSigno(
	input  [15:0] in,
	output [31:0] out
);

assign out = {{16{in[15]}}, in};

endmodule
