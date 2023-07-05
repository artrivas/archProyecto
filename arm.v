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
	output wire MemWrite;
	output wire [31:0] ALUResult;
	output wire [31:0] WriteData;
	input wire [31:0] ReadData;

	wire [3:0] ALUFlags;
	output wire PCSrc; //Changed
	output wire MemtoReg; //Changed
	output wire RegWrite; //Changed
	output wire ALUSrc; //Changed
	output wire [1:0] RegSrc; //Changed
	output wire [1:0] ImmSrc;// Changed
	output wire [1:0] ALUControl;//Changed

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
		.ALUResultM(ALUResult),
		.WriteDataM(WriteData),
		.ReadDataM(ReadData)
	);
endmodule