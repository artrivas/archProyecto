module testbench;
	reg clk;
	reg reset;
	wire [31:0] WriteData;
	wire [31:0] DataAdr;
	wire MemWrite;
	top dut(
		.clk(clk),
		.reset(reset),
		.WriteData(WriteData),
		.DataAdr(DataAdr),
		.MemWrite(MemWrite)
	);
	initial begin
		reset <= 1;
		#(22)
			;
		reset <= 0;
	end
	always begin
		clk <= 1;
		#(5)
			;
		clk <= 0;
		#(5)
			;
	end
    
	always @(negedge clk)
		if (MemWrite)
		begin
			if (WriteData === 7) begin
				$display("Simulation succeeded123");
				$finish;
			end
		end
    always begin
	  #(500) $finish;
	end    
    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;
    end
    
endmodule