module decode (
	clk,
	reset,
	Op,
	Funct,
	Rd,
	PCSrcD,
	RegWriteD,
	MemtoRegW,
	MemWriteD,
	ALUControlD,
	BranchD,
	ALUSrcD,
	FlagWriteD,
	ImmSrcD,
	RegSrcD
);
	input wire clk;
	input wire reset;
	input wire [1:0] Op;
	input wire [5:0] Funct;
	input wire [3:0] Rd;
	output wire PCSrcD;
	output wire RegWriteD;
	output wire MemtoRegD;
	output wire MemWriteD;
	output reg [1:0] ALUControlD;
	output wire BranchD;
	output wire [1:0] ALUSrcD;
	output reg [1:0] FlagWriteD;
	output wire [1:0] ImmSrcD;
	output wire [1:0] RegSrcD;
	
	wire ALUOp;

	// Main FSM
	mainfsm fsm(
		.clk(clk),
		.reset(reset),
		.Op(Op),
		.Funct(Funct),
		.IRWrite(IRWrite),
		.AdrSrc(AdrSrc),
		.ALUSrcA(ALUSrcA),
		.ALUSrcB(ALUSrcB),
		.ResultSrc(ResultSrc),
		.NextPC(NextPC),
		.RegW(RegW),
		.MemW(MemW),
		.Branch(Branch),
		.ALUOp(ALUOp)
	);doki-theme.theme.wallpaper.Zero Two Dark Obsidian

	// ALU Decoder
	always @(*)
		if (ALUOp) begin
			case (Funct[4:1])
				4'b0100: ALUControlD = 2'b00;
				4'b0010: ALUControlD = 2'b01;
				4'b0000: ALUControlD = 2'b10;
				4'b1100: ALUControlD = 2'b11;
				default: ALUControlD = 2'bxx;
			endcase
			FlagWD[1] = Funct[0];
			FlagWD[0] = Funct[0] & ((ALUControlD == 2'b00) | (ALUControlD == 2'b01));
		end
		else begin
			ALUControlD = 2'b00;
			FlagWD = 2'b00;
		end
	assign PCSD = ((Rd == 4'b1111) & RegW) | BranchD;

	// Instruction decoder for ImmSrc and RegSrc
	assign ImmSrcD = Op;
	assign RegSrcD[0] = Op == 2'b10;
	assign RegSrcD[1] = Op == 2'b01;
endmodule