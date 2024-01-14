`timescale 1ns / 1ps

module TestBench;

// Tempo_Counter(clk, rst, tempo, start, feedback);

reg clk, rst, start;
reg [1:0] tempo;
wire feedback;

always #1 clk = ~clk;

Tempo_Counter T1(clk, rst, tempo, start, feedback);

initial begin
    clk = 1'b0;
    rst = 1'b1;
    tempo = 2'b11;
    start = 1'b0;

    #5
    rst = 1'b0;
    start = 1'b1;

    #5000000;
end
endmodule