`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////
// ALU de 32 bits (MIPSALU) - reutilizada del trabajo de clase
// ALUctl (4 bits) -> operacion:
//   0000 AND   0001 OR   0010 suma   0110 resta   0111 slt   1100 NOR
// Zero = 1 cuando el resultado es 0 (bandera zf del datapath, usada en beq/bne)
//
// Cambios respecto a la version de clase:
//  1) slt ahora compara CON SIGNO ($signed), para que slti funcione con
//     numeros negativos (ejemplo: -3 < 2 debe dar 1).
//  2) Se usa "=" (bloqueante) dentro del always @* porque es logica combinacional.
//////////////////////////////////////////////////////////////////////////////
module MIPSALU(
	input  [3:0]      ALUctl,
	input  [31:0]     A,
	input  [31:0]     B,
	output reg [31:0] ALUOut,
	output            Zero
);

assign Zero = (ALUOut == 32'd0);

always @*
begin
	case (ALUctl)
		4'd0:    ALUOut = A & B;
		4'd1:    ALUOut = A | B;
		4'd2:    ALUOut = A + B;
		4'd6:    ALUOut = A - B;
		4'd7:    ALUOut = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0;
		4'd12:   ALUOut = ~(A | B);
		default: ALUOut = 32'd0;
	endcase
end

endmodule
