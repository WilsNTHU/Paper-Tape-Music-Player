`timescale 1ns / 1ps
module Memory(
    input write_en,
    input read_en,
    input [7:0] data_in,
    output reg [7:0] data_out,
    input [9:0] addr,
    input wire clk
    );
    
    reg [7:0] mem [1023:0];
    
    always@(posedge clk) begin
        if(read_en && !write_en)
            data_out <= mem[addr]; 
        else if(!read_en && write_en) begin
            mem[addr] <= data_in;
            data_out <= 8'd0;
        end
        else
            data_out <= 8'd0; 
    end
    
endmodule
