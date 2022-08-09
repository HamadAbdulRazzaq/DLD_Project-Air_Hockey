// Code your design here
// Code your design here
`timescale 1ns / 1ps

    module
    clk_div3(
        input clk,
        output reg clk_d);
parameter div_value = 4999999;
reg [25:0] count;
initial begin
    clk_d = 0;
count = 0;
end
        always @(posedge clk)
            begin
    if (count == div_value)
        count
    <= 0;
else count <= count + 1;
end
        always @(posedge clk)
            begin
    if (count == div_value)
        clk_d
    <= ~clk_d;
end
    endmodule

        module DFF(D, clk, Q, RESET);
// D input
input D;
// Clock signal
input clk;
// Q output
output reg Q;
input RESET;
// looping logic with positive edge
always @(posedge clk) begin
    // swapping Input and output
    if (RESET)
        Q = 1'b0;
else Q <= D;
end
    endmodule

        module counter_10_bit(clk, count, trig);
input clk;
output [9:0] count;
output trig;
reg trig;
reg [9:0] count;
initial
    begin
        count = 0;
trig = 0;
end
        always @(posedge clk)
            begin
    if (count <= 799)
        begin
    count
    <= count + 1;
trig <= 0;
end else begin
        count <= 0;
trig <= 1;
end
    end
        endmodule

            //---------------------------------------------
            module counter_10_bit1(clk, count, enable);
input clk;
input enable;
output [9:0] count;
reg [9:0] count;
initial
    begin
        count = 0;
end
        always @(posedge clk)
            begin
    if (enable == 1)
        begin
    if (count <= 523)
        begin
    count
    <= count + 1;
end else begin
        count <= 0;
end
    end
        end
            endmodule

                //------------------------------------------------------------

                module clk_div(clk, clk_d);
parameter div_value = 1;
input clk;
output clk_d;
reg clk_d;
reg count;
initial
    begin
        clk_d = 0;
count = 0;
end
        always @(posedge clk)
            begin
    if (count == div_value)
        count
    <= 0;
else count <= count + 1;
end
        always @(posedge clk)
            begin
    if (count == div_value)
        clk_d
    <= ~clk_d;
end
    endmodule

        module clk_div2(clk, clk_d2);
parameter div_value = 0;
input clk;
output clk_d2;
reg clk_d2;
reg [23:0] count;
initial
    begin
        clk_d2 = 0;
count = 0;
end
        always @(posedge clk)
            begin
    if (count == div_value)
        count
    <= 0;
else count <= count + 1;
end
        always @(posedge clk)
            begin
    if (count == div_value)
        clk_d2
    <= ~clk_d2;
end
    endmodule

        //----------------------------------//

        module vga_sync(
            input [9:0] h_count,
            input [9:0] v_count,
            output h_sync,
            output v_sync,
            output video_on,
            output [9:0] x_loc,
            output [9:0] y_loc);

// horizontal
localparam HD = 640;
localparam HF = 16;
localparam HB = 48;
localparam HR = 96;

// vertical
localparam VD = 480;
localparam VF = 10;
localparam VB = 33;
localparam VR = 2;

assign h_sync = ((h_count < (HD + HF)) || (h_count >= (HD + HF + HR)));

assign v_sync = ((v_count < (VD + VF)) || (v_count >= (VD + VF + VR)));

assign video_on = ((h_count < HD) && (v_count < VD));

assign x_loc = h_count; // the location of will simply be the horiontal count
assign y_loc = v_count; // same for vertical count

endmodule
    //----------------------------
    // Code your design here
    // Code your design here
    //`timescale 1ns / 1ps

    module
    Keyboard(
        input CLK,
        input PS2_CLK,
        input PS2_DATA,

        //	output reg [3:0]COUNT,
        //	output reg TRIG_ARR,
        //	output reg [7:0]CODEWORD,
        output reg up, reg down, reg left, reg right, reg w, reg a, reg s, reg dk, reg enter, reg space // 8 LEDs
    );

wire [7:0] ARROW_UP = 8'h75; // codes for arrows
wire [7:0] ARROW_DOWN = 8'h72;
wire [7:0] ARROW_LEFT = 8'h6B;
wire [7:0] ARROW_RIGHT = 8'h74;
wire [7:0] W_KEY = 8'h1D; // codes for arrows
wire [7:0] A_KEY = 8'h1C;
wire [7:0] S_KEY = 8'h1B;
wire [7:0] D_KEY = 8'h23;
wire [7:0] ENTER = 8'h5A;
wire [7:0] SPACE = 8'h29;
// wire [7:0] EXTENDED = 8'hE0;	//codes
// wire [7:0] RELEASED = 8'hF0;

reg read;
reg [11:0] count_reading;
reg PREVIOUS_STATE;
reg scan_err;
reg [10:0] scan_code;
reg [7:0] CODEWORD;
reg TRIG_ARR;
reg [3:0] COUNT;
reg TRIGGER = 0;
reg [7:0] DOWNCOUNTER = 0;

initial begin
    PREVIOUS_STATE = 1;
scan_err = 0;
scan_code = 0;
COUNT = 0;
CODEWORD = 0;
read = 0;
count_reading = 0;
end

        //	always @(posedge CLK) begin
        //		if (DOWNCOUNTER < 249) begin
        //			DOWNCOUNTER <= DOWNCOUNTER + 1;
        //			TRIGGER <= 0;
        //		end
        //		else begin
        //			DOWNCOUNTER <= 0;
        //			TRIGGER <= 1;
        //		end
        //	end

        always @(posedge CLK) begin
    //		if (TRIGGER) begin
    if (read)
        count_reading
    <= count_reading + 1;
else count_reading <= 0;
end
        //	end

        always @(posedge CLK) begin
    //	if (TRIGGER) begin
    if (PS2_CLK != PREVIOUS_STATE) begin
    if (!PS2_CLK) begin
    read
    <= 1;
scan_err <= 0;
scan_code [10:0] <= {PS2_DATA, scan_code [10:1]};
COUNT <= COUNT + 1;
end
        end else if (COUNT == 11) begin
            COUNT <= 0;
read <= 0;
TRIG_ARR <= 1;

if (!scan_code[10] || scan_code[0] || !(scan_code[1] ^ scan_code[2] ^ scan_code[3] ^ scan_code[4] ^ scan_code[5] ^ scan_code[6] ^ scan_code[7] ^ scan_code[8] ^ scan_code[9]))
  scan_err <= 1;
else
  scan_err <= 0;
end else begin
        TRIG_ARR <= 0;
if (COUNT < 11 && count_reading >= 4000)
  begin
          COUNT <= 0;
read <= 0;
end
        end
            PREVIOUS_STATE <= PS2_CLK;
//	end
end

        always @(posedge CLK) begin
    if (TRIGGER) begin
    if (TRIG_ARR) begin
    if (scan_err) begin
    CODEWORD
    <= 8'd0;
end else begin
        CODEWORD <= scan_code [8:1];
end
        end else CODEWORD <= 8'd0;
end else CODEWORD <= 8'd0;
end

        always @(posedge CLK) begin
    up
    <= 0;
down <= 0;
right <= 0;
left <= 0;
w <= 0;
a <= 0;
s <= 0;
dk <= 0;
enter <= 0;
space <= 0;
if (CODEWORD == ARROW_UP)
  begin
          up <= 1;
