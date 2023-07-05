module datapath (
    clk,
    reset,
    RegSrc,
    RegWrite,
    ImmSrc,
    ALUSrc,
    ALUControl,
    MemtoReg,
    PCSrc,
    ALUFlags,
    PC,
    Instr,
    ALUOut,
    WD,
    ReadData
);

    input wire clk;
    input wire reset;
    input wire [1:0] RegSrc;
    input wire RegWrite;
    input wire [1:0] ImmSrc;
    input wire ALUSrc;
    input wire [1:0] ALUControl;
    input wire MemtoReg;
    input wire PCSrc;
    output wire [3:0] ALUFlags;
    output wire [31:0] PC;
    input wire [31:0] Instr;
    wire [31:0] ALUResult;
    output wire [31:0] ALUOut;
    wire [31:0] WriteData;
    input wire [31:0] ReadData;

    wire [31:0] PCNext;
    wire [31:0] PCPlus4;
    wire [31:0] PCPlus8;
    wire [31:0] ExtImm;
    wire [31:0] SrcA;
    wire [31:0] SrcB;
    wire [31:0] Result;
    wire [3:0] RA1;
    wire [3:0] RA2;

    //Decode
    wire reg [31:0] InstrD;

    //Execute
    wire reg [31:0] SrcAE;
    wire reg [31:0] WriteDataE;
    wire reg [31:0] ExtImmE;
    wire reg [3:0] WA3E;

    //Memory
    wire reg [31:0] ALUOutM;
    wire reg [3:0] WA3M;
    output wire [31:0] WD;

    //Writeback
    wire reg [31:0] ReadDataW;
    wire reg [31:0] ALUOutW;
    wire reg [3:0] WA3W;

    mux2 #(32) pcmux(
        .d0(PCPlus4),
        .d1(Result),
        .s(PCSrc),
        .y(PCNext)
    );

    flopr #(32) pcreg(
        .clk(clk),
        .reset(reset),
        .d(PCNext),
        .q(PC)
    );

    adder #(32) pcadd1(
        .a(PC),
        .b(32'b100),
        .y(PCPlus4)
    );

    //START FIRST REGISTER
    flopr #(32) instrd(
        .clk(clk),
        .reset(reset),
        .d(Instr),
        .q(InstrD)
    );
    //END FIRST REGISTER

    adder #(32) pcadd2(
        .a(PCPlus4),
        .b(32'b100),
        .y(PCPlus8)
    );

    mux2 #(4) ra1mux(
        .d0(InstrD[19:16]),
        .d1(4'b1111),
        .s(RegSrc[0]),
        .y(RA1)
    );

    mux2 #(4) ra2mux(
        .d0(InstrD[3:0]),
        .d1(InstrD[15:12]),
        .s(RegSrc[1]),
        .y(RA2)
    );

    regfile rf(
        .clk(~clk),
        .we3(RegWrite),
        .ra1(RA1),
        .ra2(RA2),
        .wa3(WA3W),
        .wd3(Result),
        .r15(PCPlus8),
        .rd1(SrcA),
        .rd2(WriteData)
    );

    extend ext(
        .Instr(InstrD[23:0]),
        .ImmSrc(ImmSrc),
        .ExtImm(ExtImm)
    );

    //START SECOND REGISTER
    flopr #(32) srcae(
        .clk(clk),
        .reset(reset),
        .d(SrcA),
        .q(SrcAE)
    );

    flopr #(32) writedatae(
        .clk(clk),
        .reset(reset),
        .d(WriteData),
        .q(WriteDataE)
    );

    flopr #(32) extimme(
        .clk(clk),
        .reset(reset),
        .d(ExtImm),
        .q(ExtImmE)
    );

    flopr #(4) wa3e(
        .clk(clk),
        .reset(reset),
        .d(Instr[15:12]),
        .q(WA3E)
    );
    //END SECOND REGISTER

    mux2 #(32) srcbmux(
        .d0(WriteDataE),
        .d1(ExtImmE),
        .s(ALUSrc),
        .y(SrcB)
    );

    alu alu(
        .SrcA(SrcA),
        .SrcB(SrcB),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .ALUFlags(ALUFlags)
    );

    //START THIRD BLOCK
    flopr #(4) wa3m(
        .clk(clk),
        .reset(reset),
        .d(WA3E),
        .q(WA3M)
    );

    flopr #(32) aluoutm(
        .clk(clk),
        .reset(reset),
        .d(ALUResult),
        .q(ALUOutM)
    );

    flopr #(32) wd(
        .clk(clk),
        .reset(reset),
        .d(WriteDataE),
        .q(WD)
    );

    //END THIRD BLOCK

    assign ALUOut = ALUOutM;

    //START FOURTH BLOCK
    flopr #(32) readdataw(
        .clk(clk),
        .reset(reset),
        .d(ReadData),
        .q(ReadDataW)
    );

    flopr #(32) aluoutw(
        .clk(clk),
        .reset(reset),
        .d(ALUOutM),
        .q(ALUOutW)
    );

    flopr #(4) wa3w(
        .clk(clk),
        .reset(reset),
        .d(WA3M),
        .q(WA3W)
    );
    //END FOURTH BLOCK

    mux2 #(32) resmux(
        .d0(ALUOutW),
        .d1(ReadDataW),
        .s(MemtoReg),
        .y(Result)
    );

endmodule