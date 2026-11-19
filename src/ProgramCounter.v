`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////
// Program Counter (PC)
// Registro de 32 bits que guarda la direccion de la instruccion actual.
// Se actualiza en cada flanco de subida del reloj con PC_in.
// rst = 1 regresa el PC a 0 (se agrego para poder iniciar la simulacion).
//////////////////////////////////////////////////////////////////////////////
module ProgramCounter(
	input             CLK,
	input             rst,
	input      [31:0] PC_in,     // siguiente direccion (viene de Mux5)
	output reg [31:0] PC_out     // direccion actual
);

initial
begin
	PC_out = 32'd0;
end

always @(posedge CLK)
begin
	if (rst)
		PC_out <= 32'd0;
	else
		PC_out <= PC_in;
end

endmodule