//			down <= 0;
//			left <= 0;
//			right <=0;
//			w <=0;
//            a <=0;
//            s <=0;
//            dk <=0;
//            enter <= 0;
//        space <=0;
end if (CODEWORD == ARROW_DOWN)
        begin
            //			up <= 0;
            down <= 1;
//			left <= 0;
//			right <= 0;
//			w <=0;
//            a <=0;
//            s <=0;
//            dk <=0;
//				enter <= 0;
//        space <=0;
end if (CODEWORD == ARROW_LEFT)
        begin
            //			up <= 0;
            //			down <= 0;
            left <= 1;
//			right <= 0;
//			w <=0;
//            a <=0;
//            s <=0;
//            dk <=0;
//            enter <= 0;
//        space <=0;
end if (CODEWORD == ARROW_RIGHT)
        begin
            //			up <= 0;
            //			down <= 0;
            //			left <= 0;
            right <= 1;
//			w <=0;
//            a <=0;
//            s <=0;
//            dk <=0;
//            enter <= 0;
//        space <=0;
end if (CODEWORD == W_KEY)
        begin
            //			up <= 0;
            //			down <= 0;
            //			left <= 0;
            //			right <= 0;
            w <= 1;
//            a <=0;
//            s <=0;
//            dk <=0;
//            enter <= 0;
//        space <=0;
end if (CODEWORD == A_KEY)
        begin
            //			up <= 0;
            //			down <= 0;
            //			left <= 0;
            //			right <= 0;
            //			w <=0;
            a <= 1;
//            s <=0;
//            dk <=0;
//            enter <= 0;
//        space <=0;
end if (CODEWORD == S_KEY)
        begin
            //			up <= 0;
            //			down <= 0;
            //			left <= 0;
            //			right <= 0;
            //			w <=0;
            //            a <=0;
            s <= 1;
//            dk <=0;
//            enter <= 0;
//        space <=0;
end if (CODEWORD == D_KEY)
        begin
            //			up <= 0;
            //			down <= 0;
            //			left <= 0;
            //			right <= 0;
            //			w <=0;
            //            a <=0;
            //            s <=0;
            dk <= 1;
//            enter <= 0;
//        space <=0;
end

    if (CODEWORD == ENTER)
        begin
            //			up <= 0;
            //			down <= 0;
            //			left <= 0;
            //			right <= 0;
            //			w <=0;
            //            a <=0;
            //            s <=0;
            //            dk <=0;
            enter <= 1;
//        space <=0;
end

    if (CODEWORD == SPACE)
        begin
            //			up <= 0;
            //			down <= 0;
            //			left <= 0;
            //			right <= 0;
            //			w <=0;
            //            a <=0;
            //            s <=0;
            //            dk <=0;
            //            enter <= 0;
            space <= 1;
end

    //		else begin
    //		up <= 0;
    //		down <= 0;
    //		left <=0;
    //		right <= 0;
    //		w <=0;
    //        a <=0;
    //        s <=0;
    //        dk <=0;
    //        enter <= 0;
    //        space <=0;
    //		end
    end

        endmodule

            module pixel_gen(
                input [9:0] pixel_x,
                input [9:0] pixel_y,
                input clk_d,
                input video_on,
                output reg [3:0] red = 0,
                output reg [3:0] blue = 0,
                output reg [3:0] green = 0,
                input circle_x,
                input circle_y,
                input clk_d2,
                input up,
                input down,
                input left,
                input right,
                input w,
                input a,
                input s,
                input dk,
                input enter,
                input space,
                output reg p1, p2, game_on, pause);
reg [2:0] score_1 = 0;
reg [2:0] score_2 = 0;
reg [23:0] cp = 0;
reg [23:0] cm = 0;
reg w1 = 1'b0;
reg v1 = 1'b0;
reg [10:0] pc_x = 10'd320;
reg [10:0] pc_y = 10'd240;
reg [10:0] upc_x = 10'd320;
reg [10:0] upc_y = 10'd100;
reg [10:0] dpc_x = 10'd320;
reg [10:0] dpc_y = 10'd380;
reg [3:0] a1 = 4'h2;
reg [3:0] a2 = 4'h2;
reg [3:0] a3 = 4'h2;
reg [3:0] a4 = 4'h2;
reg [3:0] a5 = 4'h2;
reg [3:0] a6 = 4'h2;
reg [3:0] a7 = 4'h2;
reg [3:0] b1 = 4'h2;
reg [3:0] b2 = 4'h2;
reg [3:0] b3 = 4'h2;
reg [3:0] b4 = 4'h2;
reg [3:0] b5 = 4'h2;
reg [3:0] b6 = 4'h2;
reg [3:0] b7 = 4'h2;
reg start = 1'b0;

// parameter pc_x= 320;
// parameter pc_y= 240 ;
parameter pc_x_init = 320;
parameter pc_y_init = 240;
// initial begin
parameter upc_x_init = 320;
parameter upc_y_init = 100;
parameter dpc_x_init = 320;
parameter dpc_y_init = 380;
// reg game_on = 0;
// reg p_1 = 0;

// initial begin
// if (circle_x && circle_y)begin
// x =pc_x;
// y  = pc_y;
// end
// else begin
// x =pc_x_init;
// y =pc_y_init;
// end
// end
// always @(posedge clk_d2) begin

// if((~w1))begin
//// && ((pc_x-20 >160 && pc_x+20 <480) && (pc_y >20 && pc_y <460))

// pc_x=pc_x+1;
// end
// else if((w1)  )begin
//// && ((pc_x-20 >160 && pc_x+20 <480) && (pc_y >20 && pc_y <460))
// pc_x=pc_x-1;
// end
// else begin
// w1 <= ~w1;
// end
// reg w = 0;

reg x_mov = 1'b0;
reg y_mov = 1'b0;
reg [2:0] counter_m = 0;
initial begin
    p1 = 0;
p2 = 0;
end

        always @(posedge clk_d) begin
    if (enter && ~start) begin start
    <= 1;
end if (enter && ~game_on) begin start <= 0;
game_on <= 1;
score_1 <= 0;
score_2 <= 0;
pc_x <= pc_x_init;
pc_y <= pc_y;
upc_x <= upc_x_init;
upc_y <= upc_y_init;
dpc_y <= dpc_y_init;
dpc_x <= dpc_x_init;
end if (start && game_on) begin // 9 and 12
    if (up && dpc_y - 20 > 240) begin
        dpc_y <= dpc_y - 1;
end if (down && dpc_y + 20 < 460) begin
        dpc_y <= dpc_y + 1;
end if (left && dpc_x - 15 > 160) begin
        dpc_x <= dpc_x - 1;
end if (right && dpc_x + 15 < 480) begin
        dpc_x <= dpc_x + 1;
end if (w && upc_y - 20 > 20) begin
        upc_y <= upc_y - 1;
end if (s && upc_y + 20 < 240) begin
        upc_y <= upc_y + 1;
end if (a && upc_x - 15 > 160) begin
        upc_x <= upc_x - 1;
end if (dk && upc_x + 15 < 480) begin
        upc_x <= upc_x + 1;

end if (counter_m == 1) begin

    if (score_1 == 7 || score_2 == 7) begin
        game_on <= 0;
