module controller (
	clk,
	reset,
	Instr,
	ALUFlags,
	RegSrc,
	RegWrite,
	ImmSrc,
	ALUSrc,
	ALUControl,
	MemWrite,
	MemtoReg,
	PCSrc
);
	input wire clk;
	input wire reset;
	input wire [31:12] Instr;
	input wire [3:0] ALUFlags;
	output wire [1:0] RegSrc;
	output wire RegWrite;
	output wire [1:0] ImmSrc;
	output wire ALUSrc;
	output wire [1:0] ALUControl;
	output wire MemWrite;
	output wire MemtoReg;
	output wire PCSrc;
	
	//wire PCS;

	//Decode
	wire reg PCSrcD;
	wire reg RegWriteD;
	wire reg MemtoRegD;
	wire reg MemWriteD;
	wire reg [1:0] ALUControlD;
	wire reg BranchD;
	wire reg ALUSrcD;
	wire reg [1:0] FlagWriteD;
	wire reg [3:0] CondE;
	wire reg [3:0] FlagsE;
	
	// Execute
	wire reg PCSrcE;
	wire reg RegWriteE;
	wire reg MemtoRegE;
	wire reg MemWriteE;
	wire reg BranchE;
	wire [1:0] FlagWriteE;

	//Memory
	wire reg PCSrcM;
	wire reg RegWriteM;
	wire reg MemtoRegM;

	decode dec(
		.Op(Instr[27:26]),
		.Funct(Instr[25:20]),
		.Rd(Instr[15:12]),
		.FlagW(FlagWriteD),
		.PCS(PCSrcD),
		.RegW(RegWriteD),
		.MemW(MemWriteD),
		.MemtoReg(MemtoRegD),
		.ALUSrc(ALUSrcD),
		.ImmSrc(ImmSrc),
		.RegSrc(RegSrc),
		.ALUControl(ALUControlD),
		.Branch(BranchD)
	);


	//START FIRST BLOCK
	flopr #(1) alusrce(
		.clk(clk),
		.reset(reset),
		.d(ALUSrcD),
		.q(ALUSrc)
	); 

	flopr #(1) regwrite(
		.clk(clk),
		.reset(reset),
		.d(RegWriteD),
		.q(RegWriteE)
	);

	flopr #(1) pcsrc(
		.clk(clk),
		.reset(reset),
		.d(PCSrcD),
		.q(PCSrcE)
	);

	flopr #(1) memtoreg(
		.clk(clk),
		.reset(reset),
		.d(MemtoRegD),
		.q(MemtoRegE)
	);

	flopr #(1) memwrite(
		.clk(clk),
		.reset(reset),
		.d(MemWriteD),
		.q(MemWriteE)
	);

	flopr #(2) alucontrol(
		.clk(clk),
		.reset(reset),
		.d(ALUControlD),
		.q(ALUControl)
	);

	flopr #(1) branch(
		.clk(clk),
		.reset(reset),
		.d(BranchD),
		.q(BranchE)
	);

	flopr #(2) flagwrite(
		.clk(clk),
		.reset(reset),
		.d(FlagWriteD),
		.q(FlagWriteE)
	);

	flopr #(4) conde(
		.clk(clk),
		.reset(reset),
		.d(Instr[31:28]),
		.q(CondE)
	);

	flopr #(4) flagse(
		.clk(clk),
		.reset(reset),
		.d(ALUFlags),
		.q(FlagsE)
	);
	//END FIRST BLOCK

	//START SECOND BLOCK
	flopr #(1) memtoregm(
		.clk(clk),
		.reset(reset),
		.d(MemtoRegE),
		.q(MemtoRegM)
	);

	condlogic cl(
		.clk(clk),
		.reset(reset),
		.Cond(FlagsE),
		.ALUFlags(FlagsE),
		.FlagW(FlagWriteE),
		.PCS(PCSrcE),
		.RegW(RegWriteE),
		.MemW(MemWriteE),
		.PCSrc(PCSrcM),
		.RegWrite(RegWriteM),
		.MemWrite(MemWrite),
		.Branch(BranchE)
	);
	//END SECOND BLOCK

	//START THIRD BLOCK
	flopr #(1) pcsrcw(
		.clk(clk),
		.reset(reset),
		.d(PCSrcM),
		.q(PCSrc)
	);

	flopr #(1) regwritew(
		.clk(clk),
		.reset(reset),
		.d(RegWriteM),
		.q(RegWrite)
	);

	flopr #(1) memtoregw(
		.clk(clk),
		.reset(reset),
		.d(MemtoRegM),
		.q(MemtoReg)
	);
	//END THIRD BLOCK
endmodule