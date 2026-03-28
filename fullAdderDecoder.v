`timescale 1ns / 1ps

module fullAdderDecoder(
    input A, B, C,
    output [7:0] out
    );
    wire S,Co;
    assign out[0] = ~A & ~B & ~C;
    assign out[1] = ~A & ~B &  C;
    assign out[2] = ~A &  B & ~C;
    assign out[3] = ~A &  B &  C;
    assign out[4] =  A & ~B & ~C;
    assign out[5] =  A & ~B &  C;
    assign out[6] =  A &  B & ~C;
    assign out[7] =  A &  B &  C;
    
    assign S = out[1] | out[2] | out[4] | out[7];
    assign Co = out[3] | out[5] | out[6] | out[7];
endmodule
