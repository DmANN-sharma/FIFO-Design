`timescale 1ns/1ns

module fifo_mem 
    #(parameter DATA_WIDTH = 8,
      parameter ADDR_SIZE  = 4)
    (
        output reg [DATA_WIDTH-1:0] rd_data,

    //isko apan always block ke ander assign kar raha  hai
    
        input                       rd_ena,
        input                       wrt_clk,
        input  [DATA_WIDTH-1:0]     wrt_data,
        input  [ADDR_SIZE-1:0]      wrt_addr,
        input  [ADDR_SIZE-1:0]      rd_addr,
        input                       wrt_ena,
        input                       wrt_full
    );

    // Calculate the depth of the memory
    localparam DEPTH = 1 << ADDR_SIZE;

    // Memory array declaration
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    // Write operation
    always @(posedge wrt_clk) begin   // write operation is done at write clock only
        if (wrt_ena && !wrt_full) 
            mem[wrt_addr] <= wrt_data;
    end

    // Read operation
    always @(*) begin     // read operation is asynchronous in nature
        if (rd_ena)
            rd_data = mem[rd_addr];
        else
            rd_data = 0;
    end

endmodule
// Memory Depth Calculation:

// Changed DEPTH = (ADDR_SIZE<<1) to DEPTH = 1 << ADDR_SIZE, which correctly calculates the memory depth based on the address size.
// Memory Array:

// The memory array mem is declared as reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];, where DEPTH is the number of memory locations.
// Write Operation:

// The always block triggered by wrt_clk only updates the memory location at wrt_addr with wrt_data if wrt_ena is high and wrt_full is low.
// Read Operation:

// The read operation is simplified using a combinational always block, which updates rd_data based on the value at rd_addr if rd_ena is high. If rd_ena is low, rd_data is set to 0.