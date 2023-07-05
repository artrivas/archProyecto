module top (
	clk,
	reset,
	WriteData,
	DataAdr,
	MemWrite,

	PCSrc,
	MemtoReg, //Changed
	RegWrite, //Changed
	ALUSrc, //Changed
	RegSrc, //Changed
	ImmSrc,// Changed
	ALUControl//Changed
);
	input wire clk;
	input wire reset;
	output wire [31:0] WriteData;
	input wire [31:0] DataAdr;
	input wire MemWrite; //Changed
	input wire PCSrc; //Changed
	input wire MemtoReg; //Changed
	input wire RegWrite; //Changed
	input wire ALUSrc; //Changed
	input wire [1:0] RegSrc; //Changed
	input wire [1:0] ImmSrc;// Changed
	input wire [1:0] ALUControl;//Changed
	wire [31:0] PC;
	wire [31:0] Instr;
	wire [31:0] ReadData;
	arm arm(
		.clk(clk),
		.reset(reset),
		.PC(PC),
		.Instr(Instr),
		.MemWrite(MemWrite),
		.ALUResult(DataAdr),
		.WriteData(WriteData),
		.ReadData(ReadData)
	);
	imem imem(
		.a(PC),
		.rd(Instr)
	);
	dmem dmem(
		.clk(clk),
		.we(MemWrite),
		.a(DataAdr),
		.wd(WriteData),
		.rd(ReadData)
	);
endmodule