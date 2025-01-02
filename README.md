# UART_communication_FPGA
This project demonstrates the implementation of a high-speed UART (Universal Asynchronous Receiver-Transmitter) communication system. The system supports modern UARTs with baud rates of up to 4 Mbps and includes features like auto-baud detection. It is implemented in Verilog and designed for FPGA-based applications.

Simulation

Two simulations were conducted to validate the functionality of the UART communication system:

1. Transmitter Simulation

   ![Screenshot 2025-01-02 091308](https://github.com/user-attachments/assets/a98c48cd-754e-484f-ba91-429ddf46c6b1)


The transmit_sim.png file shows the waveform of the UART transmitter module, verifying proper transmission of start bits, data bits, and stop bits at the specified baud rate.

2. Receiver Simulation

   ![Screenshot 2025-01-02 091058](https://github.com/user-attachments/assets/ad292b31-b268-4bbf-8282-acb5b049fbe1)


The receive_sim.png file demonstrates the UART receiver correctly decoding the serial input into parallel data. The start bit, data bits, and stop bit are accurately received and processed.
