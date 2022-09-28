module fifostagetb();
   reg 	      clk, reset;
   reg [7:0]  din;   
   reg 	      rr, aw;
   wire       ar, rw;
   wire [7:0] dout;
      
   fifostage dut(.clk(clk), .reset(reset), .din(din), .dout(dout), .rr(rr), .aw(aw), .ar(ar), .rw(rw));
   
   always
     begin
	clk = 1'b0;
	#5;
	clk = 1'b1;
	#5;
     end
   
   initial
     begin
	
	$dumpfile("trace.vcd");
	$dumpvars(0, fifostagetb);

	reset = 1'b1;
	repeat (3) @(posedge clk);
	
	reset = 1'b0;
	rr    = 1'b0;
	aw    = 1'b0;
	din   = 8'h55;

	repeat (100)
	  begin
	     din = din + 8'h1;	     

	     rr  = 1'b1;
	     aw  = 1'b0;
	
	     while (ar == 1'b0)
	       @(posedge clk);
	     
	     rr = 1'b0;
	     @(posedge clk);
	     
	     while (ar == 1'b1)
	       @(posedge clk);
	     
	     while (rw != 1'b1)
	       @(posedge clk);
	     
	     aw = 1'b1;
	     
	     while (rw != 1'b0)
	       @(posedge clk);
	     
	     aw = 1'b0;
	  end
	
	$finish;
     end
   
endmodule