if (score_1 == 7)
  begin p1 <= 1;
end else if (score_2 == 7) begin p2 <= 1;
end
        pc_x <= 320;
pc_y <= 240;
end

        cm <= cm + 1;
cp <= cp + 1;
cp <= 0;

if (space && start)
  begin
          pause <= ~pause;
end else if (~pause && start) begin

    if (cm >= 200000) begin
        cm <= 0;

//  if (~w1 && x_mov && ~y_mov) begin

//  if (pc_x-9 >=160 && pc_x+9 <=480) begin
//  pc_x <= pc_x+1;
//  end
//  else begin
//  w1 <= ~w1;
//  end

//  end

//  else if (~v1 && ~x_mov && y_mov) begin

//  if (pc_y-12 >=20 && pc_y+12 <=460) begin
//  pc_y <= pc_y-1;
//  end
//  else begin
//  v1 <= ~v1;
//  end

//  end
//  else if (w1 && x_mov && ~y_mov) begin

//  if (pc_x-9 >=160 && pc_x+9 <=480) begin
//  pc_x <= pc_x-1;
//  end
//  else begin
//  w1 <= ~w1;
//  end

//  end
//  else if (v1 && ~x_mov && y_mov) begin

//  if (pc_y-12 >=20 && pc_y+12 <=460) begin
//  pc_y <= pc_y-1;
//  end
//  else begin
//  v1 <= ~v1;
//  end

//  end
if (x_mov && y_mov)
  begin

      if (~(pc_x - 9 >= 160)) begin w1 <= 1'b0;
pc_x <= pc_x + 2;
end if (~(pc_x + 9 <= 480)) begin w1 <= 1'b1;
pc_x <= pc_x - 2;
end if (~(pc_y - 12 >= 20)) begin v1 <= 1'b1;
pc_y <= pc_y + 2;
end if (~(pc_y + 12 <= 460)) begin v1 <= 1'b0;
pc_y <= pc_y - 2;
end

    //  if ((pc_x+9==upc_x-15) && (upc_y-20<=pc_y && pc_y<=upc_y+20)) begin w1 <= 1'b1; pc_x<=pc_x-2; end
    //  if ((pc_x-9==upc_x+15) && (upc_y-20<=pc_y && pc_y<=upc_y+20)) begin w1 <= 1'b0; pc_x <= pc_x+2; end
    //  if (pc_y+12==upc_y-20 && upc_x-15 <= pc_x && pc_x <= upc_x+15)  begin  v1 <= 1'b0; pc_y <= pc_y-2; end
    //  if (pc_y-12==upc_y+20 && upc_x-15 <= pc_x && pc_x<= upc_x+15)  begin  v1 = 1'b1; pc_y <= pc_y+2;end

    //  if ((pc_x+9==dpc_x_init-15) && (dpc_y_init-20<=pc_y && pc_y<=dpc_y_init+20)) begin w1 <= 1'b1; pc_x<=pc_x-2; end
    //  if ((pc_x-9==dpc_x_init+15) && (dpc_y_init-20<=pc_y && pc_y<=dpc_y_init+20)) begin w1 <= 1'b0; pc_x <= pc_x+2; end
    //  if (pc_y+12==dpc_y_init-20 && dpc_x_init-15 <= pc_x && pc_x <= dpc_x_init+15)  begin  v1 <= 1'b0; pc_y <= pc_y-2; end
    //  if (pc_y-12==dpc_y_init+20 && dpc_x_init-15 <= pc_x && pc_x<= dpc_x_init+15)  begin  v1 = 1'b1; pc_y <= pc_y+2;end

    if (~w1) begin pc_x <= pc_x + 1;
end if (w1) begin pc_x <= pc_x - 1;
end if (~v1) begin pc_y <= pc_y - 1;
end if (v1) begin pc_y <= pc_y + 1;
end

    if (pc_y + 12 == 460 && pc_x - 9 >= 290 && pc_x + 9 <= 350) begin
        score_2 <= score_2 + 1;
pc_x <= 320;
pc_y <= 280;
x_mov <= 0;
y_mov <= 0;
upc_x <= upc_x_init;
upc_y <= upc_y_init;
dpc_x <= dpc_x_init;
dpc_y <= dpc_y_init;
end else if (pc_y - 12 == 20 && pc_x - 9 >= 290 && pc_x + 9 <= 350) begin
        score_1 <= score_1 + 1;
x_mov <= 0;
y_mov <= 0;
pc_x <= 320;
pc_y <= 200;
upc_x <= upc_x_init;
upc_y <= upc_y_init;
dpc_x <= dpc_x_init;
dpc_y <= dpc_y_init;
end

        end
            end
                end

    //  if (11*upc_y - 15*upc_x - 280 ==6*pc_y - 8*pc_x +96 && (3<=pc_x && pc_x+3<=0) && (upc_x+15>=0 && upc_x+4<=0)) begin w1<=1; v1<=0; pc_x<=pc_x-2; pc_y<=pc_y-2; end
    if (((upc_x - 15 <= pc_x + 3 && pc_x + 3 <= upc_x - 4 && upc_y - 20 <= pc_y + 12 && pc_y + 12 <= upc_y - 5) || (upc_x - 15 <= pc_x + 9 && pc_x + 9 <= upc_x - 4 && upc_y - 20 <= pc_y + 4 && pc_y + 4 <= upc_y - 5))) begin if (~x_mov && ~y_mov) begin x_mov <= 1;
