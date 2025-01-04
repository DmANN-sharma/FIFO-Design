`timescale 1ns/1ns

module fifo_top_module
    #(
        parameter ADDR_SIZE  = 4,   // Size of address bus
        parameter DATA_WIDTH = 8    // Width of data bus
    )
    (
        output  [DATA_WIDTH-1:0] fifo_read_data, // FIFO read data output
        output                    fifo_is_empty,  // FIFO empty flag
        output                    fifo_is_full,   // FIFO full flag
        input   [DATA_WIDTH-1:0] fifo_write_data, // FIFO write data input
        input                     read_clock,     // Read clock
        input                     read_reset,     // Read reset
        input                     read_enable,    // Read enable
        input                     write_clock,    // Write clock
        input                     write_reset,    // Write reset
        input                     write_enable    // Write enable
    );

    // Internal signals
    wire [ADDR_SIZE:0] write_pointer, read_pointer;
    wire [ADDR_SIZE:0] synced_read_pointer, synced_write_pointer;
    wire [ADDR_SIZE-1:0] write_address, read_address;

    // FIFO Memory Instance
    fifo_mem #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_SIZE(ADDR_SIZE)
    ) fifo_memory_inst (
        .rd_enable(read_enable),
        .rd_data(fifo_read_data),
        .wr_data(fifo_write_data),
        .wrt_clk(write_clock),
        .wrt_ena(write_enable),
        .rd_addr(read_address),// calculate from read pointer genration module
        .wrt_addr(write_address),// calculate from write pointer genration module
        .wrt_full(fifo_is_full)// calculate from read pointer genration module
    );

    // Write Pointer Generator Instance
    write_pointer_gen #(
        .ADDR_SIZE(ADDR_SIZE)
    ) write_pointer_gen_inst (
        .write_address(write_address),
        .write_pointer(write_pointer),
        .fifo_full(fifo_is_full),
        .sync_read_pointer(synced_read_pointer),
        .wrt_clk(write_clock),
        .wrt_ena(write_enable),
        .wrt_rst(write_reset)
    );

    // Read Pointer Generator Instance
    read_pointer_gen #(
        .ADDR_SIZE(ADDR_SIZE)
    ) read_pointer_gen_inst (
        .fifo_empty(fifo_is_empty),
        .read_pointer(read_pointer),
        .read_address(read_address),
        .sync_write_pointer(synced_write_pointer),
        .rd_clk(read_clock),
        .rd_ena(read_enable),
        .rd_rst(read_reset)
    );

    // Read Pointer to Write Clock Domain Synchronizer
    rd_to_wrt_sync #(
        .ADDR_SIZE(ADDR_SIZE)
    ) read_to_write_sync_inst (
        .sync_read_pointer(synced_read_pointer),
        .read_pointer(read_pointer),                /// from read pointer genration module
        .wrt_clk(write_clock),
        .wrt_rst(write_reset)
    );

    // Write Pointer to Read Clock Domain Synchronizer
    wrt_to_rd_sync #(
        .ADDR_SIZE(ADDR_SIZE)
    ) write_to_read_sync_inst (
        .sync_write_pointer(synced_write_pointer),
        .write_pointer(write_pointer),                // from write pointer genration module
        .rd_clk(read_clock),
        .rd_rst(read_reset)
    );

endmodule


//---------------------------------------------------------------------------------------------------------
//Submodule Instantiation:

// fifo_mem: Handles the memory operations of the FIFO, writing data to and reading data from the memory.
// write_pointer_gen: Generates the write pointer, controls the write address, and indicates if the FIFO is full.
// read_pointer_generation: Generates the read pointer, controls the read address, and indicates if the FIFO is empty.
// rd_to_wrt_sync: Synchronizes the read pointer to the write clock domain.
// wrt_to_rd_sync: Synchronizes the write pointer to the read clock domain.
// Parameterization:

// The module is parameterized by ADDR_SIZE and DATA_WIDTH, allowing for flexible FIFO configurations based on these parameters.
// Interconnection:

// The wire connections between the submodules handle the necessary pointer synchronization and data flow management between the write and read operations.