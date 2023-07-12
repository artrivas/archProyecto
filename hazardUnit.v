module hazardUnit(
    Match_1E_M,
    Match_1E_W,
    Match_2E_M,
    Match_2E_W,
    Match_12D_E,
    RegWriteM,
    RegWriteW,
	MemtoRegE,
    PCWrPendingF,
    BranchTakenE,
    PCSrcW,
    ForwardAE,
    ForwardBE,
    StallF,
    StallD,
    FlushE,
    FlushD
);
// entradas del control
input wire RegWriteM; // 1 bit
input wire RegWriteW; // 1 bit
input wire MemtoRegE;
input wire PCWrPendingF;
input wire BranchTakenE;
input wire PCSrcW;

// salidas del hazard
output reg [1:0] ForwardAE;
output reg [1:0] ForwardBE;
output wire StallD;
output wire StallF;
output wire FlushE;
output wire FlushD;

// entradas del datapath
input wire Match_1E_M; // 1 bit
input wire Match_1E_W; // 1 bit
input wire Match_2E_M; // 1 bit
input wire Match_2E_W; // 1 bit
input wire Match_12D_E;

// Match_1E_M = (RA1E == WA3M);
// Match_1E_W = (RA1E == WA3W);
// Match_2E_M = (RA2E == WA3M);
// Match_2E_W = (RA2E == WA3W);

wire LDRstall;

always @(*) begin
    if (Match_1E_M&&RegWriteM) // Match_1E_M*RegWriteM
        ForwardAE = 2'b10; // SrcAE = ALUOutM
    else if (Match_1E_W&&RegWriteW) // Match_1E_W*RegWriteW
        ForwardAE = 2'b01; // SrcAE = ResultW
    else
        ForwardAE = 2'b00;
end

always @(*) begin
    if (Match_2E_M&&RegWriteM) // Match_2E_M*RegWriteM
        ForwardBE = 2'b10; // SrcBE = ALUOutM
    else if (Match_2E_W&&RegWriteW) // Match_2E_W*RegWriteW
        ForwardBE = 2'b01; // SrcBE = ResultW
    else
        ForwardBE = 2'b00;
end

assign LDRstall = Match_12D_E&&MemtoRegE;

assign StallF = LDRstall || PCWrPendingF; // 1 bit
assign StallD = LDRstall; // 1 bit
assign FlushE = LDRstall || BranchTakenE; // 1 bit
assign FlushD = PCWrPendingF || PCSrcW || BranchTakenE; // 1 bit

endmodule