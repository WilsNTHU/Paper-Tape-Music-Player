`timescale 1ns / 1ps

module One_signal(pb_one_pulse, pb, clk);
    input clk, pb;
    output pb_one_pulse;
    wire pb_debounced;

    Debouncer d1(pb_debounced, pb, clk);
    One_Pulse d2(pb_debounced, clk, pb_one_pulse);
endmodule


module Debouncer(pb_debounced, pb, clk);
	output pb_debounced; // signal of a pushbutton after being debounced
	input pb; // signal from a pushbutton
	input clk;

	reg [3:0] DFF;
	always @(posedge clk)begin
		DFF[3:1] <= DFF[2:0];
		DFF[0] <= pb;
	end
	assign pb_debounced = ((DFF == 4'b1111) ? 1'b1 : 1'b0);
endmodule

module RL_Debouncer(pb_debounced, pb, clk, rst);
	output reg pb_debounced; // Processed IR signal
	input pb; // Original IR signal
	input clk, rst;
	
	reg [22:0] counter;
	reg [22:0] next_counter;
    reg next_val;
	
	always @(posedge clk) begin
		if(rst) counter <= 23'd0;
		else counter <= next_counter;
	end

	always @(*) begin
		if(counter != 23'd2_000_000) begin // output IR signal every 0.02 sec
            next_counter = counter + 23'd1;
            next_val = pb;
        end
		else begin
            next_counter = 23'd0;
            pb_debounced = next_val;
        end
	end   
	
endmodule

module One_Pulse (pb_debounced, clk, pb_one_pulse);
	input pb_debounced, clk;
	output reg pb_one_pulse;
	reg pb_debounced_delay;

	always @(posedge clk) begin
		pb_one_pulse <= pb_debounced & (!pb_debounced_delay);
		pb_debounced_delay <= pb_debounced;
	end
endmodule
