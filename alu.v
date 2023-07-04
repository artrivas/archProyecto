module alu(SrcA,SrcB,ALUControl,ALUResult,ALUFlags);
//Input and outputs
input [31:0] SrcA,SrcB;
input [1:0] ALUControl;
output wire [3:0] ALUFlags;
output reg [31:0] ALUResult; //Resultado de 8 bits, 1 bit para el signo y los 4 bits para la suma de los numeros

//Wire and reg
wire  neg,zero,carry,overflow;
wire [32:0] sum; //Un bit adicional para el overflow

assign sum = SrcA + (ALUControl[0] ? (~SrcB+1): SrcB ); 

always @(*)
begin
    case(ALUControl)
        2'b00: ALUResult  = sum;
        2'b01: ALUResult  = sum;
        2'b10: ALUResult = SrcA&SrcB;
        2'b11: ALUResult = SrcA | SrcB;
    endcase
end

assign neg      = ALUResult[31];
assign zero     = ALUResult == 0;
assign carry    = ~ALUControl[1] & sum[32];
assign overflow = ~ALUControl[1] & ~(SrcA[31] ^ SrcB[31] ^ ALUControl[0]) & (SrcA[31] ^ sum[31]);

assign ALUFlags = {neg, zero, carry, overflow};

endmodule

