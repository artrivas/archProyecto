module blockC1 (
	clk,
	reset,
	d0,
    d1,
    d2,
    d3,
    d4,
    d5,
    d6,
    d7,
    d8,
    d9,
	q0,
    q1,
    q2,
    q3,
    q4,
    q5,
    q6,
    q7,
    q8,
    q9
);
	parameter WIDTH = 1;
    parameter WIDTH1 = 2;
    parameter WIDTH2 = 4;
	input wire clk;
	input wire reset;
	input wire [WIDTH - 1:0] d0;
	input wire [WIDTH - 1:0] d1;
    input wire [WIDTH - 1:0] d2;
    input wire [WIDTH - 1:0] d3;
    input wire [WIDTH1 - 1:0] d4;
    input wire [WIDTH - 1:0] d5;
    input wire [WIDTH1 - 1:0] d6;
    input wire [WIDTH - 1:0] d7;
    input wire [WIDTH2 - 1:0] d8;
    input wire [WIDTH - 1:0] d9;
	output reg [WIDTH - 1:0] q0;
	output reg [WIDTH - 1:0] q1;
	output reg [WIDTH - 1:0] q2;
	output reg [WIDTH - 1:0] q3;
	output reg [WIDTH - 1:0] q4;
	output reg [WIDTH - 1:0] q5;
	output reg [WIDTH - 1:0] q6;
	output reg [WIDTH - 1:0] q7;
	output reg [WIDTH - 1:0] q8;
	output reg [WIDTH1 - 1:0] q9;
	always @(posedge clk or posedge reset)
		if (reset) begin
			q0 <= 0;
            q1 <= 0;
            q2 <= 0;
            q3 <= 0;
            q4 <= 0;
            q5 <= 0;
            q6 <= 0;
            q7 <= 0;
            q8 <= 0;
            q9 <= 0;
        end
		else begin
			q0 <= d0;
            q1 <= d1;
            q2 <= d2;
            q3 <= d3;
            q4 <= d4;
            q5 <= d5;
            q6 <= d6;
            q7 <= d7;
            q8 <= d8;
            q9 <= d9;
        end
endmodule