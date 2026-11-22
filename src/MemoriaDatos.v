`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////
// Memoria de Datos (RAM)
//  - 256 palabras de 32 bits, se llena al inicio con $readmemb desde FILE
//  - Se direcciona por PALABRA: Direccion = $RS + offset, tal como en el
//    ejemplo de las diapositivas 26 y 27 (dato en la direccion 20, 21, 22...)
//  - Escritura (sw): en el flanco de subida de CLK si MemWrite = 1
//  - Lectura (lw): combinacional si MemRead = 1; si MemRead = 0 sale 0
//////////////////////////////////////////////////////////////////////////////
module MemoriaDatos #(
	parameter FILE = "datos.txt"
)(
	input         CLK,
	input         MemWrite,
	input         MemRead,
	input  [31:0] Direccion,      // Adress_In
	input  [31:0] DatoEscritura,  // Data_In
	output [31:0] DatoLectura
);

reg [31:0] mem [0:255];
integer i;

assign DatoLectura = MemRead ? mem[Direccion[7:0]] : 32'd0;

initial
begin
	for (i = 0; i < 256; i = i + 1)
		mem[i] = 32'd0;
	$readmemb(FILE, mem);
end

always @(posedge CLK)
begin
	if (MemWrite)
		mem[Direccion[7:0]] <= DatoEscritura;
end

endmodule
