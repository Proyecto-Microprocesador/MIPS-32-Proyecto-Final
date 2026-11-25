`timescale 1ns/1ps

module ALUControl(
	input      [2:0] ALUOp,
	input      [5:0] funct,
	output reg [3:0] ALUctl
);

always @*
begin
	case (ALUOp)
		3'b000: ALUctl = 4'b0010;          // suma
		3'b001: ALUctl = 4'b0110;          // resta
		3'b010:                            // tipo R: se decide con funct
			case (funct)
				6'b100000: ALUctl = 4'b0010;   // add
				6'b100010: ALUctl = 4'b0110;   // sub
				6'b100100: ALUctl = 4'b0000;   // and
				6'b100101: ALUctl = 4'b0001;   // or
				6'b100111: ALUctl = 4'b1100;   // nor
				6'b101010: ALUctl = 4'b0111;   // slt
				default:   ALUctl = 4'b0000;
			endcase
		3'b011: ALUctl = 4'b0000;          // andi
		3'b100: ALUctl = 4'b0001;          // ori
		3'b101: ALUctl = 4'b0111;          // slti
		default: ALUctl = 4'b0000;
	endcase
end

endmodule

