`timescale 1ns/1ps

module BancoRegistros_tb;

reg         CLK, RegWrite;
reg  [4:0]  AR1, AR2, AW;
reg  [31:0] DW;
wire [31:0] DR1, DR2;

BancoRegistros uut(.CLK(CLK), .RegWrite(RegWrite), .AR1(AR1), .AR2(AR2),
                   .AW(AW), .DW(DW), .DR1(DR1), .DR2(DR2));

integer errores = 0, total = 0;

initial CLK = 0;
always #5 CLK = ~CLK;

// escribe un dato (un flanco de reloj) con la habilitacion indicada
task escribe(input hab, input [4:0] dir, input [31:0] dato);
	begin
		RegWrite = hab; AW = dir; DW = dato;
		@(posedge CLK); #1;
		RegWrite = 0;
	end
endtask

// lee por los dos puertos y compara
task lee(input [4:0] a1, input [4:0] a2, input [31:0] esp1, input [31:0] esp2, input [255:0] nombre);
	begin
		AR1 = a1; AR2 = a2; #2;
		total = total + 1;
		if (DR1 === esp1 && DR2 === esp2)
			$display("PASS %0s | AR1=%0d AR2=%0d | DR1=%0d DR2=%0d", nombre, AR1, AR2, DR1, DR2);
		else begin
			$display("FAIL %0s | AR1=%0d AR2=%0d | DR1=%0d (esp %0d) DR2=%0d (esp %0d)", nombre, AR1, AR2, DR1, DR2, esp1, esp2);
			errores = errores + 1;
		end
	end
endtask

initial begin
	$dumpfile("BancoRegistros_tb.vcd"); $dumpvars(0, BancoRegistros_tb);
	RegWrite = 0; AW = 0; DW = 0; AR1 = 0; AR2 = 0;
	@(posedge CLK); #1;

	lee(5'd8, 5'd9, 32'd0, 32'd0, "inicia en cero      ");

	escribe(1, 5'd8,  32'd125);   // valores de la diapositiva 26
	escribe(1, 5'd9,  32'd25);
	escribe(1, 5'd10, 32'd220);
	lee(5'd8,  5'd9,  32'd125, 32'd25,  "lee $8 y $9         ");
	lee(5'd10, 5'd8,  32'd220, 32'd125, "lee $10 y $8        ");
	lee(5'd9,  5'd9,  32'd25,  32'd25,  "mismo reg en 2 ports");

	escribe(0, 5'd11, 32'd96);    // RegWrite = 0: no debe escribir
	lee(5'd11, 5'd11, 32'd0, 32'd0,     "RegWrite=0 no escribe");

	escribe(1, 5'd0, 32'd777);    // $0 no se puede modificar
	lee(5'd0, 5'd0, 32'd0, 32'd0,       "$0 siempre es 0     ");

	escribe(1, 5'd8, 32'd500);    // sobrescribir
	lee(5'd8, 5'd10, 32'd500, 32'd220,  "sobrescribe $8      ");

	escribe(1, 5'd31, 32'hFFFFFFFF);
	lee(5'd31, 5'd8, 32'hFFFFFFFF, 32'd500, "ultimo registro $31 ");

	$display("---- BancoRegistros_tb: %0d casos, %0d errores -> %0s", total, errores, errores==0 ? "TODO PASS" : "HAY FAIL");
	$finish;
end

endmodule