y_mov <= 1;
end w1 <= 1;
v1 <= 0;
pc_x <= pc_x - 2;
pc_y <= pc_y - 2;
end if (((upc_x + 4 <= pc_x - 9 && pc_x - 9 <= upc_x + 15 && upc_y + 5 <= pc_y - 4 && pc_y - 4 <= upc_y + 20) || (upc_x + 4 <= pc_x - 3 && pc_x - 3 <= upc_x + 15 && upc_y + 5 <= pc_y - 12 && pc_y - 12 <= upc_y + 20))) begin if (~x_mov && ~y_mov) begin x_mov <= 1;
y_mov <= 1;
end w1 <= 0;
v1 <= 1;
pc_x <= pc_x + 2;
pc_y <= pc_y + 2;
end if (((upc_x + 4 <= pc_x - 9 && pc_x - 9 <= upc_x + 15 && upc_y - 20 <= pc_y + 4 && pc_y + 4 <= upc_y - 5) || (upc_x + 4 <= pc_x - 3 && pc_x - 3 <= upc_x + 15 && upc_y - 20 <= pc_y + 12 && pc_y + 12 <= upc_y - 5))) begin if (~x_mov && ~y_mov) begin x_mov <= 1;
y_mov <= 1;
end w1 <= 0;
v1 <= 0;
pc_x <= pc_x + 2;
pc_y <= pc_y - 2;
end if (((upc_x - 15 <= pc_x + 3 && pc_x + 3 <= upc_x - 4 && upc_y + 5 <= pc_y - 12 && pc_y - 12 <= upc_y + 20) || (upc_x - 15 <= pc_x + 9 && pc_x + 9 <= upc_x - 4 && upc_y + 5 <= pc_y - 4 && pc_y - 4 <= upc_y + 20))) begin if (~x_mov && ~y_mov) begin x_mov <= 1;
y_mov <= 1;
end w1 <= 1;
v1 <= 1;
pc_x <= pc_x - 2;
pc_y <= pc_y - 2;
end if (((upc_x - 4 < pc_x + 3 && pc_x + 3 < upc_x + 4 && upc_y - 20 == pc_y + 12) || (upc_x - 4 < pc_x - 3 && pc_x - 3 < upc_x + 4 && upc_y - 20 == pc_y + 12))) begin v1 <= ~v1;
pc_y <= pc_y - 2;
end if (((upc_x - 4 < pc_x + 3 && pc_x + 3 < upc_x + 4 && upc_y + 20 == pc_y - 12) || (upc_x - 4 < pc_x - 3 && pc_x - 3 < upc_x + 4 && upc_y + 20 == pc_y - 12))) begin v1 <= ~v1;
pc_y <= pc_y + 2;
end if (((upc_y - 5 < pc_y - 4 && pc_y - 4 < upc_y + 5 && upc_x - 15 == pc_x + 9) || (upc_y - 5 < pc_y + 4 && pc_y + 4 < upc_y + 5 && upc_x - 15 == pc_x + 9))) begin w1 <= ~w1;
pc_x <= pc_x - 2;
end if (((upc_y - 5 < pc_y - 4 && pc_y - 4 < upc_y + 5 && upc_x + 15 == pc_x - 9) || (upc_y - 5 < pc_y + 4 && pc_y + 4 < upc_y + 5 && upc_x + 15 == pc_x - 9))) begin w1 <= ~w1;
pc_x <= pc_x + 2;
end

    if (((dpc_x - 15 <= pc_x + 3 && pc_x + 3 <= dpc_x - 4 && dpc_y - 20 <= pc_y + 12 && pc_y + 12 <= dpc_y - 5) || (dpc_x - 15 <= pc_x + 9 && pc_x + 9 <= dpc_x - 4 && dpc_y - 20 <= pc_y + 4 && pc_y + 4 <= dpc_y - 5))) begin if (~x_mov && ~y_mov) begin x_mov <= 1;
y_mov <= 1;
end w1 <= 1;
v1 <= 0;
pc_x <= pc_x - 2;
pc_y <= pc_y - 2;
end if (((dpc_x + 4 <= pc_x - 9 && pc_x - 9 <= dpc_x + 15 && dpc_y + 5 <= pc_y - 4 && pc_y - 4 <= dpc_y + 20) || (dpc_x + 4 <= pc_x - 3 && pc_x - 3 <= dpc_x + 15 && dpc_y + 5 <= pc_y - 12 && pc_y - 12 <= dpc_y + 20))) begin if (~x_mov && ~y_mov) begin x_mov <= 1;
y_mov <= 1;
end w1 <= 0;
v1 <= 1;
pc_x <= pc_x + 2;
pc_y <= pc_y + 2;
end if (((dpc_x + 4 <= pc_x - 9 && pc_x - 9 <= dpc_x + 15 && dpc_y - 20 <= pc_y + 4 && pc_y + 4 <= dpc_y - 5) || (dpc_x + 4 <= pc_x - 3 && pc_x - 3 <= dpc_x + 15 && dpc_y - 20 <= pc_y + 12 && pc_y + 12 <= dpc_y - 5))) begin if (~x_mov && ~y_mov) begin x_mov <= 1;
y_mov <= 1;
end w1 <= 0;
v1 <= 0;
pc_x <= pc_x + 2;
pc_y <= pc_y - 2;
end if (((dpc_x - 15 <= pc_x + 3 && pc_x + 3 <= dpc_x - 4 && dpc_y + 5 <= pc_y - 12 && pc_y - 12 <= dpc_y + 20) || (dpc_x - 15 <= pc_x + 9 && pc_x + 9 <= dpc_x - 4 && dpc_y + 5 <= pc_y - 4 && pc_y - 4 <= dpc_y + 20))) begin if (~x_mov && ~y_mov) begin x_mov <= 1;
y_mov <= 1;
end w1 <= 1;
v1 <= 1;
pc_x <= pc_x - 2;
pc_y <= pc_y - 2;
end if (((dpc_x - 4 < pc_x + 3 && pc_x + 3 < dpc_x + 4 && dpc_y - 20 == pc_y + 12) || (dpc_x - 4 < pc_x - 3 && pc_x - 3 < dpc_x + 4 && dpc_y - 20 == pc_y + 12))) begin if (~x_mov && ~y_mov) begin y_mov <= 1;
end v1 <= ~v1;
pc_y <= pc_y - 2;
end if (((dpc_x - 4 < pc_x + 3 && pc_x + 3 < dpc_x + 4 && dpc_y + 20 == pc_y - 12) || (dpc_x - 4 < pc_x - 3 && pc_x - 3 < dpc_x + 4 && dpc_y + 20 == pc_y - 12))) begin if (~x_mov && ~y_mov) begin y_mov <= 1;
end v1 <= ~v1;
pc_y <= pc_y + 2;
end if (((dpc_y - 5 < pc_y - 4 && pc_y - 4 < dpc_y + 5 && dpc_x - 15 == pc_x + 9) || (dpc_y - 5 < pc_y + 4 && pc_y + 4 < dpc_y + 5 && dpc_x - 15 == pc_x + 9))) begin if (~x_mov && ~y_mov) begin x_mov <= 1;
end w1 <= ~w1;
pc_x <= pc_x - 2;
end if (((dpc_y - 5 < pc_y - 4 && pc_y - 4 < dpc_y + 5 && dpc_x + 15 == pc_x - 9) || (dpc_y - 5 < pc_y + 4 && pc_y + 4 < dpc_y + 5 && dpc_x + 15 == pc_x - 9))) begin if (~x_mov && ~y_mov) begin x_mov <= 1;
end w1 <= ~w1;
pc_x <= pc_x + 2;
end

    // if ((pc_x+9==upc_x-15) && ((upc_y-20<=pc_y-12 && pc_y-12<=upc_y+20)||(upc_y-20<=pc_y+12 && pc_y+12<=upc_y+20))) begin w1 <= 1'b1; pc_x<=pc_x-2; end
    // if ((pc_x-9==upc_x+15) && ((upc_y-20<=pc_y-12 && pc_y-12<=upc_y+20)||(upc_y-20<=pc_y+12 && pc_y+12<=upc_y+20))) begin w1 <= 1'b0; pc_x <= pc_x+2; end
    // if (pc_y+12==upc_y-20 && ((upc_x-15 <= pc_x-9 && pc_x-9 <= upc_x+15)||(upc_x-15 <= pc_x+9 && pc_x+9 <= upc_x+15)))  begin  v1 <= 1'b0; pc_y <= pc_y-2; end
    // if (pc_y-12==upc_y+20 && ((upc_x-15 <= pc_x-9 && pc_x-9 <= upc_x+15)||(upc_x-15 <= pc_x+9 && pc_x+9 <= upc_x+15)))  begin if (~x_mov && ~y_mov) begin  x_mov <= 1'b1; y_mov <= 1'b1; end     v1 <= 1'b1; pc_y <= pc_y+2;end

    //  if ((pc_x+9==dpc_x-15) && ((dpc_y-20<=pc_y-12 && pc_y-12<=dpc_y+20)||(dpc_y-20<=pc_y+12 && pc_y+12<=dpc_y+20))) begin w1 <= 1'b1; pc_x<=pc_x-2; end
    //  if ((pc_x-9==dpc_x+15) && ((dpc_y-20<=pc_y-12 && pc_y-12<=dpc_y+20)||(dpc_y-20<=pc_y+12 && pc_y+12<=dpc_y+20))) begin w1 <= 1'b0; pc_x <= pc_x+2; end
    //  if (pc_y+12==dpc_y-20 && ((dpc_x-15 <= pc_x-9 && pc_x-9 <= dpc_x+15)||(dpc_x-15 <= pc_x+9 && pc_x+9 <= dpc_x+15)))  begin  v1 <= 1'b0; pc_y <= pc_y-2; end
    //  if (pc_y-12==dpc_y+20 && ((dpc_x-15 <= pc_x-9 && pc_x-9 <= dpc_x+15)||(dpc_x-15 <= pc_x+9 && pc_x+9 <= dpc_x+15)))  begin  v1 <= 1'b1; pc_y <= pc_y+2;end

    if (score_1 == 2 || score_1 == 3 || score_1 == 5 || score_1 == 6 || score_1 == 7 || score_1 == 8 || score_1 == 0) begin a1 <= 4'hF;
