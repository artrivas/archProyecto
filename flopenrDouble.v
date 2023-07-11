module flopenrDouble (
	clk,
	reset,
	en0,
    en1,
	d,
	q
);
	parameter WIDTH = 8;
	input wire clk;
	input wire reset;
	input wire en0;
	input wire en1;
	input wire [WIDTH - 1:0] d;
	output reg [WIDTH - 1:0] q;
	always @(posedge clk or posedge reset)
		if (reset)
			q <= 0;
		else if (en0 | en1)
			q <= d;
endmodule