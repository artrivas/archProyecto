module blockDPclk2 (
	clk,
	reset,
	d0,
    d1,
    d2,
	q0,
    q1,
    q2
);
	parameter WIDTH = 32;
	input wire clk;
	input wire reset;
	input wire [WIDTH - 1:0] d0; // 32 bits
	input wire [WIDTH - 1:0] d1; // 32 bits
    input wire [WIDTH - 29:0] d2; // 4 bits
	output reg [WIDTH - 1:0] q0; // 32 bits
	output reg [WIDTH - 1:0] q1; // 32 bits
	output reg [WIDTH - 29:0] q2; // 4 bits
	always @(posedge clk or posedge reset)
		if (reset) begin
			q0 <= 0;
            q1 <= 0;
            q2 <= 0;
        end
		else begin
			q0 <= d0;
            q1 <= d1;
            q2 <= d2;
        end
endmodule
