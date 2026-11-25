`timescale 1ns/1ps

module Fetch_tb;

reg CLK, rst;
wire [31:0] PC_out, PC_mas4, Instruccion;

ProgramCounter pc  (.CLK(CLK), .rst(rst), .PC_in(PC_mas4), .PC_out(PC_out));
Sumador        sum (.A(PC_out), .B(32'd4), .Suma(PC_mas4));
MemoriaInstrucciones #(.FILE("instrucciones.txt")) mi (.Dir(PC_out), .Instruccion(Instruccion));

reg [31:0] esperado [0:10];
integer i, errores = 0;

initial CLK = 0;
always #5 CLK = ~CLK;

initial begin
	esperado[0]=32'h20080005; esperado[1]=32'h20090003; esperado[2]=32'h01095020;
	esperado[3]=32'h01095822; esperado[4]=32'hAC0A0014; esperado[5]=32'h8C0C0014;
	esperado[6]=32'h0128682A; esperado[7]=32'h114C0001; esperado[8]=32'h200E0063;
	esperado[9]=32'h00000000; esperado[10]=32'h08000000;

	$dumpfile("Fetch_tb.vcd"); $dumpvars(0, Fetch_tb);

	rst = 1; @(posedge CLK); #1;
	rst = 0;

	for (i = 0; i < 11; i = i + 1) begin
		if (Instruccion === esperado[i])
			$display("PASS ciclo %2d | PC=%2d | Instruccion=0x%h", i, PC_out, Instruccion);
		else begin
			$display("FAIL ciclo %2d | PC=%2d | Instruccion=0x%h (esp 0x%h)", i, PC_out, Instruccion, esperado[i]);
			errores = errores + 1;
		end
		@(posedge CLK); #1;
	end

	$display("---- Fetch_tb: 11 casos, %0d errores -> %0s", errores, errores==0 ? "TODO PASS" : "HAY FAIL");
	$finish;
end

endmodule

