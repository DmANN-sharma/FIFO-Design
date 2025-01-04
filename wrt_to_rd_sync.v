`timescale 1ns/1ns

module wrt_to_rd_sync
    #(parameter ADDR_SIZE = 4)
    (
        output reg [ADDR_SIZE:0] sync_wrt_ptr,
        input      [ADDR_SIZE:0] wrt_ptr,
        input                    rd_clk,
        input                    rd_rst
    );

    reg [ADDR_SIZE:0] wrt_temp_ptr;

    // Synchronize write pointer into the read clock domain
    always @(posedge rd_clk or posedge rd_rst) begin
        if (rd_rst) begin
            sync_wrt_ptr <= 0;
            wrt_temp_ptr <= 0;
        end else begin
            sync_wrt_ptr <= wrt_temp_ptr;
            wrt_temp_ptr <= wrt_ptr;
        end
    end

endmodule