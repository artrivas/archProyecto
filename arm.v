module arm (
	clk,
	reset,
	PC,
	Instr,
	MemWrite,
	ALUResult,
	WriteData,
	ReadData
);
	input wire clk;
	input wire reset;
	output wire [31:0] PC;
	input wire [31:0] Instr;
	wire [31:0] InstrD; //Added
	output wire MemWrite;
	output wire [31:0] ALUResult;
	output wire [31:0] WriteData;
	input wire [31:0] ReadData;
	wire [3:0] ALUFlags;
	wire RegWriteW;
	wire RegWriteM;
	wire ALUSrc;
	wire MemtoRegW;
	wire MemtoRegE;
	wire PCSrcW;
	wire [1:0] RegSrc;
	wire [1:0] ImmSrc;
	wire [1:0] ALUControl;
	wire Match_1E_M;
	wire Match_1E_W;
	wire Match_2E_M;
	wire Match_2E_W;
	wire Match_12D_E;
	wire [1:0] ForwardAE;
	wire [1:0] ForwardBE;
	wire StallD;
	wire StallF;
	wire FlushE;
	wire FlushD;
	wire BranchTakenE;
	wire PCWrPendingF;

	controller c(
		.clk(clk),
		.reset(reset),
		.Instr(InstrD[31:12]),
		.ALUFlags(ALUFlags),
		.RegSrcD(RegSrc),
		.RegWriteW(RegWriteW),
		.ImmSrcD(ImmSrc),
		.ALUSrcE(ALUSrc),
		.ALUControlE(ALUControl),
		.MemWriteM(MemWrite),
		.MemtoRegE(MemtoRegE),
		.MemtoRegW(MemtoRegW),
		.PCSrcW(PCSrcW),
		.RegWriteM(RegWriteM),
		.BranchTakenE(BranchTakenE),
		.PCWrPendingF(PCWrPendingF),
		.FlushE(FlushE)
	);
	datapath dp(
		.clk(clk),
		.reset(reset),
		.RegSrcD(RegSrc),
		.RegWriteW(RegWriteW),
		.ImmSrcD(ImmSrc),
		.ALUSrcE(ALUSrc),
		.ALUControlE(ALUControl),
		.MemtoRegW(MemtoRegW),
		.PCSrcW(PCSrcW),
		.ALUFlags(ALUFlags),
		.PCF(PC),
		.InstrF(Instr),
		.InstrD(InstrD), //Added
		.ALUOutM(ALUResult),
		.WriteDataM(WriteData),
		.ReadDataM(ReadData),
		.Match_1E_M(Match_1E_M),
		.Match_1E_W(Match_1E_W),
		.Match_2E_M(Match_2E_M),
		.Match_2E_W(Match_2E_W),
		.Match_12D_E(Match_12D_E),
		.ForwardAE(ForwardAE),
		.ForwardBE(ForwardBE),
		.StallD(StallD),
		.StallF(StallF),
		.FlushE(FlushE),
		.FlushD(FlushD),
		.BranchTakenE(BranchTakenE)
	);

	hazardUnit hU(
		.Match_1E_M(Match_1E_M),
		.Match_1E_W(Match_1E_W),
		.Match_2E_M(Match_2E_M),
		.Match_2E_W(Match_2E_W),
		.Match_12D_E(Match_12D_E),
		.RegWriteM(RegWriteM),
		.RegWriteW(RegWriteW),
		.MemtoRegE(MemtoRegE),
		.PCWrPendingF(PCWrPendingF),
		.BranchTakenE(BranchTakenE),
		.PCSrcW(PCSrcW),
		.ForwardAE(ForwardAE),
		.ForwardBE(ForwardBE),
		.StallF(StallF),
		.StallD(StallD),
		.FlushE(FlushE),
		.FlushD(FlushD)
	);

endmodule