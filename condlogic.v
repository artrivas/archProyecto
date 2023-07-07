module condlogic (
	clk,
	reset,
	Cond,
	ALUFlags,
	FlagW,
	PCS,
	RegW,
	MemW,
	PCSrc,
	RegWrite,
	MemWrite,
	Branch
);
	input wire clk;
	input wire reset;
	input wire [3:0] Cond;
	input wire [3:0] ALUFlags;
	input wire [1:0] FlagW;
	input wire PCS;
	input wire RegW;
	input wire MemW;
	input wire Branch;
	output wire PCSrc;
	output wire RegWrite;
	output wire MemWrite;
	wire [1:0] FlagWrite;
	wire [3:0] Flags;
	wire CondEx;
	flopenr #(2) flagreg1(
		.clk(clk),
		.reset(reset),
		.en(FlagWrite[1]),
		.d(ALUFlags[3:2]),
		.q(Flags[3:2])
	);
	flopenr #(2) flagreg0(
		.clk(clk),
		.reset(reset),
		.en(FlagWrite[0]),
		.d(ALUFlags[1:0]),
		.q(Flags[1:0])
	);
	condcheck cc(
		.Cond(Cond),
		.Flags(Flags),
		.CondEx(CondEx)
	);
	
	assign FlagWrite = FlagW & {2 {CondEx}};

	flopr #(1) pcsrcwr(
		.clk(clk),
		.reset(reset),
		.d((PCS & CondEx) | (Branch & CondEx)),
		.q(PCSrc)
	);

	flopr #(1) regwr(
		.clk(clk),
		.reset(reset),
		.d((RegW & CondEx)),
		.q(RegWrite)
	);

	flopr #(1) memwr(
		.clk(clk),
		.reset(reset),
		.d((MemW & CondEx)),
		.q(MemWrite)
	);
endmodule