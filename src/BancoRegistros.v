`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////
// Banco de Registros (32 registros de 32 bits)
// Puertos segun el datapath:  AR1, AR2 (direcciones de lectura), AW (direccion
// de escritura), DW (dato a escribir), DR1, DR2 (datos leidos).
//  - Lectura: combinacional (cambia en cuanto cambia AR1 o AR2)
//  - Escritura: en el flanco de subida de CLK solo si RegWrite = 1
//  - El registro $0 siempre vale 0 y no se puede modificar
//////////////////////////////////////////////////////////////////////////////
module BancoRegistros(
	input         CLK,
	input         RegWrite,       // habilita escritura (en_BR)
	input  [4:0]  AR1,
	input  [4:0]  AR2,
	input  [4:0]  AW,
	input  [31:0] DW,
	output [31:0] DR1,
	output [31:0] DR2
);

reg [31:0] banco [0:31];
integer i;

assign DR1 = (AR1 == 5'd0) ? 32'd0 : banco[AR1];
assign DR2 = (AR2 == 5'd0) ? 32'd0 : banco[AR2];

initial
begin
	for (i = 0; i < 32; i = i + 1)
		banco[i] = 32'd0;
end

always @(posedge CLK)
begin
	if (RegWrite && AW != 5'd0)
		banco[AW] <= DW;
end

endmodule
