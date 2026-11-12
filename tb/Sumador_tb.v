`timescale 1ns/1ps

module Sumador_tb;

reg  [31:0] A, B;
wire [31:0] Suma;

Sumador uut(.A(A), .B(B), .Suma(Suma));

integer errores = 0, total = 0;

task chequea(input [31:0] x, input [31:0] y, input [31:0] esp, input [255:0] nombre);
	begin
		A = x; B = y; #10;
		total = total + 1;
		if (Suma === esp)
			$display("PASS %0s | A=%0d B=%0d | Suma=%0d", nombre, A, B, Suma);
		else begin
			$display("FAIL %0s | A=%0d B=%0d | Suma=%0d (esp %0d)", nombre, A, B, Suma, esp);
			errores = errores + 1;
		end
	end
endtask

initial begin
	$dumpfile("Sumador_tb.vcd"); $dumpvars(0, Sumador_tb);

	chequea(32'd0,   32'd4,  32'd4,   "PC+4 (0+4)      ");
	chequea(32'd100, 32'd4,  32'd104, "PC+4 (100+4)    ");
	chequea(32'd8,   32'd16, 32'd24,  "PC+4 + offset    ");
	chequea(32'd20,  -32'sd8, 32'd12, "salto hacia atras");
	chequea(32'hFFFFFFFF, 32'd1, 32'd0, "desborde a 0   ");

	$display("---- Sumador_tb: %0d casos, %0d errores -> %0s", total, errores, errores==0 ? "TODO PASS" : "HAY FAIL");
	$finish;
end

endmodule
