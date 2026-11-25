`timescale 1ns/1ps
// Mini integracion del Sprint 1: PC + Sumador (PC+4) formando el ciclo de fetch
//   PC_out --> Sumador(+4) --> PC_in
module PC_Sumador_tb;

reg         CLK, rst;
wire [31:0] PC_out, PC_mas4;

Sumador        sum(.A(PC_out), .B(32'd4), .Suma(PC_mas4));
ProgramCounter pc (.CLK(CLK), .rst(rst), .PC_in(PC_mas4), .PC_out(PC_out));

integer i, errores = 0;

initial CLK = 0;
always #5 CLK = ~CLK;

initial begin
	$dumpfile("PC_Sumador_tb.vcd"); $dumpvars(0, PC_Sumador_tb);

	rst = 1; @(posedge CLK); #1;
	rst = 0;

	// el PC debe ir 0, 4, 8, 12, ... 
	for (i = 0; i < 8; i = i + 1) begin
		if (PC_out === i*4)
			$display("PASS ciclo %0d | PC=%0d | PC+4=%0d", i, PC_out, PC_mas4);
		else begin
			$display("FAIL ciclo %0d | PC=%0d (esp %0d)", i, PC_out, i*4);
			errores = errores + 1;
		end
		@(posedge CLK); #1;
	end

	$display("---- PC_Sumador_tb: 8 casos, %0d errores -> %0s", errores, errores==0 ? "TODO PASS" : "HAY FAIL");
	$finish;
end

endmodule
