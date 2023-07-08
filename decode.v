module condlogic (
	clk,
	reset,
	Cond,
	ALUFlags,
	FlagW,
	FlagsE,
	PCS,
	RegW,
	MemW,
	PCSrc,
	RegWrite,
	MemWrite,
	Branch,
	FlagsN
);
	input wire clk;
	input wire reset;
	input wire [3:0] Cond;
	input wire [3:0] ALUFlags;
	input wire [1:0] FlagW;
	input wire [1:0] FlagsE;
	input wire PCS;
	input wire RegW;
	input wire MemW;
	input wire Branch;
	output wire PCSrc;
	output wire RegWrite;
	output wire MemWrite;
	output wire [3:0] FlagsN;
	
	wire [3:0] Flags;
	
	wire [3:0] flNt;
	wire [3:0] flNb;
	
	wire [1:0] FlagWrite;
	wire CondEx;
	flopenr #(2) flagreg1(
		.clk(clk),
		.reset(reset),
		.en(FlagWrite[1]),
		.d(flNt),
		.q(Flags[3:2])
	);
	flopenr #(2) flagreg0(
		.clk(clk),
		.reset(reset),
		.en(FlagWrite[0]),
		.d(flNb),
		.q(Flags[1:0])
	);
	
	mux2 #(4) muxT(
	   .d0(ALUFlags[3:2]),
	   .d1(FlagsE),
	   .s(FlagWrite[1]),
	   .y(flNt)
	);
	
	mux2 #(4) muxB(
	   .d0(ALUFlags[1:0]),
	   .d1(FlagsE),
	   .s(FlagWrite[0]),
	   .y(flNb)
	);
	
	assign FlagsN = Flags;
	
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
