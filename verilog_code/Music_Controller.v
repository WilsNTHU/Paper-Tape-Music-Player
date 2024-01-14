`timescale 1ns / 1ps
module Music_Controller(
    output wire pmod_1,	//AIN
	output wire pmod_2,	//GAIN
	output wire pmod_4,	//SHUTDOWN_N
    //output wire flag,
    input wire clk,
    input wire [7:0] incode
    );
   
    reg [31:0] tempo;

    always @(*) begin
        case(incode[1:0]) // music note duration
            2'd0: tempo = 32'd1;  // 1 second
            2'd1: tempo = 32'd2;  // 1/2 second
            2'd2: tempo = 32'd4;  // 1/4 second
            2'd3: tempo = 32'd8;  // 1/8 second
        endcase
    end
    
    wire dclk;
    wire [31:0] freq;   
    assign pmod_2 = 1'd1;	//no gain(6dB)
    assign pmod_4 = 1'd1;	//turn-on
    
    wire rst;
    
    PWM_gen cd(
        clk,
        rst,
	    tempo,
        10'd512,
        dclk
    );
    
    Music_Scale ms(
        incode [7:2],
        clk,
        rst,
        freq 
    );
    
    PWM_gen pg(
        clk,
        rst,
	    freq,
        10'd512,
        pmod_1
    );
    
endmodule

module Music_Scale(
    input [5:0] incode,
    input clk,
    input rst,
    output reg [31:0] freq 
    );
reg [31:0] next_freq;    
 
parameter NOTE_C4 = 32'd262;	
parameter NOTE_C4_UP = 32'd277;	
parameter NOTE_D4 = 32'd294;	
parameter NOTE_D4_UP = 32'd311;	
parameter NOTE_E4 = 32'd330;	
parameter NOTE_E4_UP = 32'd340;	
parameter NOTE_F4 = 32'd349;	
parameter NOTE_F4_UP = 32'd369;	
parameter NOTE_G4 = 32'd392;	
parameter NOTE_G4_UP = 32'd415;	
parameter NOTE_A4 = 32'd440;	
parameter NOTE_A4_UP = 32'd466;	
parameter NOTE_B4 = 32'd494;	
parameter NOTE_B4_UP = 32'd508;	

parameter NOTE_C5 = 32'd523;	
parameter NOTE_C5_UP = 32'd554;	
parameter NOTE_D5 = 32'd587;	
parameter NOTE_D5_UP = 32'd622;	
parameter NOTE_E5 = 32'd659;	
parameter NOTE_E5_UP = 32'd679;	
parameter NOTE_F5 = 32'd698;	
parameter NOTE_F5_UP = 32'd739;	
parameter NOTE_G5 = 32'd783;	
parameter NOTE_G5_UP = 32'd830;	
parameter NOTE_A5 = 32'd880;	
parameter NOTE_A5_UP = 32'd932;	
parameter NOTE_B5 = 32'd987;	
parameter NOTE_B5_UP = 32'd1017;	

parameter NOTE_C6 = 32'd1046;
parameter NOTE_C6_UP = 32'd1108;
parameter NOTE_D6 = 32'd1174;	
parameter NOTE_D6_UP = 32'd1244;	
parameter NOTE_E6 = 32'd1318;	
parameter NOTE_E6_UP = 32'd1358;	
parameter NOTE_F6 = 32'd1396;	
parameter NOTE_F6_UP = 32'd1479;	
parameter NOTE_G6 = 32'd1567;	
parameter NOTE_G6_UP = 32'd1661;	
parameter NOTE_A6 = 32'd1760;	
parameter NOTE_A6_UP = 32'd1864;	
parameter NOTE_B6 = 32'd1975;
parameter NOTE_B6_UP = 32'd2035;

parameter NOTE_C7 = 32'd2093;
parameter NOTE_C7_UP = 32'd2217;
parameter NOTE_D7 = 32'd2349;	
parameter NOTE_D7_UP = 32'd2489;	
parameter NOTE_E7 = 32'd2637;	
parameter NOTE_E7_UP = 32'd2715;	
parameter NOTE_F7 = 32'd2793;	
parameter NOTE_F7_UP = 32'd2959;	
parameter NOTE_G7 = 32'd3135;	
parameter NOTE_G7_UP = 32'd3322;	
parameter NOTE_A7 = 32'd3520;	
parameter NOTE_A7_UP = 32'd3729;	
parameter NOTE_B7 = 32'd3951;
parameter NOTE_B7_UP = 32'd4068;

parameter NOTE_IDLE = 32'd0;

always @(posedge clk, posedge rst) begin
    if(rst) 
        freq <= NOTE_IDLE;
    else 
        freq <= next_freq;
end	

always @(*) begin
    case(incode)
        6'd0: next_freq = NOTE_IDLE;
        6'd1: next_freq = NOTE_C4;
        6'd2: next_freq = NOTE_C4_UP;
        6'd3: next_freq = NOTE_D4;
        6'd4: next_freq = NOTE_D4_UP;
        6'd5: next_freq = NOTE_E4;
        // 6'd6: next_freq = NOTE_E4_UP;
        6'd7: next_freq = NOTE_F4;
        6'd8: next_freq = NOTE_F4_UP;
        6'd9: next_freq = NOTE_G4;
        6'd10:  next_freq = NOTE_G4_UP;
        6'd11:  next_freq = NOTE_A4;
        6'd12:  next_freq = NOTE_A4_UP;
        6'd13:  next_freq = NOTE_B4;
        // 6'd14:  next_freq = NOTE_B4_UP;

        6'd15:  next_freq = NOTE_C5;
        6'd16:  next_freq = NOTE_C5_UP;
        6'd17:  next_freq = NOTE_D5;
        6'd18:  next_freq = NOTE_D5_UP;
        6'd19:  next_freq = NOTE_E5;
        // 6'd20:  next_freq = NOTE_E5_UP;
        6'd21:  next_freq = NOTE_F5;
        6'd22:  next_freq = NOTE_F5_UP;
        6'd23:  next_freq = NOTE_G5;
        6'd24:  next_freq = NOTE_G5_UP;
        6'd25:  next_freq = NOTE_A5;
        6'd26:  next_freq = NOTE_A5_UP;
        6'd27:  next_freq = NOTE_B5;
        // 6'd28:  next_freq = NOTE_B5_UP;

        6'd29:  next_freq = NOTE_C6;
        6'd30:  next_freq = NOTE_C6_UP;
        6'd31:  next_freq = NOTE_D6;
        6'd32:  next_freq = NOTE_D6_UP;
        6'd33:  next_freq = NOTE_E6;
        // 6'd34:  next_freq = NOTE_E6_UP;
        6'd35:  next_freq = NOTE_F6;
        6'd36:  next_freq = NOTE_F6_UP;
        6'd37:  next_freq = NOTE_G6;
        6'd38:  next_freq = NOTE_G6_UP;
        6'd39:  next_freq = NOTE_A6;
        6'd40:  next_freq = NOTE_A6_UP;
        6'd41:  next_freq = NOTE_B6;
        // 6'd42:  next_freq = NOTE_B6_UP;

        6'd43:  next_freq = NOTE_C7;
        6'd44:  next_freq = NOTE_C7_UP;
        6'd45:  next_freq = NOTE_D7;
        6'd46:  next_freq = NOTE_D7_UP;
        6'd47:  next_freq = NOTE_E7;
        // 6'd48:  next_freq = NOTE_E7_UP;
        6'd49:  next_freq = NOTE_F7;
        6'd50:  next_freq = NOTE_F7_UP;
        6'd51:  next_freq = NOTE_G7;
        6'd52:  next_freq = NOTE_G7_UP;
        6'd53:  next_freq = NOTE_A7;
        6'd54:  next_freq = NOTE_A7_UP;
        6'd55:  next_freq = NOTE_B7;
        6'd57:  next_freq = NOTE_IDLE;
        // 6'd56:  next_freq = NOTE_B7_UP;

        default: next_freq = NOTE_IDLE;
    endcase
end

endmodule

module Clock_Divider (
	input clk,
	input reset,
	output dclk
);
parameter BEATLEAGTH = 63;
reg [7:0] ibeat;

always @(posedge clk, posedge reset) begin
	if (reset)
		ibeat <= 0;
	else if (ibeat < BEATLEAGTH) 
		ibeat <= ibeat + 1;
	else 
		ibeat <= 0;
end

assign dclk = (ibeat >= BEATLEAGTH) ? 1'b1 : 1'b0;

endmodule


module PWM_gen (
   input wire clk,
   input wire reset,
	input [31:0] freq,
   input [9:0] duty,
   output reg PWM
);

wire [31:0] count_max = 100_000_000 / freq;
wire [31:0] count_duty = count_max * duty / 1034;
reg [31:0] count;
    
always @(posedge clk, posedge reset) begin
   if (reset) begin
       count <= 0;
       PWM <= 0;
   end else if (count < count_max) begin
       count <= count + 1;
		if(count < count_duty)
           PWM <= 1;
       else
           PWM <= 0;
   end else begin
       count <= 0;
       PWM <= 0;
   end
end

endmodule


module Tempo_Counter(clk, rst, tempo, start, feedback);
input [1:0] tempo;
input rst, clk;
input start;
output reg feedback;

wire [26:0] upper;
reg [26:0] counter;

assign upper = (tempo == 2'd0) ? 27'd100_000_000 : (tempo == 2'd1) ? 27'd50_000_000 :
(tempo == 2'd2) ? 27'd25_000_000 : 27'd12_500_000;

// assign upper = 27'd100_000_000;

always @(posedge clk) begin
    if(rst == 1'b1) counter <= 27'd0;
    else if(start == 1'b0) counter <= counter;
    else begin
        if(counter >= upper) begin
            counter <= 27'd0;
            feedback <= 1'b1;
        end
        else begin
            counter <= counter + 27'd1;
            feedback <= 1'b0;
        end
    end
end

     
endmodule
