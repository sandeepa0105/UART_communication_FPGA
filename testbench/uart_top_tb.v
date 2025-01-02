module uart_top_tb;

    // Testbench parameters
    parameter BAUD_DIV = 4;
    parameter CLK_PERIOD = 10; // Clock period in ns (50 MHz)

    // Testbench signals
    reg clk;
    reg reset_n;
    reg rx;
    reg [7:0] data_in;
    reg tx_start;
    wire tx;
    wire rx_done;
    wire tx_busy;
    wire [7:0] data_out;

    // Instantiate the UART top module
    uart_top #(
        .BAUD_DIV(BAUD_DIV)
    ) dut (
        .clk(clk),
        .reset_n(reset_n),
        .rx(rx),
        .data_in(data_in),
        .tx_start(tx_start),
        .tx(tx),
        .rx_done(rx_done),
        .tx_busy(tx_busy),
        .data_out(data_out)
    );

    // Generate clock signal
    initial begin
        clk = 0;
        forever #(CLK_PERIOD / 2) clk = ~clk;
    end

//    // Generate reset signal
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


//      task send_uart_frame;
//        input [7:0] data;
//        integer i;
//        begin
//            // Start bit
//            rx = 0;
//            #(BAUD_DIV * CLK_PERIOD);
            
//            // Data bits (LSB first)
//            for (i = 0; i < 8; i = i + 1) begin
//                rx = data[i];
//                #(BAUD_DIV * CLK_PERIOD);
//            end
            
//            // Stop bit
//            rx = 1;
//            #(BAUD_DIV * CLK_PERIOD);
//        end
//    endtask

//    // Test sequence
//    initial begin
//        // Initialize signals
//        reset_n = 0;
//        rx = 1; // Idle state
//        #(5 * CLK_PERIOD);
        
//        // Release reset
//        reset_n = 1;
//        #(5 * CLK_PERIOD);

//        // Test case 1: Transmit data 0xA5
//        send_uart_frame(8'b00101011);
//        #(BAUD_DIV * CLK_PERIOD * 2 );
        
//        // Wait and check output
////        if (data_out == 8'hA5 && rx_done) 
////            $display("Test 1 Passed: Received 0x%02X", data_out);
////        else 
////            $display("Test 1 Failed: Received 0x%02X", data_out);
        
//        // Test case 2: Transmit data 0x3C
////        send_uart_frame(8'b01010101);
////        #(BAUD_DIV * CLK_PERIOD * 2);

////        // Wait and check output
////        if (data_out == 8'h3C && rx_done) 
////            $display("Test 2 Passed: Received 0x%02X", data_out);
////        else 
////            $display("Test 2 Failed: Received 0x%02X", data_out);

//        // Finish simulation
//        $stop;
//    end

    

    

endmodule
