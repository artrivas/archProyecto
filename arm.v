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
	wire PCSrc;
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
		.PCSrcW(PCSrc),
		.RegWriteM(RegWriteM)
	);
	datapath dp(
		.clk(clk),
		.reset(reset),
		.RegSrcD(RegSrc),
		.RegWriteW(RegWrite),
		.ImmSrcD(ImmSrc),
		.ALUSrcE(ALUSrc),
		.ALUControlE(ALUControl),
		.MemtoRegW(MemtoReg),
		.PCSrcW(PCSrc),
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
		.FlushE(FlushE)
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
		.ForwardAE(ForwardAE),
		.ForwardBE(ForwardBE),
		.StallF(StallF),
		.StallD(StallD),
		.FlushE(FlushE)
	);

endmodule