`timescale 1ns / 1ps
module RL_Reader(
    input [2:0] signal,
    input clk,
    input rst,
    output reg [7:0] data,
    output reg data_change
    );

reg [7:0] buffer;
reg buffer_buffer;
reg prev_sig0, prev_sig2;

always@ (posedge clk) begin
    if(rst) begin
        buffer <= {6'd57, 2'b11};
        data <= 8'd0;
        prev_sig0 <= 1'b1;
        prev_sig2 <= 1'b1;
    end
    else begin
        prev_sig0 <= signal[0];
        prev_sig2 <= signal[2];
        buffer_buffer <= signal[1]; // the previous read-in value          
        if(prev_sig0 != signal[0]) 
            buffer <= {buffer[6:0], buffer_buffer};
        else prev_sig0 <= prev_sig0;
        
        if (signal[2] != prev_sig2) begin
                data <= buffer;
                buffer <= 8'd0;
                data_change <= 1'b1;
        end
        else data_change <= 1'b0;
    end
end


endmodule
