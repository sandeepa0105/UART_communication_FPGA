module uart_tx #(
    parameter BAUD_DIV = 12
)(
    input wire clk,
    input wire reset_n, // Active-low reset
    input wire tx_start,
    input wire [7:0] data_in,
    output reg tx,
    output reg tx_busy
);
//    parameter BAUD_DIV = 12; // For 4 Mbps @ 50 MHz clock
    reg [3:0] bit_index;
    reg [9:0] shift_reg;
    reg [3:0] baud_count;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            tx <= 1'b1; // Idle state
            tx_busy <= 0;
            bit_index <= 0;
            shift_reg <= 0;
            baud_count <= 0;
        end else if (tx_start && !tx_busy) begin
            tx_busy <= 1;
            shift_reg <= {1'b1, data_in, 1'b0}; // Stop bit, data, start bit
            bit_index <= 0;
            baud_count <= 0;
        end else if (tx_busy) begin
            if (baud_count == BAUD_DIV - 1) begin
                baud_count <= 0;
                tx <= shift_reg[bit_index];
                bit_index <= bit_index + 1;
                if (bit_index == 9) tx_busy <= 0; // Transmission complete
            end else begin
                baud_count <= baud_count + 1;
            end
        end
    end
endmodule
