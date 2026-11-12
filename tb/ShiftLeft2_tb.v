timescale 1ns/1ps
// Prueba los dos desplazadores: ShiftLeft2 (branch, 32 bits) y ShiftLeftJ (jump, 26 a 28 bits)
module ShiftLeft2_tb;

reg  [31:0] in32;
wire [31:0] out32;
reg  [25:0] in26;
wire [27:0] out28;

ShiftLeft2 uutB(.in(in32), .out(out32));
ShiftLeftJ uutJ(.in(in26), .out(out28));

integer errores = 0, total = 0;

task chequeaB(input [31:0] x, input [31:0] esp, input [255:0] nombre);
	begin
		in32 = x; #10;
		total = total + 1;
		if (out32 === esp)
			$display("PASS %0s | in=%0d | out=%0d", nombre, in32, out32);
		else begin
			$display("FAIL %0s | in=%0d | out=%0d (esp %0d)", nombre, in32, out32, esp);
			errores = errores + 1;
		end
	end
endtask

task chequeaJ(input [25:0] x, input [27:0] esp, input [255:0] nombre);
	begin
		in26 = x; #10;
		total = total + 1;
		if (out28 === esp)
			$display("PASS %0s | index=0x%h | out=0x%h", nombre, in26, out28);
		else begin
			$display("FAIL %0s | index=0x%h | out=0x%h (esp 0x%h)", nombre, in26, out28, esp);
			errores = errores + 1;
		end
	end
endtask

initial begin
	$dumpfile("ShiftLeft2_tb.vcd"); $dumpvars(0, ShiftLeft2_tb);

	chequeaB(32'd1,          32'd4,          "branch  1 -> 4        ");
	chequeaB(32'd3,          32'd12,         "branch  3 -> 12       ");
	chequeaB(32'hFFFFFFFE,   32'hFFFFFFF8,   "branch -2 -> -8       ");
	chequeaB(32'h40000000,   32'h00000000,   "branch pierde 2 bits  ");

	chequeaJ(26'd1,          28'd4,          "jump    index 1       ");
	chequeaJ(26'h0000010,    28'h0000040,    "jump    index 0x10    ");
	chequeaJ(26'h3FFFFFF,    28'hFFFFFFC,    "jump    index maximo  ");

	$display("---- ShiftLeft2_tb: %0d casos, %0d errores -> %0s", total, errores, errores==0 ? "TODO PASS" : "HAY FAIL");
	$finish;
end

endmodule
