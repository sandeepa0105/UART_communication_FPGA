# UART_communication_FPGA
This project demonstrates the implementation of a high-speed UART (Universal Asynchronous Receiver-Transmitter) communication system. The system supports modern UARTs with baud rates of up to 4 Mbps and includes features like auto-baud detection. It is implemented in Verilog and designed for FPGA-based applications.

Simulation

Two simulations were conducted to validate the functionality of the UART communication system:

1. Transmitter Simulation

The transmit_sim.png file shows the waveform of the UART transmitter module, verifying proper transmission of start bits, data bits, and stop bits at the specified baud rate.

2. Receiver Simulation

The receive_sim.png file demonstrates the UART receiver correctly decoding the serial input into parallel data. The start bit, data bits, and stop bit are accurately received and processed.