end else begin a1 <= 4'h2;
end if (score_1 == 4 || score_1 == 5 || score_1 == 6 || score_1 == 8 || score_1 == 0) begin a2 <= 4'hF;
end else begin a2 <= 4'h2;
end if (score_1 == 1 || score_1 == 2 || score_1 == 3 || score_1 == 4 || score_1 == 7 || score_1 == 8 || score_1 == 0) begin a3 <= 4'hF;
end else begin a3 <= 4'h2;
end if (score_1 == 2 || score_1 == 3 || score_1 == 4 || score_1 == 5 || score_1 == 6 || score_1 == 8) begin a4 <= 4'hF;
end else begin a4 <= 4'h2;
end if (score_1 == 2 || score_1 == 6 || score_1 == 8 || score_1 == 0) begin a5 <= 4'hF;
end else begin a5 <= 4'h2;
end if (~(score_1 == 2)) begin a6 <= 4'hF;
end else begin a6 <= 4'h2;
end if (score_1 == 2 || score_1 == 3 || score_1 == 5 || score_1 == 6 || score_1 == 8 || score_1 == 0) begin a7 <= 4'hF;
end else begin a7 <= 4'h2;
end

    if (score_2 == 2 || score_2 == 3 || score_2 == 5 || score_2 == 6 || score_2 == 7 || score_2 == 8 || score_2 == 0) begin b1 <= 4'hF;
end else begin b1 <= 4'h2;
end if (score_2 == 4 || score_2 == 5 || score_2 == 6 || score_2 == 8 || score_2 == 0) begin b2 <= 4'hF;
end else begin b2 <= 4'h2;
end if (score_2 == 1 || score_2 == 2 || score_2 == 3 || score_2 == 4 || score_2 == 7 || score_2 == 8 || score_2 == 0) begin b3 <= 4'hF;
end else begin b3 <= 4'h2;
end if (score_2 == 2 || score_2 == 3 || score_2 == 4 || score_2 == 5 || score_2 == 6 || score_2 == 8) begin b4 <= 4'hF;
end else begin b4 <= 4'h2;
end if (score_2 == 2 || score_2 == 6 || score_2 == 8 || score_2 == 0) begin b5 <= 4'hF;
end else begin b5 <= 4'h2;
end if (~(score_2 == 2)) begin b6 <= 4'hF;
end else begin b6 <= 4'h2;
end if (score_2 == 2 || score_2 == 3 || score_2 == 5 || score_2 == 6 || score_2 == 8 || score_2 == 0) begin b7 <= 4'hF;
end else begin b7 <= 4'h2;
end
        end
            end

    if (((pixel_x <= 160) || (pixel_x >= 480)) || ((pixel_y <= 20) || (pixel_y >= 460))) begin
        // side
        red <= 4'h0;
blue <= 4'h0;
green <= 4'h0;
end

    // left score
    if (50 <= pixel_x && pixel_x <= 110 && 120 <= pixel_y && pixel_y <= 140) begin
        red <= a1;
blue <= 4'h0;
green <= 4'h0;
end if (50 <= pixel_x && pixel_x <= 110 && 230 <= pixel_y && pixel_y <= 250) begin
        red <= a4;
blue <= 4'h0;
green <= 4'h0;
end if (50 <= pixel_x && pixel_x <= 110 && 340 <= pixel_y && pixel_y <= 360) begin
        red <= a7;
blue <= 4'h0;
green <= 4'h0;
end if (25 <= pixel_x && pixel_x <= 45 && 145 <= pixel_y && pixel_y <= 225) begin
        red <= a2;
blue <= 4'h0;
green <= 4'h0;
end if (25 <= pixel_x && pixel_x <= 45 && 255 <= pixel_y && pixel_y <= 335) begin
        red <= a5;
blue <= 4'h0;
green <= 4'h0;
end if (115 <= pixel_x && pixel_x <= 135 && 145 <= pixel_y && pixel_y <= 225) begin
        red <= a3;
blue <= 4'h0;
green <= 4'h0;
end if (115 <= pixel_x && pixel_x <= 135 && 255 <= pixel_y && pixel_y <= 335) begin
        red <= a6;
blue <= 4'h0;
green <= 4'h0;
end

    // right score
    if (530 <= pixel_x && pixel_x <= 590 && 120 <= pixel_y && pixel_y <= 140) begin
        red <= b1;
blue <= 4'h0;
green <= 4'h0;
end if (530 <= pixel_x && pixel_x <= 590 && 230 <= pixel_y && pixel_y <= 250) begin
        red <= b4;
blue <= 4'h0;
green <= 4'h0;
end if (530 <= pixel_x && pixel_x <= 590 && 340 <= pixel_y && pixel_y <= 360) begin
        red <= b7;
blue <= 4'h0;
green <= 4'h0;
end if (505 <= pixel_x && pixel_x <= 525 && 145 <= pixel_y && pixel_y <= 225) begin
        red <= b2;
blue <= 4'h0;
green <= 4'h0;
end if (505 <= pixel_x && pixel_x <= 525 && 255 <= pixel_y && pixel_y <= 335) begin
        red <= b5;
blue <= 4'h0;
green <= 4'h0;
end if (595 <= pixel_x && pixel_x <= 615 && 145 <= pixel_y && pixel_y <= 225) begin
        red <= b3;
blue <= 4'h0;
green <= 4'h0;
end if (595 <= pixel_x && pixel_x <= 615 && 255 <= pixel_y && pixel_y <= 335) begin
        red <= b6;
blue <= 4'h0;
green <= 4'h0;
end

    if ((pixel_x > 160 && pixel_x < 480) && (pixel_y > 20 && pixel_y < 460)) begin
        // size
        red <= 4'h0;
blue <= 4'hF;
green <= 4'h0;

if ((pixel_x > 290 && pixel_x < 350) && ((pixel_y > 20 && pixel_y < 50) || (pixel_y > 430 && pixel_y < 460)))
  begin
          red <= 4'hF;
