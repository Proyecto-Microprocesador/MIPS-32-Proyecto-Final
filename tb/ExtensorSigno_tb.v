`timescale 1ns/1ps

module ExtensorSigno_tb;

reg  [15:0] in;
wire [31:0] out;

ExtensorSigno uut(.in(in), .out(out));

integer errores = 0, total = 0;

task chequea(input [15:0] x, input [31:0] esp, input [255:0] nombre);
	begin
		in = x; #10;
		total = total + 1;
		if (out === esp)
			$display("PASS %0s | in=0x%h | out=0x%h (%0d)", nombre, in, out, $signed(out));
		else begin
			$display("FAIL %0s | in=0x%h | out=0x%h (esp 0x%h)", nombre, in, out, esp);
			errores = errores + 1;
		end
	end
endtask

initial begin
	$dumpfile("ExtensorSigno_tb.vcd"); $dumpvars(0, ExtensorSigno_tb);

	chequea(16'h0000, 32'h00000000, "cero              ");
	chequea(16'h0005, 32'h00000005, "positivo +5       ");
	chequea(16'h7FFF, 32'h00007FFF, "maximo positivo   ");
	chequea(16'hFFFB, 32'hFFFFFFFB, "negativo -5       ");
	chequea(16'h8000, 32'hFFFF8000, "minimo negativo   ");
	chequea(16'hFFFF, 32'hFFFFFFFF, "-1                ");

	$display("---- ExtensorSigno_tb: %0d casos, %0d errores -> %0s", total, errores, errores==0 ? "TODO PASS" : "HAY FAIL");
	$finish;
end

endmodule
