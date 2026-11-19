`timescale 1ns/1ps

module ProgramCounter_tb;

reg         CLK, rst;
reg  [31:0] PC_in;
wire [31:0] PC_out;

ProgramCounter uut(.CLK(CLK), .rst(rst), .PC_in(PC_in), .PC_out(PC_out));

integer errores = 0, total = 0;

// reloj de 10 ns de periodo
initial CLK = 0;
always #5 CLK = ~CLK;

// pone PC_in, espera un flanco de subida y revisa PC_out
task chequea(input [31:0] entrada, input r, input [31:0] esp, input [255:0] nombre);
	begin
		PC_in = entrada; rst = r;
		@(posedge CLK); #1;
		total = total + 1;
		if (PC_out === esp)
			$display("PASS %0s | PC_in=%0d rst=%b | PC_out=%0d", nombre, PC_in, rst, PC_out);
		else begin
			$display("FAIL %0s | PC_in=%0d rst=%b | PC_out=%0d (esp %0d)", nombre, PC_in, rst, PC_out, esp);
			errores = errores + 1;
		end
	end
endtask

initial begin
	$dumpfile("ProgramCounter_tb.vcd"); $dumpvars(0, ProgramCounter_tb);

	chequea(32'd0,  1, 32'd0,  "reset inicial     ");
	chequea(32'd4,  0, 32'd4,  "carga 4           ");
	chequea(32'd8,  0, 32'd8,  "carga 8           ");
	chequea(32'd100,0, 32'd100,"salto a 100       ");
	chequea(32'd50, 1, 32'd0,  "reset ignora PC_in");
	chequea(32'd12, 0, 32'd12, "continua despues   ");

	$display("---- ProgramCounter_tb: %0d casos, %0d errores -> %0s", total, errores, errores==0 ? "TODO PASS" : "HAY FAIL");
	$finish;
end

endmodule