blue <= 4'hF;
green <= 4'hF;
end if ((pixel_x > 160 && pixel_x < 480) && (pixel_y > 238 && pixel_y < 241)) begin
        red <= 4'h0;
blue <= 4'h0;
green <= 4'h0;
end

    if ((18 * 18 * (pixel_y - 430) * (pixel_y - 430) <= ((18 * 18 * 24 * 24) - (24 * 24 * (pixel_x - 320) * (pixel_x - 320)))) && ((pixel_x > 302 && pixel_x < 338) && (pixel_y > 406 && pixel_y < 454))) begin
        red <= 4'hF;
green <= 4'hF;
blue <= 4'hF;
end if ((18 * 18 * (pixel_y - 50) * (pixel_y - 50) <= ((18 * 18 * 24 * 24) - (24 * 24 * (pixel_x - 320) * (pixel_x - 320)))) && ((pixel_x > 302 && pixel_x < 338) && (pixel_y > 26 && pixel_y < 74))) begin
        red <= 4'hF;
green <= 4'hF;
blue <= 4'hF;
end if (circle_x && circle_y) begin if (((9 * 9 * (pixel_y - pc_y) * (pixel_y - pc_y)) <= ((12 * 12 * 9 * 9) - ((12 * 12 * (pixel_x - pc_x) * (pixel_x - pc_x))))) && ((pixel_x > pc_x - 9 && pixel_x < pc_x + 9) && (pixel_y > pc_y - 12 && pixel_y < pc_y + 12))) begin
        // puck
        red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;

end
        end else begin
            score_1 <= 0;
score_2 <= 0;
if (((9 * 9 * (pixel_y - pc_y_init) * (pixel_y - pc_y_init)) <= ((12 * 12 * 9 * 9) - ((12 * 12 * (pixel_x - pc_x_init) * (pixel_x - pc_x_init))))) && ((pixel_x > pc_x_init - 9 && pixel_x < pc_x_init + 9) && (pixel_y > pc_y_init - 12 && pixel_y < pc_y_init + 12)))
  begin
          //
          red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
pc_y <= pc_y_init;
pc_x <= pc_x_init;
end
        end

            //     if ((((pixel_y-50)*(pixel_y-50)<=((25*25)-((pixel_x-320)*(pixel_x-320))))&&((pixel_x>295 && pixel_x<345)&&(pixel_y>25 && pixel_y<75)))&&(((pixel_y-50)*(pixel_y-50)<=((20*20)-((pixel_x-320)*(pixel_x-320))))&&((pixel_x>300 && pixel_x<340)&&(pixel_y>30 && pixel_y<70)))) begin
            //            red<=4'hF;
            //            green<=4'hF;
            //            blue<=4'hF;
            //     end
            //     if ((18*18*(pixel_y-430)*(pixel_y-430)<=((18*18*24*24)-(24*24*(pixel_x-320)*(pixel_x-320))))&&((pixel_x>302 && pixel_x<338)&&(pixel_y>406 && pixel_y<454))) begin
            //            red<=4'hF;
            //            green<=4'hF;
            //            blue<=4'hF;
            //     end
            end if (circle_x && circle_y) begin if ((15 * 15 * (pixel_y - upc_y) * (pixel_y - upc_y) <= ((15 * 15 * 20 * 20) - (20 * 20 * (pixel_x - upc_x) * (pixel_x - upc_x)))) && ((pixel_x > upc_x - 15 && pixel_x < upc_x + 15) && (pixel_y > upc_y - 20 && pixel_y < upc_y + 20))) begin
                //&&((pixel_x>300 && pixel_x<340)&&(pixel_y>220 && pixel_y<260))
                // paddle uper wala
                red <= 4'hF;
green <= 4'hF;
blue <= 4'h0;

end
        end else begin if ((15 * 15 * (pixel_y - upc_y_init) * (pixel_y - upc_y_init) <= ((15 * 15 * 20 * 20) - (20 * 20 * (pixel_x - upc_x_init) * (pixel_x - upc_x_init)))) && ((pixel_x > upc_x_init - 15 && pixel_x < upc_x_init + 15) && (pixel_y > upc_y_init - 20 && pixel_y < upc_y_init + 20))) begin
            //
            red <= 4'hF;
green <= 4'hF;
blue <= 4'h0;
upc_y <= upc_y_init;
upc_x <= upc_x_init;
end
        end

    // paddle nichay wala
    if (circle_x && circle_y) begin if ((15 * 15 * (pixel_y - dpc_y) * (pixel_y - dpc_y) <= ((15 * 15 * 20 * 20) - (20 * 20 * (pixel_x - dpc_x) * (pixel_x - dpc_x)))) && ((pixel_x > dpc_x - 15 && pixel_x < dpc_x + 15) && (pixel_y > dpc_y - 20 && pixel_y < dpc_y + 20))) begin
        //&&((pixel_x>300 && pixel_x<340)&&(pixel_y>220 && pixel_y<260))
        red <= 4'hF;
green <= 4'hF;
blue <= 4'h0;

end
        end else begin if ((15 * 15 * (pixel_y - dpc_y_init) * (pixel_y - dpc_y_init) <= ((20 * 20 * 15 * 15) - (20 * 20 * (pixel_x - dpc_x_init) * (pixel_x - dpc_x_init)))) && ((pixel_x > dpc_x_init - 15 && pixel_x < dpc_x_init + 15) && (pixel_y > dpc_y_init - 20 && pixel_y < dpc_y_init + 20))) begin
            //
            red <= 4'hF;
green <= 4'hF;
blue <= 4'h0;
dpc_y <= dpc_y_init;
dpc_x <= dpc_x_init;
end
        end
    //     if (((18*18*(pixel_y-50)*(pixel_y-50)<=((18*18*24*24)-(24*24*(pixel_x-320)*(pixel_x-320))))&&((pixel_x>302 && pixel_x<338)&&(pixel_y>26 && pixel_y<76)))&&(((pixel_y-50)*(pixel_y-50)<=((20*20)-((pixel_x-320)*(pixel_x-320))))&&((pixel_x>300 && pixel_x<340)&&(pixel_y>30 && pixel_y<70)))) begin
    //            red<=4'hF;
    //            green<=4'hF;
    //            blue<=4'hF;
    //     end
    if (~start) begin if (pixel_x > 160 && pixel_x < 480 && pixel_y > 223 && pixel_y < 257) begin
        red <= 4'h2;
