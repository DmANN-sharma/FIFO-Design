`timescale 1ns/1ns

module rd_to_wrt_sync 
	#(parameter ADDR_SIZE = 4)
	 (output reg [ADDR_SIZE:0] sync_rd_ptr,
	  input      [ADDR_SIZE:0] rd_ptr,
	  input 		   wrt_clk, wrt_rst);

		reg [ADDR_SIZE:0] rd_temp_ptr;
		
		always@(posedge wrt_clk , posedge wrt_rst) begin
			if(wrt_rst) 
				{sync_rd_ptr,rd_temp_ptr} <= 0;
			else
				{sync_rd_ptr,rd_temp_ptr} <= {rd_temp_ptr,rd_ptr};		
		end
	  
 endmodule