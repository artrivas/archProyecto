module condunit (
	clk,
	reset,
	Cond,
	FlagsE,
	ALUFlags,
	FlagW,
	ALUFlagsResult,
	PCS,
	RegW,
	MemW,
	Branch,
	PCSrc,
	RegWrite,
	MemWrite
);
	input wire clk;
	input wire reset;
	input wire [3:0] Cond;
	input wire [3:0] FlagsE;
	input wire [3:0] ALUFlags;
	input wire [1:0] FlagW;
	input wire PCS;
	input wire RegW;
	input wire MemW;
	input wire Branch;

	output wire [3:0] ALUFlagsResult;
	output wire PCSrc;
	output wire RegWrite;
	output wire MemWrite;

	wire CondEx;
	wire FlagWrite;
	
	condcheck cc(
		.Cond(Cond),
		.Flags(ALUFlagsResult),
		.CondEx(CondEx)
	);
	
	assign FlagWrite = FlagW & {2 {CondEx}};

	mux2 #(2) Flags_first(
		.d0(FlagsE[3:2]),
		.d1(ALUFlags[3:2]),
		.s(FlagW[1]),
		.y(ALUFlagsResult[3:2])
	);

	mux2 #(2) Flags_second(
		.d0(FlagsE[1:0]),
		.d1(ALUFlags[1:0]),
		.s(FlagW[0]),
		.y(ALUFlagsResult[1:0])
	);

	assign PCSrc = (PCS & CondEx) | (Branch & CondEx);
	assign RegWrite = RegW & CondEx;
	assign MemWrite = MemW & CondEx;

endmodule