// reuse code from prior labs.
module condlogic (
	clk,
	reset,
	Cond,
	ALUFlags,
	FlagW,
	PCSrcE,
	RegWE,
	MemWE,
	Branch,
	PCSrc,
	RegW,
	MemW,
	FlagWrite
);
	input wire clk;
	input wire reset;
	input wire [3:0] Cond;
	input wire [3:0] ALUFlags;
	input wire [1:0] FlagW;
	input wire PCSrcE;
	input wire RegWE;
	input wire MemWE;
	input wire Branch;
	output wire PCSrc;
	output wire RegW;
	output wire MemW;
	output wire [1:0] FlagWrite;
	wire [3:0] Flags;
	wire CondEx;
    wire AfterCondEx;

	// Delay writing flags until ALUWB state
	flopr #(1) flagwritereg(
		clk,
		reset,
		CondEx,
		AfterCondEx
	);

	// ADD CODE HERE
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
		.Cond(CondE),
		.Flags(Flags),
		.CondEx(CondEx)
	);
	assign PCSrc = (Branch & AfterCondEx) | (PCSrcE & AfterCondEx);
	assign RegW = AfterCondEx & RegWE;
	assign MemW = AfterCondEx & MemW;
    assign FlagWrite = FlagW & {2 {CondEx}};

endmodule