`timescale 1ns/1ps
// Lee el programa de prueba (instrucciones.txt) y compara cada instruccion.
module MemoriaInstrucciones_tb;

reg  [31:0] Dir;
wire [31:0] Instruccion;

MemoriaInstrucciones #(.FILE("instrucciones.txt")) uut(.Dir(Dir), .Instruccion(Instruccion));

integer errores = 0, total = 0;

task chequea(input [31:0] d, input [31:0] esp, input [255:0] nombre);
	begin
		Dir = d; #10;
		total = total + 1;
		if (Instruccion === esp)
			$display("PASS %0s | PC=%0d | Instruccion=0x%h", nombre, Dir, Instruccion);
		else begin
			$display("FAIL %0s | PC=%0d | Instruccion=0x%h (esp 0x%h)", nombre, Dir, Instruccion, esp);
			errores = errores + 1;
		end
	end
endtask

initial begin
	$dumpfile("MemoriaInstrucciones_tb.vcd"); $dumpvars(0, MemoriaInstrucciones_tb);

	chequea(32'd0,  32'h20080005, "addi $t0,$zero,5  ");
	chequea(32'd4,  32'h20090003, "addi $t1,$zero,3  ");
	chequea(32'd8,  32'h01095020, "add  $t2,$t0,$t1  ");
	chequea(32'd12, 32'h01095822, "sub  $t3,$t0,$t1  ");
	chequea(32'd16, 32'hAC0A0014, "sw   $t2,20($zero)");
	chequea(32'd20, 32'h8C0C0014, "lw   $t4,20($zero)");
	chequea(32'd24, 32'h0128682A, "slt  $t5,$t1,$t0  ");
	chequea(32'd28, 32'h114C0001, "beq  $t2,$t4,1    ");
	chequea(32'd32, 32'h200E0063, "addi $t6,$zero,99 ");
	chequea(32'd36, 32'h00000000, "nop               ");
	chequea(32'd40, 32'h08000000, "j    0            ");
	chequea(32'd44, 32'h00000000, "fuera de programa ");
	chequea(32'd1020, 32'h00000000, "ultima palabra    ");

	$display("---- MemoriaInstrucciones_tb: %0d casos, %0d errores -> %0s", total, errores, errores==0 ? "TODO PASS" : "HAY FAIL");
	$finish;
end

endmodule
