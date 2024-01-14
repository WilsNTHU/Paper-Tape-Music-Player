`timescale 1ns / 1ps
module Counter_1sec(clk, rst_n, start, done);
    input clk;
    input rst_n;
    input start;
    output reg done;
    reg [26:0] count, next_count;
    always@(posedge clk) begin
        if (rst_n) count = 27'd0;
        else if(!start) count <= count; // pause music
        else count <= next_count;
    end

    always@(*) begin
        next_count = count;
        if (start) begin
            if (count == 27'd100_000_000) begin
                done = 1'b1;
                next_count = 27'd0;
            end
            else begin
                next_count = count + 27'd1;
                done = 1'b0;
            end
        end
        else begin
            done = 1'b0;
            next_count = 27'd0;
        end
    end
endmodule
