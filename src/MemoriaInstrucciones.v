`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////
// Memoria de Instrucciones (ROM)
// Basada en ROM_Instrucciones de clase, ahora con instrucciones de 32 bits.
//  - 256 palabras de 32 bits
//  - Se llena con $readmemb desde el archivo FILE (una instruccion por linea)
//  - Dir es la direccion en BYTES (la que entrega el PC). Como cada instruccion
//    ocupa 4 bytes se usa Dir[9:2] para elegir la palabra (PC=8 -> palabra 2).
//  - Las posiciones que el archivo no llena quedan en 0 (= nop)
//////////////////////////////////////////////////////////////////////////////
module MemoriaInstrucciones #(
	parameter FILE = "instrucciones.txt"
)(
	input  [31:0] Dir,
	output [31:0] Instruccion
);

reg [31:0] mem [0:255];
integer i;

assign Instruccion = mem[Dir[9:2]];

initial
begin
	for (i = 0; i < 256; i = i + 1)
		mem[i] = 32'd0;
	$readmemb(FILE, mem);
end

endmodule
