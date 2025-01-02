`timescale 1ns / 1ps

module uart_rx_tb;
    // Parameters
    parameter BAUD_DIV = 4; // Adjust this based on your design
    parameter CLK_PERIOD = 10; // 50 MHz clock (20 ns period)

    // Signals
    reg clk;
    reg reset_n;
    reg rx;
    wire [7:0] data_out;
    wire rx_done;

    // Instantiate the UART RX module
    uart_rx #(
        .BAUD_DIV(BAUD_DIV)
    ) uut (
        .clk(clk),
        .reset_n(reset_n),
        .rx(rx),
        .data_out(data_out),
        .rx_done(rx_done)
    );

    // Generate clock
    initial clk = 0;
    always #(CLK_PERIOD / 2) clk = ~clk;

    // Task to send a UART frame
    task send_uart_frame;
        input [7:0] data;
        integer i;
        begin
            // Start bit
            rx = 0;
            #(BAUD_DIV * CLK_PERIOD);
            
            // Data bits (LSB first)
            for (i = 0; i < 8; i = i + 1) begin
                rx = data[i];
                #(BAUD_DIV * CLK_PERIOD);
            end
            
            // Stop bit
            rx = 1;
            #(BAUD_DIV * CLK_PERIOD);
        end
    endtask

    // Test sequence
    initial begin
        // Initialize signals
        reset_n = 0;
        rx = 1; // Idle state
        #(5 * CLK_PERIOD);
        
        // Release reset
        reset_n = 1;
        #(5 * CLK_PERIOD);

        // Test case 1: Transmit data 0xA5
        send_uart_frame(8'b00101011);
        #(BAUD_DIV * CLK_PERIOD * 2 );
        
        // Wait and check output
//        if (data_out == 8'hA5 && rx_done) 
//            $display("Test 1 Passed: Received 0x%02X", data_out);
//        else 
//            $display("Test 1 Failed: Received 0x%02X", data_out);
        
        // Test case 2: Transmit data 0x3C
        send_uart_frame(8'b01010101);
        #(BAUD_DIV * CLK_PERIOD * 2);

//        // Wait and check output
//        if (data_out == 8'h3C && rx_done) 
//            $display("Test 2 Passed: Received 0x%02X", data_out);
//        else 
//            $display("Test 2 Failed: Received 0x%02X", data_out);

        // Finish simulation
        $stop;
    end
endmodule
