`timescale 1ns / 1ps

module fullAdderDecoder_tb();
    reg A,B,C;
    wire [7:0] out;
    wire S,Co;
    
    fullAdderDecoder uut(A,B,C,out);
    integer i;
    initial begin
        for(i = 0; i<8 ; i=i+1)begin
            {A,B,C} = i;
            #10 $display("A=%b, B = %b, C=%b, S = %b, Co = %b");
        end
    end
endmodule
