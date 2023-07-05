module testbench;
	reg clk;
	reg reset;
	reg PCSrc;
	reg MemtoReg;
	reg RegWrite;
	reg ALUSrc;
	reg [1:0] RegSrc;
	reg [1:0] ImmSrc;
	reg [1:0] ALUControl;
	reg [31:0] Instr;
	reg [31:0] ReadData;
	wire [3:0] ALUFlags;
	wire [31:0] PC;
	wire [31:0] ALUResult;
	wire [31:0] WriteData;


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
	 
	initial begin
		//Cycle 0
		clk = 1; reset = 1; PCSrc = 0; MemtoReg = 0; RegWrite = 0; ALUSrc = 0; RegSrc = 0;ImmSrc=0;ALUControl=0; Instr = 0; 
		#5 clk = 0; reset = 1;PCSrc = 0; MemtoReg = 0; RegWrite = 0; ALUSrc = 0; RegSrc = 0;ImmSrc=0;ALUControl=0; Instr = 0;		
		//Cycle 1
		#5 clk = 1; reset = 0;PCSrc = 0; MemtoReg = 0; RegWrite = 1; ALUSrc = 0; RegSrc = 1;ImmSrc=0;ALUControl=0; Instr = 32'hE04F000F;
		#5 clk = 0; reset = 0; PCSrc = 0; MemtoReg = 0; RegWrite = 1; ALUSrc = 0; RegSrc = 1;ImmSrc=0;ALUControl=0; Instr = 32'hE04F000F;
		//Cycle 2
		#5 clk = 1; reset = 0; PCSrc = 0; MemtoReg = 0; RegWrite = 1; ALUSrc = 0; RegSrc = 1;ImmSrc=0;ALUControl=0; Instr = 32'hE04F100F;
		#5 clk = 0; reset = 0; PCSrc = 0; MemtoReg = 0; RegWrite = 1; ALUSrc = 0; RegSrc = 1;ImmSrc=0;ALUControl=0; Instr = 32'hE04F100F;
		//Cycle 3
		#5 clk = 1; reset = 0; PCSrc = 0; MemtoReg = 0; RegWrite = 1; ALUSrc = 0; RegSrc = 2;ImmSrc=0;ALUControl=1; Instr = 32'hE2800009;
		#5 clk = 0; reset = 0; PCSrc = 0; MemtoReg = 0; RegWrite = 1; ALUSrc = 0; RegSrc = 2;ImmSrc=0;ALUControl=1; Instr = 32'hE2800009;
		//Cycle 4
		#5 clk = 1; reset = 0; PCSrc = 0; MemtoReg = 0; RegWrite = 1; ALUSrc = 0; RegSrc = 2;ImmSrc=0;ALUControl=1; Instr = 32'hE281100D;
		#5 clk = 0; reset = 0; PCSrc = 0; MemtoReg = 0; RegWrite = 1; ALUSrc = 0; RegSrc = 2;ImmSrc=0;ALUControl=1; Instr = 32'hE281100D;
		//Cycle 5
		#5 clk = 1; reset = 0; PCSrc = 0; MemtoReg = 0; RegWrite = 1; ALUSrc = 1; RegSrc = 2;ImmSrc=0;ALUControl=1; Instr = 32'hE281100D;
		#5 clk = 0; reset = 0; PCSrc = 0; MemtoReg = 0; RegWrite = 1; ALUSrc = 1; RegSrc = 2;ImmSrc=0;ALUControl=1; Instr = 32'hE281100D;
		//Cycle 6
		#5 clk = 1; reset = 0; PCSrc = 0; MemtoReg = 0; RegWrite = 1; ALUSrc = 1; RegSrc = 2;ImmSrc=0;ALUControl=1; Instr = 32'hE281100D;
		#5 clk = 0; reset = 0; PCSrc = 0; MemtoReg = 0; RegWrite = 1; ALUSrc = 1; RegSrc = 2;ImmSrc=0;ALUControl=1; Instr = 32'hE281100D;
		//Cycle 7
		#5 clk = 1; reset = 0; PCSrc = 0; MemtoReg = 0; RegWrite = 1; ALUSrc = 1; RegSrc = 2;ImmSrc=0;ALUControl=1; Instr = 32'hE281100D;
		#5 clk = 0; reset = 0; PCSrc = 0; MemtoReg = 0; RegWrite = 1; ALUSrc = 1; RegSrc = 2;ImmSrc=0;ALUControl=1; Instr = 32'hE281100D;
		//Cycle 8
		#5 clk = 1; reset = 0; PCSrc = 0; MemtoReg = 0; RegWrite = 1; ALUSrc = 1; RegSrc = 2;ImmSrc=0;ALUControl=1; Instr = 32'hE281100D;
		#5 clk = 0; reset = 0; PCSrc = 0; MemtoReg = 0; RegWrite = 1; ALUSrc = 1; RegSrc = 2;ImmSrc=0;ALUControl=1; Instr = 32'hE281100D;
		//Cycle 9
		#5 clk = 1; reset = 0; PCSrc = 0; MemtoReg = 0; RegWrite = 1; ALUSrc = 1; RegSrc = 2;ImmSrc=0;ALUControl=1; Instr = 32'hE281100D;
		#5 clk = 0; reset = 0; PCSrc = 0; MemtoReg = 0; RegWrite = 1; ALUSrc = 1; RegSrc = 2;ImmSrc=0;ALUControl=1; Instr = 32'hE281100D;
		end
    
    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;
    end
    
endmodule
