module datapath (
	clk,
	reset,
	RegSrcD,
	RegWriteW,
	ImmSrcD,
	ALUSrcE,
	ALUControlE,
	MemtoRegW,
	PCSrcW,
	ALUFlags,
	PCF,
	InstrF,
	ALUResultM,
	WriteDataM,
	ReadDataM
);
	input wire clk;
	input wire reset;
	input wire [1:0] RegSrcD;
	input wire RegWriteW;
	input wire [1:0] ImmSrcD;
	input wire ALUSrcE;
	input wire [2:0] ALUControlE;
	input wire MemtoRegW;
	input wire PCSrcW;
	output wire [3:0] ALUFlags;
	output wire [31:0] PCF;
	input wire [31:0] InstrF;
	output wire [31:0] ALUResultM;
	output wire [31:0] WriteDataM;
	input wire [31:0] ReadDataM;
	wire [31:0] PCNext;
	wire [31:0] PCPlus4F;
	wire [31:0] PCPlus8D;
	wire [31:0] ExtImmE;
	wire [31:0] SrcAE;
	wire [31:0] SrcBE;
	wire [31:0] ResultW;
	wire [3:0] RA1D;
	wire [3:0] RA2D;

	wire [31:0] RD1D;
	wire [31:0] RD2D;
	wire [31:0] ExtImmD;
	wire [3:0] WA3E;
	wire [3:0] WA3M;
	wire [3:0] WA3W;
	wire [31:0] ALUResultE;
	wire [31:0] ALUResultW;
	wire [31:0] WriteDataE;
	wire [31:0] ReadDataW;
	
	// PARTE DEL DECODE

	mux2 #(32) pcmux(
		.d0(PCPlus4F),
		.d1(ResultW),
		.s(PCSrcW),
		.y(PCNext)
	);

	flopr #(32) pcreg(
		.clk(clk),
		.reset(reset),
		.d(PCNext),
		.q(PCF)
	);

	adder #(32) pcadd1(
		.a(PCF),
		.b(2'b100),
		.y(PCPlus4)
	);
	// problemas con el PCPlus8
	
	flopr #(32) InstrF_D(
		.clk(clk),
		.reset(reset),
		.d(InstrF),
		.q(InstrD)
	);

	// PARTE DEL FETCH

	mux2 #(4) ra1mux(
		.d0(InstrD[19:16]),
		.d1(4'b1111),
		.s(RegSrcD[0]),
		.y(RA1D)
	);
	mux2 #(4) ra2mux(
		.d0(InstrD[3:0]),
		.d1(InstrD[15:12]),
		.s(RegSrcD[1]),
		.y(RA2D)
	);
	assign PCPlus8D = PCPlus4F;
	regfile rf(
		.clk(clk),
		.we3(RegWriteW),
		.ra1(RA1D),
		.ra2(RA2D),
		.wa3(WA3W),
		.wd3(Result),
		.r15(PCPlus8D),
		.rd1(RD1D),
		.rd2(RD2D)
	);

	extend ext(
		.Instr(InstrD[23:0]),
		.ImmSrc(ImmSrcD),
		.ExtImm(ExtImm)
	);


	blockDPclk1 #(32) ExecuteCLK(
		.clk(clk),
		.reset(reset),
		.d0(RD1D),
		.d1(RD2D),
		.d2(InstrD[15:12]),
		.d3(ExtImmD),
		.q0(SrcAE),
		.q1(WriteDataE),
		.q2(WA3E),
		.q3(ExtImmE)
	);

	// PARTE DEL EXECUTE

	mux2 #(4) SrcBEALU(
		.d0(WriteDataE),
		.d1(ExtImmE),
		.s(ALUSrcE),
		.y(SrcBE)
	)

	alu aluBlock(
		.SrcA(SrcAE),
		.SrcB(SrcBE),
		.ALUControl(ALUControlE),
		.ALUResult(ALUResultE),
		.ALUFlags(ALUFlags)
	);

	blockDPclk2 #(32) MemoryCLK(
		.clk(clk),
		.reset(reset),
		.d0(ALUResultE),
		.d1(WriteDataE),
		.d2(WA3E),
		.q0(ALUResultM),
		.q1(WriteDataM),
		.q2(WA3M)
	);

	// PARTE DEL MEMORY

	blockDPclk2 WriteBackCLK(
		.clk(clk),
		.reset(),
		.d0(ReadDataM),
		.d1(ALUResultM),
		.d2(WA3M),
		.q0(ReadDataW),
		.q1(ALUResultW),
		.q2(WA3W)
	);

	// PARTE DEL WRITE BACK

	mux2 #(4) resmux(
		.d0(ALUResultW),
		.d1(ReadDataW),
		.s(MemtoRegW),
		.y(ResultW)
	);

endmodule