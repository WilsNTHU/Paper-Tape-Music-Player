`timescale 1ns / 1ps

module Top(
    input [2:0] rl_signal,
    input clk,
    input rst_btn,
    input pause_btn,
    input play_btn,
    input replay_btn,
    input read_btn,
    input [4:0] track,
    output pmod_1,	//AIN
	output pmod_2,	//GAIN
	output pmod_4,	//SHUTDOWN_N
	output [2:0] rl_signal_led,
	output [1:0] write_read_notice,
	output [7:0] data_notice,
	output reg audio_feedback_notice,
    output [3:0] an,
    output [6:0] sev_seg_display
    );
    
    wire rst_db, pause_db, play_db, replay_db, read_db, rst_op, pause_op, play_op, replay_op, read_op;
    
    wire [2:0] rl_signal_db;
    wire [2:0] rl_signal_op;
    wire [7:0] data_rl, data_mem;
    wire rl_flush;
    
    
    reg [9:0] addr;
    reg [9:0] set_addr;
    wire tempo_feedback;
    reg start_tempo;
    
    reg [2:0] state, n_state;
    
    reg counter_start, n_counter_start;
    wire counter_done;
    
    reg write_en, read_en;
    
    reg [15:0] sev_seg_msg;
    
    parameter STATE_WRITE = 3'b000; 
    parameter STATE_PLAY = 3'b001;
    parameter STATE_PAUSE = 3'b010;
    parameter STATE_IDLE = 3'b011;
    parameter STATE_REPLAY = 3'b101;
    
    parameter NOTE_START = 8'd0;
    parameter NOTE_END = 8'b11111111;
    
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
    

    One_signal d0(pause_op, pause_btn, clk);
    One_signal d1(play_op, play_btn, clk);
    One_signal d2(rst_op, rst_btn, clk);
    One_signal d3(replay_op, replay_btn, clk);
    One_signal d4(read_op, read_btn, clk);

    RL_Debouncer d5(rl_signal_db[0], rl_signal[0], clk, rst);
    RL_Debouncer d6(rl_signal_db[1], rl_signal[1], clk, rst);
    RL_Debouncer d7(rl_signal_db[2], rl_signal[2], clk, rst);

    RL_Reader rlr0(rl_signal_db, clk, rst_op, data_rl, rl_flush);
    Memory mem(write_en, read_en, data_rl, data_mem, addr, clk);
    Counter_1sec c0(clk, rst_op, counter_start, counter_done);
    Seven_Segment ss0(sev_seg_display, an, sev_seg_msg, rst_op, clk);
    Music_Controller mc0(pmod_1, pmod_2, pmod_4, clk, data_mem);
    Tempo_Counter tc0(clk, rst_op, data_mem[1:0], start_tempo, tempo_feedback); 

    
    always@(posedge clk) begin
        if(rst_op) begin
            state <= STATE_IDLE;
            addr <= set_addr;
            write_en <= 1'd0;
            read_en <= 1'd0;
            counter_start <= 1'd0;
            audio_feedback_notice <= 1'b0;
        end
        else if(pause_op) begin
            state <= STATE_PAUSE;
        end
        else if(play_op) begin
            state <= STATE_PLAY;
        end
        else if(replay_op) begin
            state <= STATE_REPLAY;
        end
        else if(read_op) begin
            state <= STATE_WRITE;
            addr <= set_addr;
        end
        else begin
            state <= n_state;
            counter_start <= n_counter_start;
            case(state)
                STATE_WRITE: begin
                    read_en <= 1'b0;
                    write_en <= 1'b1;
                    sev_seg_msg <= {WORD_R, WORD_E, WORD_A, WORD_D};
                    if(rl_flush) begin
                        if (data_rl == NOTE_END) begin
                            write_en <= 1'b0;
                            addr <= addr + 10'd1;
                        end
                        else addr <= addr + 10'd1;
                    end
                    else begin
                        addr <= addr;
                        write_en <= 1'b1;
                    end

                end
                STATE_PLAY: begin
                    write_en <= 1'b0;
                    read_en <= 1'b1;
                    sev_seg_msg <= {WORD_P, WORD_L, WORD_A, WORD_Y};
                    if(data_mem == NOTE_END) read_en <= 1'b0;
                    else read_en <= 1'b1;
                    if(tempo_feedback) begin
                        audio_feedback_notice <= !audio_feedback_notice;
                        addr <= addr + 10'd1;
                    end
                    else addr <= addr;
                end
                STATE_PAUSE: begin
                    sev_seg_msg <= {WORD_P, WORD_A, WORD_U, WORD_S};
                    write_en <= 1'b0;
                    read_en <= 1'b0;
                end
                STATE_REPLAY: begin
                    sev_seg_msg <= {WORD_R, WORD_E, WORD_P, WORD_L};
                    addr <= set_addr; // Start reading from the first byte
                    audio_feedback_notice <= 1'b0;
                    write_en <= 1'b0;
                    read_en <= 1'b0;
                end
                default: begin // state IDLE
                    sev_seg_msg <= {WORD_I, WORD_D, WORD_L, WORD_E};
                    addr <= set_addr;
                    audio_feedback_notice <= 1'b0;
                    write_en <= 1'b0;
                    read_en <= 1'b0;
                end
            endcase
        end
    end

    
    always@(*) begin
        case(state)
            STATE_WRITE: begin
                // Check address validness for memory protection
                // We use contiguous memory allocation scheme
                if((data_rl == NOTE_END) || (addr >= (set_addr + 10'd200))) 
                    n_state = STATE_IDLE;
                else n_state = STATE_WRITE;
                n_counter_start = 1'b0;
                start_tempo = 1'b0;
            end
            STATE_PLAY: begin
                if((data_mem == NOTE_END) || (addr >= (set_addr + 10'd200))) 
                    n_state = STATE_IDLE;
                else n_state = STATE_PLAY;
                n_counter_start = 1'b0;
                start_tempo = 1'b1;
            end
            STATE_PAUSE: begin
                if((data_mem == NOTE_END) || (addr >= (set_addr + 10'd200))) 
                    n_state = STATE_IDLE;
                else n_state = STATE_PAUSE;
                n_counter_start = (counter_done) ? 1'b0 : 1'b1;
                start_tempo = 1'b0;
            end
            STATE_REPLAY: begin
                if(counter_done) begin
                    n_state = STATE_PLAY;
                    n_counter_start = 1'b0;
                end
                else begin
                    n_state = STATE_REPLAY;
                    n_counter_start = 1'b1;
                end
                start_tempo = 1'b0;
            end
            default: begin
                n_state = state;
                n_counter_start = 1'b0;
                start_tempo = 1'b0;
            end
        endcase
    end
    
    always@ (*) begin
        case(track)
            5'b00001:
                set_addr = 10'd0;
            5'b00010:
                set_addr = 10'd200;
            5'b00100:
                set_addr = 10'd400;
            5'b01000:
                set_addr = 10'd600;
            5'b10000:
                set_addr = 10'd800;
            default:
                set_addr = 10'd0;
        endcase
    end
    
    assign rl_signal_led = rl_signal_db;
    assign write_read_notice = {write_en, read_en};
    assign data_notice = (write_en == 1'b1) ? data_rl : data_mem;

endmodule
