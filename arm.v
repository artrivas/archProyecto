module arm (
	clk,
	reset,
	PC,
	Instr,
	MemWrite,
	ALUResult
	WriteData,
	ReadData
);
	input wire clk;
	input wire reset;
	output wire [31:0] PC;
	input wire [31:0] Instr;
	output wire MemWrite;
	output wire [31:0] ALUResult;
	output wire [31:0] WriteData;
	input wire [31:0] ReadData;

	wire [3:0] ALUFlags;
	wire PCSrc;
	wire MemtoReg;
	wire RegWrite;
	wire ALUSrc;
	wire [1:0] RegSrc;
	wire [1:0] ImmSrc;
	wire [1:0] ALUControl;
	
	controller c(
		.clk(clk),
		.reset(reset),
		.Instr(Instr[31:12]),
		.ALUFlags(ALUFlags),
		.PCSrcW(PCSrc),
		.MemWriteM(MemWrite),
		.MemtoRegW(MemtoReg),
		.RegWriteW(RegWrite),
		.RegSrcD(RegSrc),
		.ALUSrcE(ALUSrc),
		.ImmSrcD(ImmSrc),
		.ALUControlE(ALUControl)
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
		.ALUResultM(ALUresult),
		.WriteDataM(WriteData),
		.ReadDataM(ReadData)
	);
endmodule