module fifostage(
		 input wire 	   clk,
		 input wire 	   reset,
		 input wire [7:0]  din,
		 output wire [7:0] dout,
		 input wire 	   rr, /* request read */
		 input wire 	   aw, /* ack write    */
		 output wire 	   ar, /* ack read     */
		 output wire 	   rw /*  request write */
		 );
   
   reg [7:0] 			   dreg;
   reg [7:0] 			   dreg_next;

   reg [1:0] 			   state, state_next;
   localparam s0 = 2'b00, s1 = 2'b01, s2 = 2'b10, s3 = 2'b11;
   
   always @(posedge clk, posedge reset)
     if (reset)
       begin
          dreg  <= 8'b0;
	  state <= s0;
       end
     else
       begin
          dreg  <= dreg_next;
	  state <= state_next;
       end

   reg arreg;
   reg rwreg;
   
   always @(*)
     begin

	state_next = state;
	dreg_next  = dreg;
	arreg = 1'b0;
	rwreg = 1'b0;
	
	case (state)

	  s0:
	    begin
	       arreg = 1'b0;
	       rwreg = 1'b0;
	       
	       if (rr)
		 state_next = s1;
	    end
	  
	  s1:
	    begin
	       arreg = 1'b1;
	       rwreg = 1'b0;
	       dreg_next = din;
	       			  
	       if (~rr)
		 state_next = s2;
	    end
	  
	  s2:
	    begin
	       arreg = 1'b0;
	       rwreg = 1'b1;
	       
	       if (aw)
		 state_next = s3;
	    end
	  
	  s3:
	    begin
	       arreg = 1'b0;
	       rwreg = 1'b0;
	       
	       if (~aw)
		 state_next = s0;
	    end
	  
	endcase
     end
   
   assign dout = dreg;
   assign rw   = rwreg;
   assign ar   = arreg;

   
endmodule
