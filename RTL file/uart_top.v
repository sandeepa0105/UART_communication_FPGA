module uart_top #(
    parameter BAUD_DIV = 12 // Baud rate divider for both RX and TX
)(
    input wire clk,
    input wire reset_n,        // Active-low reset
    input wire rx,             // Serial input
    input wire [7:0] data_in,
    input wire tx_start,
    output wire tx,            // Serial output
    output wire rx_done,       // RX done indicator
    output wire tx_busy,       // TX busy indicator
    output wire [7:0] data_out // Received data output
);



    // Instantiate UART receiver
    uart_rx #(
        .BAUD_DIV(BAUD_DIV)
    ) uart_receiver (
        .clk(clk),
        .reset_n(reset_n),
        .rx(rx),
        .data_out(data_out),
        .rx_done(rx_done)
    );

    // Instantiate UART transmitter
    uart_tx #(
        .BAUD_DIV(BAUD_DIV)
    ) uart_transmitter (
        .clk(clk),
        .reset_n(reset_n),
        .tx_start(tx_start),
        .data_in(data_in),
        .tx(tx),
        .tx_busy(tx_busy)
    );

    

endmodule