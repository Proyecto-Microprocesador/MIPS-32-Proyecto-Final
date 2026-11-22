`timescale 1ns/1ps

module Mux2a1_tb;

// Instancia de 32 bits (Mux1, Mux3, Mux4, Mux5)
reg  [31:0] D0, D1;
reg Sel;
wire [31:0] Y;

Mux2a1 #(.N(32)) uut32(.D0(D0), .D1(D1), .Sel(Sel), .Y(Y));

// Instancia de 5 bits (Mux2 - RegDst)
reg  [4:0] d0_5, d1_5;
reg        sel5;
wire [4:0] y5;

Mux2a1 #(.N(5)) uut5(.D0(d0_5), .D1(d1_5), .Sel(sel5), .Y(y5));

integer errores = 0, total = 0;

task chequea32(input [31:0] a, input [31:0] b, input s, input [31:0] esp, input [255:0] nombre);
	begin
		D0 = a; D1 = b; Sel = s; #10;
		total = total + 1;
		if (Y === esp)
			$display("PASS %0s | D0=%0d D1=%0d Sel=%b | Y=%0d", nombre, D0, D1, Sel, Y);
		else begin
			$display("FAIL %0s | D0=%0d D1=%0d Sel=%b | Y=%0d (esp %0d)", nombre, D0, D1, Sel, Y, esp);
			errores = errores + 1;
		end
	end
endtask

task chequea5(input [4:0] a, input [4:0] b, input s, input [4:0] esp, input [255:0] nombre);
	begin
		d0_5 = a; d1_5 = b; sel5 = s; #10;
		total = total + 1;
		if (y5 === esp)
			$display("PASS %0s | rt=%0d rd=%0d RegDst=%b | AW=%0d", nombre, d0_5, d1_5, sel5, y5);
		else begin
			$display("FAIL %0s | rt=%0d rd=%0d RegDst=%b | AW=%0d (esp %0d)", nombre, d0_5, d1_5, sel5, y5, esp);
			errores = errores + 1;
		end
	end
endtask

initial begin
	$dumpfile("Mux2a1_tb.vcd"); $dumpvars(0, Mux2a1_tb);

	chequea32(32'd10, 32'd99, 0, 32'd10, "N=32 Sel=0        ");
	chequea32(32'd10, 32'd99, 1, 32'd99, "N=32 Sel=1        ");
	chequea32(32'hAAAAAAAA, 32'h55555555, 0, 32'hAAAAAAAA, "N=32 patron AA    ");
	chequea32(32'hAAAAAAAA, 32'h55555555, 1, 32'h55555555, "N=32 patron 55    ");

	chequea5(5'd8,  5'd10, 0, 5'd8,  "N=5  RegDst=0 (rt)");
	chequea5(5'd8,  5'd10, 1, 5'd10, "N=5  RegDst=1 (rd)");

	$display("---- Mux2a1_tb: %0d casos, %0d errores -> %0s", total, errores, errores==0 ? "TODO PASS" : "HAY FAIL");
	$finish;
end

endmodule

