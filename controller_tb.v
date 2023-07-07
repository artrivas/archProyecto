`timescale 1ns/1ns

module controller_tb;
  reg clk;
	reg reset;
	reg [31:12] Instr;
	reg [3:0] ALUFlags;
	wire [1:0] RegSrc;
	wire RegWrite;
	wire [1:0] ImmSrc;
	wire ALUSrc;
	wire [1:0] ALUControl;
	wire MemWrite;
	wire MemtoReg;
	wire PCSrc;

  controller dut (
    .clk(clk),
    .reset(reset),
    .Instr(Instr),
    .ALUFlags(ALUFlags),
    .RegSrc(RegSrc),
    .RegWrite(RegWrite),
    .ImmSrc(ImmSrc), 
    .ALUSrc(ALUSrc),
    .ALUControl(ALUControl),
    .MemWrite(MemWrite),
    .MemtoReg(MemtoReg),
    .PCSrc(PCSrc)
  );

 
  initial begin
       
       clk=0; ALUFlags=0000; Instr = 32'hEA000;
    #1 clk=1; //Instr = 32'hE2802;
    #1 clk=0; //Instr = 32'hE2803;
    #1 clk=1; //Instr = 32'hE2437;
    #1 clk=0; //Instr = 32'hE1874;
    #1 clk=1; //Instr = 32'hE0035;
    #1 clk=0; //Instr = 32'hE0855;
    #1 clk=1; //Instr = 32'hE0558;
    #1 clk=0; //Instr = 32'h0A000;
    #1 clk=1; //Instr = 32'hE0538;
    #1 clk=0; //Instr = 32'hAA000;
    #1 clk=1; //Instr = 32'hE2805;
    $finish;
  end
 
  initial begin
    $dumpfile("controller_tb.vcd");
    $dumpvars;
  end
endmodule