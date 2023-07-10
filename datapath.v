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
InstrD,
ALUOutM,
WriteDataM,
ReadDataM
);
input wire clk;module datapath (
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
InstrD,
ALUOutM,
WriteDataM,
ReadDataM,
Match_1E_M,
Match_1E_W,
Match_2E_M,
Match_2E_W,
Match_12D_E,
ForwardAE,
ForwardBE,
StallD,
StallF,
FlushE
);
input wire clk;
input wire reset;
input wire [1:0] RegSrcD;
input wire RegWriteW;
input wire [1:0] ImmSrcD;
input wire ALUSrcE;
input wire [1:0] ALUControlE;
input wire MemtoRegW;
input wire PCSrcW;
input wire [31:0] ReadDataM;
input wire [31:0] InstrF;
output wire [3:0] ALUFlags;
output wire [31:0] PCF;
output wire [31:0] ALUOutM;
output wire [31:0] WriteDataM;
// salidas para el hazard Unit
output wire Match_1E_M;
output wire Match_1E_W;
output wire Match_2E_M;
output wire Match_2E_W;
output wire Match_12D_E;
// inputs del hazard Unit
input wire [1:0] ForwardAE;
input wire [1:0] ForwardBE;
input wire StallD;
input wire StallF;
input wire FlushE;

wire [31:0] ALUResultE;
wire [31:0] PCNext;
wire [31:0] PCPlus4F8D;
wire [31:0] ExtImmD;
wire [31:0] ExtImmE;
wire [31:0] SrcBE;
wire [31:0] SrcAE;
wire [31:0] ResultW;
wire [3:0] RA1;
wire [3:0] RA2;
output wire [31:0] InstrD;
wire [31:0] WriteDataD;
wire [31:0] WriteDataE;
wire [31:0] SrcAD;
wire [3:0] WA3E;
wire [3:0] WA3M;
wire [3:0] WA3W;
wire [31:0] ALUOutW;
wire [31:0] ReadDataW;
wire n_clk = ~clk;

// wire necesarios para el hazard unit
wire [31:0] RD1E;
wire [31:0] RD2E;

//Big Four register


// SE RECIBE LA INSTRUCCION Y EL PC NEXT

mux2 #(32) pcmux(
.d0(PCPlus4F8D),
.d1(ResultW),
.s(PCSrcW),
.y(PCNext)
);

// FETCH

flopenr #(32) pcreg(
.clk(clk),
.reset(reset),
.en(~StallF),
.d(PCNext),
.q(PCF)
);

adder #(32) pcadd(
.a(PCF),
.b(32'b100),
.y(PCPlus4F8D)
);

flopenr #(32) RegInsr(
.clk(clk),
.reset(reset),
.en(~StallD),
.d(InstrF),
.q(InstrD)
);

// DECODE 

mux2 #(4) ra1mux(
.d0(InstrD[19:16]),
.d1(4'b1111),
.s(RegSrcD[0]),
.y(RA1)
);
mux2 #(4) ra2mux(
.d0(InstrD[3:0]),
.d1(InstrD[15:12]),
.s(RegSrcD[1]),
.y(RA2)
);
regfile rf(
.clk(n_clk),
.we3(RegWriteW),
.ra1(RA1),
.ra2(RA2),
.wa3(WA3W),
.wd3(ResultW),
.r15(PCPlus4F8D),
.rd1(SrcAD),
.rd2(WriteDataD)
);

flopenr #(32) RegRD1(
.clk(clk),
.reset(reset),
.en(FlushE),
.d(SrcAD),
.q(RD1E)
);

flopenr #(32) RegRD2(
.clk(clk),
.reset(reset),
.en(FlushE),
.d(WriteDataD),
.q(RD1E)
);

flopenr #(4) RegWA3E(
.clk(clk),
.reset(reset),
.en(FlushE),
.d(InstrD[15:12]),
.q(WA3E)
);

flopenr #(32) RegExtend(
.clk(clk),
.reset(reset),
.en(FlushE),
.d(ExtImmD),
.q(ExtImmE)
);

extend ext(
.Instr(InstrD[23:0]),
.ImmSrc(ImmSrcD),
.ExtImm(ExtImmD)
);

// EXECUTE

mux3 #(32) ForwardAEMux(
    .d0(RD1E),
    .d1(ResultW),
    .d2(ALUOutM),
    .s(ForwardAE),
    .y(SrcAE)
);

mux3 #(32) ForwardBEMux(
    .d0(RD2E),
    .d1(ResultW),
    .d2(ALUOutM),
    .s(ForwardBE),
    .y(WriteDataE)
);

mux2 #(32) srcbmux(
.d0(WriteDataE),
.d1(ExtImmE),
.s(ALUSrcE),
.y(SrcBE)
);
alu alu(
.SrcA(SrcAE),
.SrcB(SrcBE),
.ALUControl(ALUControlE),
.ALUResult(ALUResultE),
.ALUFlags(ALUFlags)
);

flopr #(32) RegAlu(
.clk(clk),
.reset(reset),
.d(ALUResultE),
.q(ALUOutM)
);

flopr #(32) RegWriteDataM(
.clk(clk),
.reset(reset),
.d(WriteDataE),
.q(WriteDataM)
);
flopr #(4) RegWA3M(
.clk(clk),
.reset(reset),
.d(WA3E),
.q(WA3M)
);

// MEMORY

