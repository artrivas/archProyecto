module controller (
	clk,
	reset,
	Instr,
	ALUFlags,
	RegSrcD,
	RegWriteW,
	ImmSrcD,
	ALUSrcE,
	ALUControlE,
	MemWriteM,
	MemtoRegE,
	MemtoRegW,
	PCSrcW,
	RegWriteM,
	BranchTakenE,
	PCWrPendingF,
	FlushE
);
	input wire clk;
	input wire reset;
	input wire [31:12] Instr;
	input wire [3:0] ALUFlags;
	
	//wire PCS;



	//Decode
	wire PCSD;
	wire RegWriteD;
	wire MemtoRegD;
	wire MemWriteD;
	wire [1:0] ALUControlD;
	wire BranchD;
	wire ALUSrcD;
	wire [1:0] FlagWriteD;
	output wire [1:0] ImmSrcD; //Changed
	output wire [1:0] RegSrcD; // Changed
	
	// Execute
	wire PCSE;
	wire RegWriteE;
	output wire MemtoRegE;
	wire MemWriteE;
	output wire [1:0] ALUControlE; //Changed
	wire BranchE;
	output wire ALUSrcE; //Changed
	wire [1:0] FlagWriteE;
	wire [3:0] CondE;
	wire [3:0] FlagsE; //Revisar
	wire [3:0] ALUFlagsResult; //Flags'
	wire PCSrcE;
	wire RegWriteBM;
	wire MemWriteBM;
	
	//Memory
	wire PCSrcM;
	output wire RegWriteM; //Changed
	wire MemtoRegM;
	output wire MemWriteM; //Changed

	//WriteBack
	output wire PCSrcW; //Changed
	output wire RegWriteW;
	output wire MemtoRegW; //Changed

	// para el hazard
	input wire FlushE;
	output wire BranchTakenE;
	output wire PCWrPendingF;

	decode dec(
		.Op(Instr[27:26]),
		.Funct(Instr[25:20]),
		.Rd(Instr[15:12]),
		.PCS(PCSD),
		.RegW(RegWriteD),
		.MemtoReg(MemtoRegD),
		.MemW(MemWriteD),
		.ALUControl(ALUControlD),
		.Branch(BranchD),
		.ALUSrc(ALUSrcD),
		.FlagW(FlagWriteD),
		.ImmSrc(ImmSrcD),
		.RegSrc(RegSrcD)
	
	);


	//START FIRST BLOCK

	flopenr #(1) ModPCSE(
		.clk(clk),
		.reset(reset),
		.en(~FlushE),
		.d(PCSD),
		.q(PCSE)
	);

	flopenr #(1) ModRegWriteE(
		.clk(clk),
		.reset(reset),
		.en(~FlushE),
		.d(RegWriteD),
		.q(RegWriteE)
	);

	flopenr #(1) ModMemtoRegE(
		.clk(clk),
		.reset(reset),
		.en(~FlushE),
		.d(MemtoRegD),
		.q(MemtoRegE)
	);

	flopenr #(1) ModMemWriteE(
		.clk(clk),
		.reset(reset),
		.en(~FlushE),
		.d(MemWriteD),
		.q(MemWriteE)
	);

	flopenr #(2) ModAluControlE(
		.clk(clk),
		.reset(reset),
		.en(~FlushE),
		.d(ALUControlD),
		.q(ALUControlE)
	);

	flopenr #(1) ModBranchE(
		.clk(clk),
		.reset(reset),
		.en(~FlushE),
		.d(BranchD),
		.q(BranchE)
	);

	flopenr #(1) ModAluSrcE(
		.clk(clk),
		.reset(reset),
		.en(~FlushE),
		.d(ALUSrcD),
		.q(ALUSrcE)
	); 

	flopenr #(2) ModFlagWriteE(
		.clk(clk),
		.reset(reset),
		.en(~FlushE),
		.d(FlagWriteD),
		.q(FlagWriteE)
	);

	flopenr #(4) ModCondE(
		.clk(clk),
		.reset(reset),
		.en(~FlushE),
		.d(Instr[31:28]),
		.q(CondE)
	);

	flopenr #(4) ModFlagsE(
		.clk(clk),
		.reset(reset),
		.en(~FlushE),
		.d(ALUFlagsResult),
		.q(FlagsE)
	);
	//END FIRST BLOCK

	condunit cl(
		.clk(clk),
		.reset(reset),
		.Cond(CondE),
		.FlagsE(FlagsE),
		.ALUFlags(ALUFlags),
		.FlagW(FlagWriteE),
		.PCS(PCSE),
		.RegW(RegWriteE),
		.MemW(MemWriteE),
		.Branch(BranchE),

		.ALUFlagsResult(ALUFlagsResult),
		.PCSrc(PCSrcE),
		.RegWrite(RegWriteBM),
		.MemWrite(MemWriteBM),
		.BranchTakenE(BranchTakenE)
	);

	//START SECOND BLOCK

	flopr #(1) ModPCSrcM(
		.clk(clk),
		.reset(reset),
		.d(PCSrcE),
		.q(PCSrcM)
	);

	flopr #(1) ModRegWriteM(
		.clk(clk),
		.reset(reset),
		.d(RegWriteBM),
		.q(RegWriteM)
	);

	flopr #(1) ModMemWriteM(
		.clk(clk),
		.reset(reset),
		.d(MemWriteBM),
		.q(MemWriteM)
	);

	
	flopr #(1) ModMemtoregM(
		.clk(clk),
		.reset(reset),
		.d(MemtoRegE),
		.q(MemtoRegM)
	);
	//END SECOND BLOCK

	//START THIRD BLOCK
	flopr #(1) ModRegPCSrcW(
		.clk(clk),
		.reset(reset),
		.d(PCSrcM),
		.q(PCSrcW)
	);

	flopr #(1) ModRegWriteW(
		.clk(clk),
		.reset(reset),
		.d(RegWriteM),
		.q(RegWriteW)
	);

	flopr #(1) ModRegMemtoRegW(
		.clk(clk),
		.reset(reset),
		.d(MemtoRegM),
		.q(MemtoRegW)
	);
	//END THIRD BLOCK

	// Salidas para el bloque de Hazard
	assign PCWrPendingF = PCSD + PCSE + PCSrcM;


endmodule