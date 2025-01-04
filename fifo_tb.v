// in synchronkus fifo,if we are comapring read and write pointer then they  can be
// compared easily as both will change at same time so condition of metastablity will not arise
//we need to synchronize read and write pointer for the purpose of comparision
// in gray  code conversion only one bit changes
// to  chances of false full reduces
`timescale 1ns/1ns

module fifo_tb ;

localparam DATA_WIDTH = 8;
localparam ADDR_SIZE  = 4;

  wire  [DATA_WIDTH-1:0] rd_data;
  wire  		 rd_empty;
  wire 			 wrt_full;
  reg   [DATA_WIDTH-1:0] wrt_data;
  reg	   		 rd_clk, rd_rst, rd_ena;
  reg 			 wrt_clk, wrt_rst, wrt_ena;

  fifo_top_module  #(.DATA_WIDTH(DATA_WIDTH),.ADDR_SIZE(ADDR_SIZE)) dut(
  .*);
// generate read clock in simulation
  initial begin
		    rd_clk <= 1'b0;
	forever #10  rd_clk <= ~rd_clk;
  end
//generate write clock in silumatiomj
  initial begin
		    wrt_clk <= 1'b0;
	forever #5 wrt_clk <= ~wrt_clk;
  end

 initial begin
	wrt_rst <=1'b1;
	rd_rst  <=1'b1;
	wrt_ena <=1'b0;
 	rd_ena  <=1'b0;
	   
	#30 wrt_rst <=1'b0;
	rd_rst  <=1'b0;

      @(posedge wrt_clk);
	wrt_ena=1'b1;
	wrt_data = 8'hAB;

      @(posedge wrt_clk);
	wrt_data = 8'hDE;

      @(posedge wrt_clk);
	wrt_data = 8'h01;	

      @(posedge wrt_clk);
	wrt_data = 8'h99;

      @(posedge wrt_clk);
	wrt_data = 8'hEF;

      @(posedge wrt_clk);
	wrt_data = 8'h69;

      @(posedge wrt_clk);
	wrt_data = 8'hBB;

      @(posedge wrt_clk);
	wrt_data = 8'h10;

      @(posedge wrt_clk);
	wrt_data = 8'h89;

      @(posedge wrt_clk);
	wrt_data = 8'h55;

      @(posedge wrt_clk);
	wrt_data = 8'hC9;

	repeat(5)@(posedge rd_clk);
	wrt_ena  = 1'b0;

       @(posedge rd_clk);
	rd_ena = 1'b1;

	repeat(10) @(posedge rd_clk);
	rd_ena = 1'b0;
end

endmodule