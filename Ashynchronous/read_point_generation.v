`timescale 1ns/1ns

module read_pointer_generation
    #(parameter ADDR_SIZE = 4)
    (
        output reg              rd_empty,
        output [ADDR_SIZE-1:0]  rd_addr,
        output reg [ADDR_SIZE:0] rd_ptr,
        input  [ADDR_SIZE:0]    sync_wrt_ptr,
        input                   rd_ena,
        input                   rd_clk,
        input                   rd_rst
    );

    reg  [ADDR_SIZE:0] rd_bin;
    wire [ADDR_SIZE:0] rd_bin_nxt, rd_gray_nxt;
    wire              rd_empty_val;

  always @(posedge rd_clk or posedge rd_rst) begin
    if (rd_rst) begin
        // Reset conditions for both the read pointer and the binary counter
        rd_bin <= 0;
        rd_ptr <= 0;
        rd_empty <= 1'b1;
    end else begin
        // Update logic for both the read pointer and binary counter
        rd_bin <= rd_bin_nxt;
        ///////////////////////////////////////////
        rd_ptr <= rd_gray_nxt;
        ///////////////////////////////////////////
        rd_empty <= rd_empty_val;
    end
end


    // Calculate next binary value: increment if not empty and read is enabled
    assign rd_bin_nxt = rd_bin + (rd_ena & ~rd_empty);
// rd_bin_nxt: The next binary pointer is simply the current binary pointer (rd_bin) incremented by 1 
// if rd_ena is high and the FIFO is not empty (~rd_empty).
//  This condition is straightforward and directly tied to whether the FIFO can be read from.

    // Convert binary to Gray code
    assign rd_gray_nxt = rd_bin_nxt ^ (rd_bin_nxt >> 1);
// rd_gray_nxt: This converts the next binary pointer (rd_bin_nxt) to Gray code using the formula
//  rd_bin_nxt ^ (rd_bin_nxt >> 1). This remains a direct and efficient way to 
//  convert binary to Gray code.
   
    // Check if FIFO is empty by comparing pointers
    assign rd_empty_val = (sync_wrt_ptr == rd_gray_nxt);
 
// rd_empty_val: The FIFO is considered empty if the synchronized write pointer (sync_wrt_ptr) 
// equals the Gray-coded read pointer (rd_gray_nxt). This condition is checked directly.   
// Output the current read address

    assign rd_addr = rd_bin[ADDR_SIZE-1:0];

endmodule

// This is a comment in asynchronous module