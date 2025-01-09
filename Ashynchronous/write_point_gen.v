`timescale 1ns/1ns

module write_pointer_gen 
    #(
        parameter ADDR_SIZE = 4
    )
    (
        output reg [ADDR_SIZE-1:0] wrt_addr,
        output reg wrt_full,
        output reg [ADDR_SIZE:0] wrt_ptr,
        input [ADDR_SIZE:0] sync_rd_ptr,
        input wrt_inc,
        input wrt_clk,
        input wrt_rst
    );

    reg [ADDR_SIZE:0] wrt_bin;   // isko bus register declare kiya.........
    wire [ADDR_SIZE:0] wrt_bin_nxt, wrt_gray_nxt;
    wire wrt_full_val;

    always @(posedge wrt_clk or posedge wrt_rst) begin
        if (wrt_rst) begin
            wrt_bin <= 0;
            wrt_ptr <= 0;
            wrt_full <= 1'b0;
        end else begin
            wrt_bin <= wrt_bin_nxt;
            wrt_ptr <= wrt_gray_nxt;
            wrt_full <= wrt_full_val;
        end
    end

    assign wrt_addr = wrt_bin[ADDR_SIZE-1:0];
    assign wrt_bin_nxt = wrt_bin + (wrt_inc & !wrt_full);
    assign wrt_gray_nxt = (wrt_bin_nxt >> 1) ^ wrt_bin_nxt;
    assign wrt_full_val = (wrt_gray_nxt == {~sync_rd_ptr[ADDR_SIZE:ADDR_SIZE-1], sync_rd_ptr[ADDR_SIZE-2:0]});

endmodule