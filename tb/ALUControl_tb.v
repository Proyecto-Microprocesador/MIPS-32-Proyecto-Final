`timescale 1ns/1ps

module ALUControl_tb;

reg  [2:0] ALUOp;
reg  [5:0] funct;
wire [3:0] ALUctl;

ALUControl uut(.ALUOp(ALUOp), .funct(funct), .ALUctl(ALUctl));

integer errores = 0, total = 0;

task chequea(input [2:0] op, input [5:0] f, input [3:0] esp, input [255:0] nombre);
	begin
		ALUOp = op; funct = f; #10;
		total = total + 1;
		if (ALUctl === esp)
			$display("PASS %0s | ALUOp=%b funct=%b | ALUctl=%b", nombre, ALUOp, funct, ALUctl);
		else begin
			$display("FAIL %0s | ALUOp=%b funct=%b | ALUctl=%b (esp %b)", nombre, ALUOp, funct, ALUctl, esp);
			errores = errores + 1;
		end
	end
endtask

initial begin
	$dumpfile("ALUControl_tb.vcd"); $dumpvars(0, ALUControl_tb);

	// ALUOp fijo (el funct no importa)
	chequea(3'b000, 6'bxxxxxx, 4'b0010, "lw/sw/addi -> suma  ");
	chequea(3'b000, 6'b101010, 4'b0010, "addi ignora funct   ");
	chequea(3'b001, 6'bxxxxxx, 4'b0110, "beq/bne/bgtz -> rest");
	chequea(3'b011, 6'bxxxxxx, 4'b0000, "andi -> AND         ");
	chequea(3'b100, 6'bxxxxxx, 4'b0001, "ori  -> OR          ");
	chequea(3'b101, 6'bxxxxxx, 4'b0111, "slti -> slt         ");

	// tipo R: depende de funct
	chequea(3'b010, 6'b100000, 4'b0010, "R add               ");
	chequea(3'b010, 6'b100010, 4'b0110, "R sub               ");
	chequea(3'b010, 6'b100100, 4'b0000, "R and               ");
	chequea(3'b010, 6'b100101, 4'b0001, "R or                ");
	chequea(3'b010, 6'b100111, 4'b1100, "R nor               ");
	chequea(3'b010, 6'b101010, 4'b0111, "R slt               ");
	chequea(3'b010, 6'b000000, 4'b0000, "R nop (funct 0)     ");

	$display("---- ALUControl_tb: %0d casos, %0d errores -> %0s", total, errores, errores==0 ? "TODO PASS" : "HAY FAIL");
	$finish;
end

endmodule

