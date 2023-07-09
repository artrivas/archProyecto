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
	MemtoRegW,
	PCSrcW
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
	wire MemtoRegE;
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
	wire RegWriteM; //Changed
	wire MemtoRegM;
	output wire MemWriteM; //Changed

	//WriteBack
	output wire PCSrcW; //Changed
	output wire RegWriteW;
	output wire MemtoRegW; //Changed


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

	flopr #(1) ModPCSE(
		.clk(clk),
		.reset(reset),
		.d(PCSD),
		.q(PCSE)
	);

	flopr #(1) ModRegWriteE(
		.clk(clk),
		.reset(reset),
		.d(RegWriteD),
		.q(RegWriteE)
	);

	flopr #(1) ModMemtoRegE(
		.clk(clk),
		.reset(reset),
		.d(MemtoRegD),
		.q(MemtoRegE)
	);

	flopr #(1) ModMemWriteE(
		.clk(clk),
		.reset(reset),
		.d(MemWriteD),
		.q(MemWriteE)
	);

	flopr #(2) ModAluControlE(
		.clk(clk),
		.reset(reset),
		.d(ALUControlD),
		.q(ALUControlE)
	);

	flopr #(1) ModBranchE(
		.clk(clk),
		.reset(reset),
		.d(BranchD),
		.q(BranchE)
	);

	flopr #(1) ModAluSrcE(
		.clk(clk),
		.reset(reset),
		.d(ALUSrcD),
		.q(ALUSrcE)
	); 

	flopr #(2) ModFlagWriteE(
		.clk(clk),
		.reset(reset),
		.d(FlagWriteD),
		.q(FlagWriteE)
	);

	flopr #(4) ModCondE(
		.clk(clk),
		.reset(reset),
		.d(Instr[31:28]),
		.q(CondE)
	);

	flopr #(4) ModFlagsE(
		.clk(clk),
		.reset(reset),
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
		.MemWrite(MemWriteBM)
		
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
endmodule