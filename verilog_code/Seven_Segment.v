`timescale 1ns / 1ps
module Seven_Segment(
    output reg [6:0] display,
    output reg [3:0] digit,
    input wire [15:0] msg,
    input wire rst,
    input wire clk
    );
    
    parameter WORD_A = 4'd0;
    parameter WORD_1 = 4'd1;
    parameter WORD_2 = 4'd2;
    parameter WORD_3 = 4'd3;
    parameter WORD_4 = 4'd4;
    parameter WORD_5 = 4'd5;
    parameter WORD_D = 4'd6;
    parameter WORD_E = 4'd7;
    parameter WORD_I = 4'd8;
    parameter WORD_L = 4'd9;
    parameter WORD_P = 4'd10;
    parameter WORD_R = 4'd11;
    parameter WORD_S = 4'd12;
    parameter WORD_T = 4'd13;
    parameter WORD_U = 4'd14;
    parameter WORD_Y = 4'd15;
    
    reg [15:0] clk_divider;
    reg [3:0] display_msg;
    
    always @ (posedge clk, posedge rst) begin
        if (rst) begin
            clk_divider <= 16'b0;
        end else begin
            clk_divider <= clk_divider + 16'b1;
        end
    end
    
    always @ (posedge clk, posedge rst) begin
        if (rst) begin
            display_msg <= 4'b0000;
            digit <= 4'b1111;
        end else if (clk_divider == {16{1'b1}}) begin
            case (digit)
                4'b1110 : begin
                    display_msg <= msg[7:4];
                    digit <= 4'b1101;
                end
                4'b1101 : begin
                    display_msg <= msg[11:8];
                    digit <= 4'b1011;
                end
                4'b1011 : begin
                    display_msg <= msg[15:12];
                    digit <= 4'b0111;
                end
                4'b0111 : begin
                    display_msg <= msg[3:0];
                    digit <= 4'b1110;
                end
                default : begin
                    display_msg <= msg[3:0];
                    digit <= 4'b1110;
                end				
            endcase
        end else begin
            display_msg <= display_msg;
            digit <= digit;
        end
    end
    
    always @ (*) begin
        case (display_msg)
            WORD_A : display = 7'b0001000;	
            WORD_1 : display = 7'b1111001;   //0001                                                
            WORD_2 : display = 7'b0100100;   //0010                                                
            WORD_3 : display = 7'b0110000;   //0011                                             
            WORD_4 : display = 7'b0011001;   //0100                                               
            WORD_5 : display = 7'b0010010;   //0101                                               
            WORD_D : display = 7'b0100001;
            WORD_E : display = 7'b0000110;
            WORD_I : display = 7'b1111010;
            WORD_L : display = 7'b1000111;
            WORD_P : display = 7'b0001100;
            WORD_R : display = 7'b0101111;
            WORD_S : display = 7'b0010010;
            WORD_T : display = 7'b0000111;
            WORD_U : display = 7'b1000001;
            WORD_Y : display = 7'b0010001;
            default: display = 7'b1000000;
        endcase
    end
    
endmodule
