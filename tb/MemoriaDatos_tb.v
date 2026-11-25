`timescale 1ns/1ps
// Usa datos.txt (valores de la diapositiva 26: dir 20=500, 24=780, 28=609 ...)
module MemoriaDatos_tb;

reg         CLK, MemWrite, MemRead;
reg  [31:0] Direccion, DatoEscritura;
wire [31:0] DatoLectura;

MemoriaDatos #(.FILE("datos.txt")) uut(.CLK(CLK), .MemWrite(MemWrite), .MemRead(MemRead),
                  .Direccion(Direccion), .DatoEscritura(DatoEscritura), .DatoLectura(DatoLectura));

integer errores = 0, total = 0;

initial CLK = 0;
always #5 CLK = ~CLK;

task lee(input [31:0] dir, input [31:0] esp, input [255:0] nombre);
	begin
		MemRead = 1; MemWrite = 0; Direccion = dir; #2;
		total = total + 1;
		if (DatoLectura === esp)
			$display("PASS %0s | Dir=%0d | Dato=%0d", nombre, Direccion, DatoLectura);
		else begin
			$display("FAIL %0s | Dir=%0d | Dato=%0d (esp %0d)", nombre, Direccion, DatoLectura, esp);
			errores = errores + 1;
		end
	end
endtask

task escribe(input hab, input [31:0] dir, input [31:0] dato);
	begin
		MemWrite = hab; MemRead = 0; Direccion = dir; DatoEscritura = dato;
		@(posedge CLK); #1;
		MemWrite = 0;
	end
endtask

initial begin
	$dumpfile("MemoriaDatos_tb.vcd"); $dumpvars(0, MemoriaDatos_tb);
	MemWrite = 0; MemRead = 0; Direccion = 0; DatoEscritura = 0;
	#10;

	// lw de los datos iniciales
	lee(32'd20, 32'd500, "lw dir 20 (inicial)  ");
	lee(32'd24, 32'd780, "lw dir 24 (inicial)  ");
	lee(32'd28, 32'd609, "lw dir 28 (inicial)  ");
	lee(32'd30, 32'd200, "lw dir 30 (inicial)  ");
	lee(32'd0,  32'd0,   "lw dir 0 (vacia)     ");

	// sw y lw del mismo dato
	escribe(1, 32'd40, 32'd1234);
	lee(32'd40, 32'd1234, "sw dir 40 y lw       ");

	// sobrescribir un dato inicial
	escribe(1, 32'd20, 32'd99);
	lee(32'd20, 32'd99,  "sw sobre dir 20      ");

	// MemWrite = 0 no debe escribir
	escribe(0, 32'd41, 32'd555);
	lee(32'd41, 32'd0,   "MemWrite=0 no escribe");

	// MemRead = 0 -> la salida es 0
	MemRead = 0; Direccion = 32'd24; #2;
	total = total + 1;
	if (DatoLectura === 32'd0)
		$display("PASS MemRead=0 salida 0     | Dir=%0d | Dato=%0d", Direccion, DatoLectura);
	else begin
		$display("FAIL MemRead=0 salida 0     | Dato=%0d (esp 0)", DatoLectura);
		errores = errores + 1;
	end

	$display("---- MemoriaDatos_tb: %0d casos, %0d errores -> %0s", total, errores, errores==0 ? "TODO PASS" : "HAY FAIL");
	$finish;
end

endmodule