green <= 4'h2;
blue <= 4'h2;
end

    if (281 <= pixel_x && pixel_x <= 291 && 226 <= pixel_y && pixel_y <= 227) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (279 <= pixel_x && pixel_x <= 280 && 228 <= pixel_y && pixel_y <= 238) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (281 <= pixel_x && pixel_x <= 291 && 239 <= pixel_y && pixel_y <= 240) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (292 <= pixel_x && pixel_x <= 293 && 241 <= pixel_y && pixel_y <= 251) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (281 <= pixel_x && pixel_x <= 291 && 252 <= pixel_y && pixel_y <= 253) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end

    if (293 <= pixel_x && pixel_x <= 307 && 226 <= pixel_y && pixel_y <= 227) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (300 <= pixel_x && pixel_x <= 301 && 226 <= pixel_y && pixel_y <= 253) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end

    if (312 <= pixel_x && pixel_x <= 322 && 226 <= pixel_y && pixel_y <= 227) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (310 <= pixel_x && pixel_x <= 311 && 228 <= pixel_y && pixel_y <= 238) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (310 <= pixel_x && pixel_x <= 311 && 241 <= pixel_y && pixel_y <= 251) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (312 <= pixel_x && pixel_x <= 322 && 239 <= pixel_y && pixel_y <= 240) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (323 <= pixel_x && pixel_x <= 324 && 228 <= pixel_y && pixel_y <= 238) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (323 <= pixel_x && pixel_x <= 324 && 241 <= pixel_y && pixel_y <= 251) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end

    if (329 <= pixel_x && pixel_x <= 339 && 226 <= pixel_y && pixel_y <= 227) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (327 <= pixel_x && pixel_x <= 328 && 228 <= pixel_y && pixel_y <= 238) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (327 <= pixel_x && pixel_x <= 328 && 241 <= pixel_y && pixel_y <= 251) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (329 <= pixel_x && pixel_x <= 339 && 239 <= pixel_y && pixel_y <= 240) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (340 <= pixel_x && pixel_x <= 341 && 228 <= pixel_y && pixel_y <= 238) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (337 <= pixel_x && pixel_x <= 338 && 241 <= pixel_y && pixel_y <= 251) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end

    if (344 <= pixel_x && pixel_x <= 358 && 226 <= pixel_y && pixel_y <= 227) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (351 <= pixel_x && pixel_x <= 352 && 226 <= pixel_y && pixel_y <= 253) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end

        end

    else if (pause) begin if (pixel_x > 160 && pixel_x < 480 && pixel_y > 223 && pixel_y < 257) begin
        red <= 4'h2;
green <= 4'h2;
blue <= 4'h2;
end

    if (281 <= pixel_x && pixel_x <= 291 && 226 <= pixel_y && pixel_y <= 227) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (279 <= pixel_x && pixel_x <= 280 && 228 <= pixel_y && pixel_y <= 238) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (281 <= pixel_x && pixel_x <= 291 && 239 <= pixel_y && pixel_y <= 240) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (279 <= pixel_x && pixel_x <= 280 && 241 <= pixel_y && pixel_y <= 251) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (292 <= pixel_x && pixel_x <= 293 && 228 <= pixel_y && pixel_y <= 238) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end

    if (298 <= pixel_x && pixel_x <= 308 && 226 <= pixel_y && pixel_y <= 227) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (296 <= pixel_x && pixel_x <= 297 && 228 <= pixel_y && pixel_y <= 238) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (298 <= pixel_x && pixel_x <= 308 && 239 <= pixel_y && pixel_y <= 240) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (296 <= pixel_x && pixel_x <= 297 && 241 <= pixel_y && pixel_y <= 251) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (309 <= pixel_x && pixel_x <= 310 && 228 <= pixel_y && pixel_y <= 238) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (309 <= pixel_x && pixel_x <= 310 && 241 <= pixel_y && pixel_y <= 251) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end

    if (315 <= pixel_x && pixel_x <= 325 && 252 <= pixel_y && pixel_y <= 253) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (313 <= pixel_x && pixel_x <= 314 && 228 <= pixel_y && pixel_y <= 238) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (313 <= pixel_x && pixel_x <= 314 && 241 <= pixel_y && pixel_y <= 251) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (326 <= pixel_x && pixel_x <= 327 && 228 <= pixel_y && pixel_y <= 238) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (326 <= pixel_x && pixel_x <= 327 && 241 <= pixel_y && pixel_y <= 251) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end

    if (332 <= pixel_x && pixel_x <= 342 && 226 <= pixel_y && pixel_y <= 227) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (330 <= pixel_x && pixel_x <= 331 && 228 <= pixel_y && pixel_y <= 238) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (332 <= pixel_x && pixel_x <= 342 && 239 <= pixel_y && pixel_y <= 240) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (332 <= pixel_x && pixel_x <= 342 && 252 <= pixel_y && pixel_y <= 253) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (343 <= pixel_x && pixel_x <= 344 && 241 <= pixel_y && pixel_y <= 251) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end

    if (349 <= pixel_x && pixel_x <= 359 && 226 <= pixel_y && pixel_y <= 227) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (347 <= pixel_x && pixel_x <= 348 && 228 <= pixel_y && pixel_y <= 238) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (349 <= pixel_x && pixel_x <= 359 && 239 <= pixel_y && pixel_y <= 240) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (349 <= pixel_x && pixel_x <= 359 && 252 <= pixel_y && pixel_y <= 253) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (347 <= pixel_x && pixel_x <= 348 && 241 <= pixel_y && pixel_y <= 251) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end
        end

    else if (~game_on) begin if (pixel_x > 160 && pixel_x < 480 && pixel_y > 223 && pixel_y < 257) begin
        red <= 4'h2;
green <= 4'h2;
blue <= 4'h2;
end

    if (281 <= pixel_x && pixel_x <= 291 && 226 <= pixel_y && pixel_y <= 227) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (279 <= pixel_x && pixel_x <= 280 && 228 <= pixel_y && pixel_y <= 238) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (281 <= pixel_x && pixel_x <= 291 && 239 <= pixel_y && pixel_y <= 240) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (279 <= pixel_x && pixel_x <= 280 && 241 <= pixel_y && pixel_y <= 251) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (292 <= pixel_x && pixel_x <= 293 && 228 <= pixel_y && pixel_y <= 238) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end

    if (p1) begin if (298 <= pixel_x && pixel_x <= 308 && 226 <= pixel_y && pixel_y <= 227) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (309 <= pixel_x && pixel_x <= 310 && 228 <= pixel_y && pixel_y <= 238) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (298 <= pixel_x && pixel_x <= 308 && 239 <= pixel_y && pixel_y <= 240) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (298 <= pixel_x && pixel_x <= 308 && 252 <= pixel_y && pixel_y <= 253) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (296 <= pixel_x && pixel_x <= 297 && 241 <= pixel_y && pixel_y <= 251) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end
        end

    else if (p2) begin if (309 <= pixel_x && pixel_x <= 310 && 228 <= pixel_y && pixel_y <= 238) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (309 <= pixel_x && pixel_x <= 310 && 241 <= pixel_y && pixel_y <= 251) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end
        end

    if (315 <= pixel_x && pixel_x <= 325 && 252 <= pixel_y && pixel_y <= 253) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (313 <= pixel_x && pixel_x <= 314 && 228 <= pixel_y && pixel_y <= 238) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (313 <= pixel_x && pixel_x <= 314 && 241 <= pixel_y && pixel_y <= 251) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (326 <= pixel_x && pixel_x <= 327 && 228 <= pixel_y && pixel_y <= 238) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (326 <= pixel_x && pixel_x <= 327 && 241 <= pixel_y && pixel_y <= 251) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (328 <= pixel_x && pixel_x <= 338 && 252 <= pixel_y && pixel_y <= 253) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (339 <= pixel_x && pixel_x <= 340 && 228 <= pixel_y && pixel_y <= 238) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (339 <= pixel_x && pixel_x <= 340 && 241 <= pixel_y && pixel_y <= 251) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end

    if (345 <= pixel_x && pixel_x <= 355 && 226 <= pixel_y && pixel_y <= 227) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (345 <= pixel_x && pixel_x <= 355 && 252 <= pixel_y && pixel_y <= 253) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (343 <= pixel_x && pixel_x <= 344 && 228 <= pixel_y && pixel_y <= 238) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (343 <= pixel_x && pixel_x <= 344 && 241 <= pixel_y && pixel_y <= 251) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (356 <= pixel_x && pixel_x <= 357 && 228 <= pixel_y && pixel_y <= 238) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (356 <= pixel_x && pixel_x <= 357 && 241 <= pixel_y && pixel_y <= 251) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end

    if (362 <= pixel_x && pixel_x <= 372 && 226 <= pixel_y && pixel_y <= 227) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (360 <= pixel_x && pixel_x <= 361 && 228 <= pixel_y && pixel_y <= 238) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (360 <= pixel_x && pixel_x <= 361 && 241 <= pixel_y && pixel_y <= 251) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (373 <= pixel_x && pixel_x <= 374 && 228 <= pixel_y && pixel_y <= 238) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end if (373 <= pixel_x && pixel_x <= 374 && 241 <= pixel_y && pixel_y <= 251) begin red <= 4'hF;
