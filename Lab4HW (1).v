module Lab4HW(input CLOCK_50,
				output [6:0] HEX0,
				output [6:0] HEX1,
				output [6:0] HEX2,
				output [6:0] HEX3,
				output [6:0] HEX4,
				output [6:0] HEX5);

	wire [23:0] HEX;

	Lab4NiosHW u0 (
		.clk_clk       (CLOCK_50),       //   clk.clk
		.reset_reset_n (1'b1), // reset.reset_n
		.hex_export    (HEX)     //   hex.export
	);

	SevenSegDriver Seg7(
		.incomingBinary (HEX),
		.outgoingHex({HEX5, HEX4, HEX3, HEX2, HEX1, HEX0})
		);


endmodule


module SevenSegDriver (input wire [23:0] incomingBinary,
								output [42:0] outgoingHex);
	

		sevenseg seg0(incomingBinary[3:0], outgoingHex [6:0]);
		sevenseg seg1(incomingBinary[7:4], outgoingHex [13:7]);
		sevenseg seg2(incomingBinary[11:8], outgoingHex [20:14]);
		sevenseg seg3(incomingBinary[15:12], outgoingHex [27:21]);
		sevenseg seg4(incomingBinary[19:16], outgoingHex [34:28]);
		sevenseg seg5(incomingBinary[23:20], outgoingHex [41:35]);

	
	

endmodule



module sevenseg(input [3:0]num,
                output reg [6:0]seg);
    always@(*)
    begin
        case (num) 
            0 : seg = 7'b1000000;
            1 : seg = 7'b1111001;
            2 : seg = 7'b0100100;
            3 : seg = 7'b0110000;
            4 : seg = 7'b0011001;
            5 : seg = 7'b0010010;
            6 : seg = 7'b0000010;
            7 : seg = 7'b1111000;
            8 : seg = 7'b0000000;
            9 : seg = 7'b0011000;
            10 : seg = 7'b0001000;
            11 : seg = 7'b0000011;
            12 : seg = 7'b1000110;
            13 : seg = 7'b0100001;
            14 : seg = 7'b0000110;
				15 : seg = 7'b0001110;

            default : seg = 7'b1111111; 
        endcase
    end
endmodule
