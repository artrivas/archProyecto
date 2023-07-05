module controller (
	clk,
	reset,
	Instr,
	ALUFlags,
	PCSrcW,
	MemWriteM,
	MemtoRegW,
	RegWriteW,
	RegSrcD,
	ALUSrcE,
	ImmSrcD,
	ALUControlE
);
	input wire clk;
	input wire reset;
	input wire [31:12] Instr;
	input wire [3:0] ALUFlags;
	output wire PCSrcW;
	output wire MemWriteM;
	output wire MemtoRegW;
	output wire RegWriteW;
	output wire [1:0] RegSrcD;
	output wire [1:0] ALUSrcE;
	output wire [1:0] ImmSrcD;
	output wire [1:0] ALUControlE;

	wire PCSD;
	wire RWD;
	wire mRD;
	wire mWD;
	wire [1:0] ALUCD;
	wire BD;
	wire [1:0] ALUSD;
	wire FWD;
	wire ISD;
	wire FlagsNext;

	// primer clk
	wire PCSE;
	wire RWE;
	wire mRE;
	wire mWE;
	wire BE;
	wire FWE;
	wire [3:0] CondE;
	wire [1:0] FlagsE;

	wire [1:0] FlagW;
	wire PCS;
	wire NextPC;
	wire RegW;
	wire MemW;

	// bloque de cond logic
	wire PCSOut;
	wire RWOut;
	wire mWOut;

	// segundo bloque de clk
	wire PCSM;
	wire RWM;
	wire mRM;

	// decode

	decode dec(
		.clk(clk),
		.reset(reset),
		.Op(Instr[27:26]),
		.Funct(Instr[25:20]),
		.Rd(Instr[15:12]),
		.FlagW(FlagW),
		.PCS(PCS),
		.NextPC(NextPC),
		.RegW(RegW),
		.MemW(MemW),
		.IRWrite(IRWrite),
		.AdrSrc(AdrSrc),
		.ResultSrc(ResultSrc),
		.ALUSrcA(ALUSrcA),
		.ALUSrcB(ALUSrcB),
		.ImmSrc(ImmSrc),
		.RegSrc(RegSrc),
		.ALUControl(ALUControl)
	);



	condlogic cl(
		.clk(clk),
		.reset(reset),
		.Cond(CondE),
		.ALUFlags(ALUFlags),
		.FlagW(FWE),
		.PCSrcE(PCSE),
		.RegWE(RWE),
		.MemWE(mWE),
		.Branch(BE),
		.PCSrc(PCSOut),
		.RegW(RWOut),
		.MemW(mWOut),
		.FlagWrite(FlagsNext)
	);

	// SEGUNDO BLOQUE DE CLK
	floper #(32) PCSrcM(
		.clk(clk),
		.reset(reset),
		.d(PCSOut),
		.q(PCSM)
	);

	floper #(32) RWriteM(
		.clk(clk),
		.reset(reset),
		.d(RWOut),
		.q(RWM)
	);

	floper #(32) memtoRegM(
		.clk(clk),
		.reset(reset),
		.d(mRE),
		.q(mRM)
	);

	floper #(32) memWriteout(
		.clk(clk),
		.reset(reset),
		.d(mWOut),
		.q(MemWriteM)
	);

	// tercer bloque de clk
	floper #(32) PCSrcOut(
		.clk(clk),
		.reset(reset),
		.d(PCSM),
		.q(PCSrcW)
	);

	floper #(32) RegWriteOut(
		.clk(clk),
		.reset(reset),
		.d(RWM),
		.q(RegWriteW)
	);

	floper #(32) MemtoRegOut(
		.clk(clk),
		.reset(reset),
		.d(mRM),
		.q(MemtoRegW)
	);

endmodule