flopr #(32) RegReadData(
.clk(clk),
.reset(reset),
.d(ReadDataM),
.q(ReadDataW)
);
flopr #(32) RegALUOutM(
.clk(clk),
.reset(reset),
.d(ALUOutM),
.q(ALUOutW)
);

flopr #(4) RegWA3W(
.clk(clk),
.reset(reset),
.d(WA3M),
.q(WA3W)
);

// WRITE BACK

mux2 #(32) resmux(
.d0(ALUOutW),
.d1(ReadDataW),
.s(MemtoRegW),
.y(ResultW)
);

// Salidas del Hazard Unit

wire [3:0] RA1E;
wire [3:0] RA2E;

flopr #(4) RA1ERet(
    .clk(clk),
    .reset(reset),
    .d(RA1),
    .q(RA1E)
);

flopr #(4) RA2ERet(
    .clk(clk),
    .reset(reset),
    .d(RA2),
    .q(RA2E)
);

assign Match_1E_M = (RA1E == WA3M);
assign Match_1E_W = (RA1E == WA3W);
assign Match_2E_M = (RA2E == WA3M);
assign Match_2E_W = (RA2E == WA3W);
assign Match_12D_E = (RA1 == WA3E) + (RA2 == WA3E);

endmodule
input wire reset;
input wire [1:0] RegSrcD;
input wire RegWriteW;
input wire [1:0] ImmSrcD;
input wire ALUSrcE;
input wire [1:0] ALUControlE;
input wire MemtoRegW;
input wire PCSrcW;
input wire [31:0] ReadDataM;
input wire [31:0] InstrF;
output wire [3:0] ALUFlags;
output wire [31:0] PCF;
output wire [31:0] ALUOutM;
output wire [31:0] WriteDataM;
wire [31:0] ALUResultE;
wire [31:0] PCNext;
wire [31:0] PCPlus4F8D;
wire [31:0] ExtImmD;
wire [31:0] ExtImmE;
wire [31:0] SrcBE;
wire [31:0] SrcAE;
wire [31:0] ResultW;
wire [3:0] RA1;
wire [3:0] RA2;
output wire [31:0] InstrD;
wire [31:0] WriteDataD;
wire [31:0] WriteDataE;
wire [31:0] SrcAD;
wire [3:0] WA3E;
wire [3:0] WA3M;
wire [3:0] WA3W;
wire [31:0] ALUOutW;
wire [31:0] ReadDataW;
wire n_clk = ~clk;
//Big Four register
flopr #(32) RegInsr(
.clk(clk),
.reset(reset),
.d(InstrF),
.q(InstrD)
);

//2nd Block
flopr #(32) RegRD1(
.clk(clk),
.reset(reset),
.d(SrcAD),
.q(SrcAE)
);

flopr #(32) RegRD2(
.clk(clk),
.reset(reset),
.d(WriteDataD),
.q(WriteDataE)
);

flopr #(32) RegExtend(
.clk(clk),
.reset(reset),
.d(ExtImmD),
.q(ExtImmE)
);

flopr #(4) RegWA3E(
.clk(clk),
.reset(reset),
.d(InstrD[15:12]),
.q(WA3E)
);

//3rd Block
flopr #(32) RegAlu(
.clk(clk),
.reset(reset),
.d(ALUResultE),
.q(ALUOutM)
);

flopr #(32) RegWriteDataM(
.clk(clk),
.reset(reset),
.d(WriteDataE),
.q(WriteDataM)
);
flopr #(4) RegWA3M(
.clk(clk),
.reset(reset),
.d(WA3E),
.q(WA3M)
);
//4th Block
flopr #(32) RegReadData(
.clk(clk),
.reset(reset),
.d(ReadDataM),
.q(ReadDataW)
);
flopr #(32) RegALUOutM(
.clk(clk),
.reset(reset),
.d(ALUOutM),
.q(ALUOutW)
);

flopr #(4) RegWA3W(
.clk(clk),
.reset(reset),
.d(WA3M),
.q(WA3W)
);

//
mux2 #(32) pcmux(
.d0(PCPlus4F8D),
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
adder #(32) pcadd(
.a(PCF),
.b(32'b100),
.y(PCPlus4F8D)
);
mux2 #(4) ra1mux(
.d0(InstrD[19:16]),
.d1(4'b1111),
.s(RegSrcD[0]),
.y(RA1)
);
mux2 #(4) ra2mux(
.d0(InstrD[3:0]),
.d1(InstrD[15:12]),
.s(RegSrcD[1]),
.y(RA2)
);
regfile rf(
.clk(n_clk),
.we3(RegWriteW),
.ra1(RA1),
.ra2(RA2),
.wa3(WA3W),
.wd3(ResultW),
.r15(PCPlus4F8D),
.rd1(SrcAD),
.rd2(WriteDataD)
);
//falta cambiar
mux2 #(32) resmux(
.d0(ALUOutW),
.d1(ReadDataW),
.s(MemtoRegW),
.y(ResultW)
);
extend ext(
.Instr(InstrD[23:0]),
.ImmSrc(ImmSrcD),
.ExtImm(ExtImmD)
);
mux2 #(32) srcbmux(
.d0(WriteDataE),
.d1(ExtImmE),
.s(ALUSrcE),
.y(SrcBE)
);
alu alu(
.SrcA(SrcAE),
.SrcB(SrcBE),
.ALUControl(ALUControlE),
.ALUResult(ALUResultE),
.ALUFlags(ALUFlags)
);
endmodule