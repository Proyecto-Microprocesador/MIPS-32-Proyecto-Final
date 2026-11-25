`timescale 1ns/1ps
// Mini integracion del Sprint 3: ALU Control + ALU conectadas como en el datapath
//   ALUOp, funct --> ALUControl --> ALUctl --> MIPSALU --> resultado
module ALU_ALUControl_tb;

reg  [2:0]  ALUOp;
reg  [5:0]  funct;
reg  [31:0] A, B;
wire [3:0]  ALUctl;
wire [31:0] ALUOut;
wire        Zero;

ALUControl ctl(.ALUOp(ALUOp), .funct(funct), .ALUctl(ALUctl));
MIPSALU    alu(.ALUctl(ALUctl), .A(A), .B(B), .ALUOut(ALUOut), .Zero(Zero));

integer errores = 0, total = 0;

task chequea(input [2:0] op, input [5:0] f, input [31:0] x, input [31:0] y,
             input [31:0] esp, input espZero, input [255:0] nombre);
	begin
		ALUOp = op; funct = f; A = x; B = y; #10;
		total = total + 1;
		if (ALUOut === esp && Zero === espZero)
			$display("PASS %0s | A=%0d B=%0d | Out=%0d Zero=%b", nombre, $signed(A), $signed(B), $signed(ALUOut), Zero);
		else begin
			$display("FAIL %0s | A=%0d B=%0d | Out=%0d Zero=%b (esp %0d, %b)", nombre, $signed(A), $signed(B), $signed(ALUOut), Zero, $signed(esp), espZero);
			errores = errores + 1;
		end
	end
endtask

initial begin
	$dumpfile("ALU_ALUControl_tb.vcd"); $dumpvars(0, ALU_ALUControl_tb);

	// instrucciones del programa de prueba del Sprint 2
	chequea(3'b000, 6'd0,      32'd0, 32'd5,  32'd5,  0, "addi $t0,$zero,5   ");
	chequea(3'b010, 6'b100000, 32'd5, 32'd3,  32'd8,  0, "add  $t2,$t0,$t1   ");
	chequea(3'b010, 6'b100010, 32'd5, 32'd3,  32'd2,  0, "sub  $t3,$t0,$t1   ");
	chequea(3'b000, 6'd0,      32'd0, 32'd20, 32'd20, 0, "sw/lw direccion 20 ");
	chequea(3'b010, 6'b101010, 32'd3, 32'd5,  32'd1,  0, "slt  $t5,$t1,$t0   ");
	chequea(3'b001, 6'd0,      32'd8, 32'd8,  32'd0,  1, "beq  iguales Zero=1");
	chequea(3'b001, 6'd0,      32'd8, 32'd7,  32'd1,  0, "bne  distintos     ");

	// el resto del set
	chequea(3'b010, 6'b100100, 32'd12, 32'd10, 32'd8,  0, "and                ");
	chequea(3'b010, 6'b100101, 32'd12, 32'd10, 32'd14, 0, "or                 ");
	chequea(3'b010, 6'b100111, 32'd0,  32'd0, 32'hFFFFFFFF, 0, "nor                ");
	chequea(3'b011, 6'd0,      32'd15, 32'd6,  32'd6,  0, "andi 15 & 6        ");
	chequea(3'b100, 6'd0,      32'd8,  32'd3,  32'd11, 0, "ori  8 | 3         ");
	chequea(3'b101, 6'd0,      -32'sd4, 32'd1, 32'd1,  0, "slti -4 < 1        ");
	chequea(3'b101, 6'd0,      32'd9,  32'd1,  32'd0,  1, "slti  9 < 1        ");
	chequea(3'b001, 6'd0,      32'd7,  32'd0,  32'd7,  0, "bgtz rs=7 (rs-0)   ");

	$display("---- ALU_ALUControl_tb: %0d casos, %0d errores -> %0s", total, errores, errores==0 ? "TODO PASS" : "HAY FAIL");
	$finish;
end

endmodule