green <= 4'h0;
blue <= 4'h0;
end

        end

            //     if(293<=pixel_x && pixel_x <= 307 && 226<=pixel_y && pixel_y<=227)begin red <= 4'hF; green <= 4'h0; blue <= 4'h0; end
            //     if (300<=pixel_x && pixel_x<=301 && 226<=pixel_y && pixel_y<=253) begin red <= 4'hF; green <= 4'h0; blue <= 4'h0; end

            //     if (312 <= pixel_x && pixel_x <= 322 && 226<= pixel_y && pixel_y<=227) begin red <= 4'hF; green <= 4'h0; blue <= 4'h0; end
            //     if (310 <= pixel_x && pixel_x <= 311 && 228<= pixel_y && pixel_y<=238) begin red <= 4'hF; green <= 4'h0; blue <= 4'h0; end
            //     if (310 <= pixel_x && pixel_x <= 311 && 241<= pixel_y && pixel_y<=251) begin red <= 4'hF; green <= 4'h0; blue <= 4'h0; end
            //     if (312 <= pixel_x && pixel_x <= 322 && 239<= pixel_y && pixel_y<=240) begin red <= 4'hF; green <= 4'h0; blue <= 4'h0; end
            //     if (323 <= pixel_x && pixel_x <= 324 && 228<= pixel_y && pixel_y<=238) begin red <= 4'hF; green <= 4'h0; blue <= 4'h0; end
            //     if (323 <= pixel_x && pixel_x <= 324 && 241<= pixel_y && pixel_y<=251) begin red <= 4'hF; green <= 4'h0; blue <= 4'h0; end

            //     if (329 <= pixel_x && pixel_x <= 339 && 226<= pixel_y && pixel_y<=227) begin red <= 4'hF; green <= 4'h0; blue <= 4'h0; end
            //     if (327 <= pixel_x && pixel_x <= 328 && 228<= pixel_y && pixel_y<=238) begin red <= 4'hF; green <= 4'h0; blue <= 4'h0; end
            //     if (327 <= pixel_x && pixel_x <= 328 && 241<= pixel_y && pixel_y<=251) begin red <= 4'hF; green <= 4'h0; blue <= 4'h0; end
            //     if (329 <= pixel_x && pixel_x <= 339 && 239<= pixel_y && pixel_y<=240) begin red <= 4'hF; green <= 4'h0; blue <= 4'h0; end
            //     if (340 <= pixel_x && pixel_x <= 341 && 228<= pixel_y && pixel_y<=238) begin red <= 4'hF; green <= 4'h0; blue <= 4'h0; end
            //     if (337 <= pixel_x && pixel_x <= 338 && 241<= pixel_y && pixel_y<=251) begin red <= 4'hF; green <= 4'h0; blue <= 4'h0; end

            //     if(344<=pixel_x && pixel_x <= 358 && 226<=pixel_y && pixel_y<=227)begin red <= 4'hF; green <= 4'h0; blue <= 4'h0; end
            //     if (351<=pixel_x && pixel_x<=352 && 226<=pixel_y && pixel_y<=253) begin red <= 4'hF; green <= 4'h0; blue <= 4'h0; end

            counter_m <= counter_m + 1;
end

    endmodule

        //--------------------------------------
        module top_module1(clk_i, h_sync, v_sync, red_o, green_o, blue_o, x_in, y_in, ps2clk, ps2data, ld1);
input clk_i;
input x_in;
input y_in;
wire clk_d_o;
wire [9:0] h_count;
wire [9:0] v_count;
wire trig_o;
wire clk_do2;

output h_sync;
output v_sync;

wire video_on;
wire [9:0] x_loc;
wire [9:0] y_loc;

output [3:0] red_o;
output [3:0] green_o;
output [3:0] blue_o;

wire u;
wire d;
wire l;
wire r;
wire w, a, s, d1, ent, spc;
input ps2clk;
input ps2data;
output ld1;
wire Game_on, Pause;
wire p1, p2;
wire A, B, Bin;
wire Ain;
wire T; // new clock
clk_div3 a1(clk, T);
clk_div g1(.clk(clk_i), .clk_d(clk_d_o));
clk_div2 c12(clk_i, clk_do2);
counter_10_bit h_1(.clk(clk_d_o), .count(h_count), .trig(trig_o));
counter_10_bit1 v_1(.clk(clk_d_o), .enable(trig_o), .count(v_count));
wire rst = 0;
wire C, D, E, F;
vga_sync vga_sync1(.h_count(h_count), .v_count(v_count), .h_sync(h_sync), .v_sync(v_sync), .video_on(video_on), .x_loc(x_loc), .y_loc(y_loc));
Keyboard k1(clk_d_o, ps2clk, ps2data, u, d, l, r, w, a, s, d1, C, D);
DFF a2(Ain, T, A, rst);
DFF a3(Bin, T, B, rst);
assign Ain = (((~A) && (B) && (F)) || ((~A) && (B) && (E)) || ((~A) && (B) && (D)) || ((A) && (B) && (~C)) || ((A) & (~B) && (~D) && (~E)) || ((A) & (~B) && (~D) && (~F)) || ((A) && (~B) && (C) && (~D)));
assign Bin = (((~A) && (C) && (~D)) || ((~B) && (C) && (D)) || ((B) && (~C) && (~D)) || ((A) && (~C) && (D)) || ((~A) && (B) && (E)) || ((~A) && (B) && (F))); // A'CD' + B'CD + BC'D' + A'BF + A'BE + AC'D
assign Game_on = (((~A) && (B)) || ((A) && (~B)));                                                                                                             // A'B + AB'
assign Pause = ((A) && (~B));                                                                                                                                  // AB'
assign ld1 = u;
pixel_gen pixel_gen1(.clk_d(clk_i), .pixel_x(x_loc), .pixel_y(y_loc), .video_on(video_on), .red(red_o), .green(green_o), .blue(blue_o), .circle_x(x_in), .circle_y(y_in), .clk_d2(clk_do2), .up(u), .left(l), .right(r), .down(d), .w(w), .a(a), .s(s), .dk(d1), .enter(C), .space(D), .p1(p1), .p2(p2), .game_on(Game_on), .pause());

endmodule
