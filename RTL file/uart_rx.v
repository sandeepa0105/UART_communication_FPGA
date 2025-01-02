module uart_rx #(
    parameter BAUD_DIV = 12 // Baud rate divider
)(
    input wire clk,
    input wire reset_n,     // Active-low reset
    input wire rx,          // Serial input
    output reg [7:0] data_out, // Received data
    output reg rx_done      // Reception complete
);

    // State machine states
    
    localparam RX_IDLE  = 2'b00;
    localparam RX_START = 2'b01;
    localparam RX_DATA  = 2'b10;
    localparam RX_STOP  = 2'b11;

    reg [1:0] state;
    

    // Internal signals
    reg [$clog2(BAUD_DIV)-1:0] clock_counter; // Clock divider counter
    reg [2:0] bit_index;                     // Data bit index
    reg [7:0] temp_data;                     // Temporary data storage
    reg rx_sync;                             // Synchronized RX input

    // Synchronize the RX input to the clock domain
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            rx_sync <= 1'b1; // Default idle state for RX
        else
            rx_sync <= rx;
    end

    // State machine
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= RX_IDLE;
            clock_counter <= 0;
            bit_index <= 0;
            temp_data <= 8'b0;
            data_out <= 8'b0;
            rx_done <= 1'b0;
        end else begin
            case (state)
                RX_IDLE: begin
                    rx_done <= 1'b0; // Clear done flag
                    if (rx_sync == 0) begin // Start bit detected
                        state <= RX_START;
                        clock_counter <= 0;
                    end
                end

                RX_START: begin
                    if (clock_counter == (BAUD_DIV / 2) - 1) begin
                        state <= RX_DATA; // Move to data reception
                        clock_counter <= 0;
                        bit_index <= 0;
                    end else
                        clock_counter <= clock_counter + 1;
                end

                RX_DATA: begin
                    if (clock_counter == BAUD_DIV - 1) begin
                        clock_counter <= 0;
                        temp_data[bit_index] <= rx_sync; // Sample the bit
                        if (bit_index == 3'd7) begin
                            state <= RX_STOP; // Move to stop bit check
                        end else
                            bit_index <= bit_index + 1;
                    end else
                        clock_counter <= clock_counter + 1;
                end

                RX_STOP: begin
                    if (clock_counter == BAUD_DIV - 1) begin
                        data_out <= temp_data; // Save received data
                        rx_done <= 1'b1;       // Signal reception complete
                        state <= RX_IDLE;      // Return to idle
                        clock_counter <= 0;
                    end else
                        clock_counter <= clock_counter + 1;
                end

                default: state <= RX_IDLE;
            endcase
        end
    end

endmodule
