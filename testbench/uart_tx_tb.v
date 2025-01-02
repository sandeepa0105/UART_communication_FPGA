`timescale 1ns / 1ps

//parameter BAUD_DIV = 12;

module uart_tx_tb;

    parameter BAUD_DIV = 2;

    reg clk;
    reg reset_n;
    reg tx_start;
    reg [7:0] data_in;
    wire tx;
    wire tx_busy;

    // Instantiate the UART Transmitter
    uart_tx #(
        .BAUD_DIV(BAUD_DIV)
    )uut (
        .clk(clk),
        .reset_n(reset_n),
        .tx_start(tx_start),
        .data_in(data_in),
        .tx(tx),
        .tx_busy(tx_busy)
    );

    // Clock generation: 50 MHz clock (20 ns period)
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // Test sequence
    initial begin
        // Initialize signals
        reset_n = 0;
        tx_start = 0;
        data_in = 8'b0;
        #50; // Wait for reset to propagate

        // Release reset
        reset_n = 1;
        #50;

        // Test case 1: Transmit a byte (e.g., 8'hA5)
        data_in = 8'h05;
        tx_start = 1;
        #20; // Allow tx_start to propagate
        tx_start = 0;

        // Wait for transmission to complete
        wait (!tx_busy);
        #100;

//         Test case 2: Transmit another byte (e.g., 8'h3C)
        data_in = 8'h3C;
        tx_start = 1;
        #20; // Allow tx_start to propagate
        tx_start = 0;

//        // Wait for transmission to complete
        wait (!tx_busy);
        #100;

//        // Test case 3: Reset during operation
//        data_in = 8'hFF;
//        tx_start = 1;
//        #20;
//        tx_start = 0;
//        #30; // During transmission, assert reset
//        reset_n = 0;
//        #50;
//        reset_n = 1;
//        #100;

        // End simulation
        $stop;
    end

endmodule
