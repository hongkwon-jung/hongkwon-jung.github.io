module slot_top_new (
  input pg, ps, pe, dg, ds, de, mod, in_b, out_b, can_b, fail_b, give_up_b, clk, reset,
  input [5:0] slot_b,
  output s_f,
  output [5:0] slot_n, slot_s
);
  wire clr, clr_e, clr_s, load_m, load_b, load_e, load_s, shift, up_d, w2, w3;
  wire button, in, out, has, ev, can, fail, change, give_up, slot_ev;
  
  slot_controller_new controller (
    .clr(clr), 
    .clr_e(clr_e), 
    .clr_s(clr_s), 
    .load_m(load_m),
    .load_b(load_b), 
    .load_e(load_e), 
    .s_f(s_f), 
    .load_s(load_s), 
    .shift(shift), 
    .up_d(up_d), 
    .w2(w2), 
    .w3(w3),
    .button(button), 
    .in(in), 
    .out(out), 
    .has(has), 
    .ev(ev), 
    .can(can), 
    .fail(fail), 
    .change(change), 
    .give_up(give_up), 
    .slot_ev(slot_ev), 
    .clk(clk), 
    .reset(reset)
  );
  
  slot_datapath_new datapath (
    .button(button), 
    .in(in), 
    .out(out), 
    .has(has), 
    .ev(ev), 
    .can(can), 
    .fail(fail), 
    .change(change), 
    .give_up(give_up), 
    .slot_ev(slot_ev),
    .slot_n(slot_n), 
    .slot_s(slot_s),
    .slot_b(slot_b),
    .clr(clr), 
    .clr_e(clr_e), 
    .clr_s(clr_s), 
    .load_m(load_m),
    .load_b(load_b), 
    .load_e(load_e), 
    .s_f(s_f), 
    .load_s(load_s), 
    .shift(shift), 
    .up_d(up_d), 
    .w2(w2), 
    .w3(w3),
    .pg(pg), 
    .ps(ps), 
    .pe(pe), 
    .dg(dg), 
    .ds(ds), 
    .de(de), 
    .mod(mod), 
    .in_b(in_b), 
    .out_b(out_b), 
    .can_b(can_b), 
    .fail_b(fail_b), 
    .give_up_b(give_up_b), 
    .clk(clk), 
    .reset(reset)
  );
  
endmodule

module slot_controller_new (
 output reg clr, clr_e, clr_s, load_m, load_b, load_e, s_f, load_s, shift, up_d, w2, w3,
 input button, in, out, has, ev, can, fail, change, give_up, slot_ev, clk, reset
);
  
  reg has_e, stay;

  reg [7:0] state;
  parameter s0=8'b0000_0001, s1=8'b0000_0010, s2=8'b0000_0100, s3=8'b0000_1000, s4=8'b0001_0000, s5=8'b0010_0000, s6=8'b0100_0000, s7=8'b1000_0000;
  
  reg state2;
  parameter SS0=0, SSE=1;

  always @ (posedge clk, negedge reset) begin
    if (!reset)               state <= s0;
    else
      case (state)
        s0: if (button)       state <= s7;
            else            
              if (has_e)      state <= s1;
              else            state <= s0;
        s1: if (has)          state <= s4;
            else if (!ev)     state <= s2;
            else if (!stay)   state <= s0;
            else              state <= s2;
        s2: if (has)          state <= s4;
            else              state <= s3;
        s3: if (has)          state <= s4;
            else              state <= s6;
        s4: if (can)          state <= s5;
            else if (fail)    state <= s1;
            else if (change)  state <= s1;
            else              state <= s4;
        s5:                   state <= s0;
        s6: if (give_up)      state <= s0;
            else              state <= s1;
        s7: if (!in) begin
              if (out)        state <= s0;
              else            state <= s7;
            end
            else begin
              if (!ev)        state <= s1;
              else if (!stay) state <= s1;
              else            state <= s2;
            end
      endcase
  end

  always @ (state, stay, button, has_e, in, has, ev, can, fail, change, give_up) begin
    clr <= 1'b0;
    clr_s  <= 1'b0;
    load_m <= 1'b0;
    load_b <= 1'b0;
    load_e <= 1'b0;
    s_f <= 1'b0;
    load_s <= 1'b0;
    shift <= 1'b0;
    up_d <= 1'b0;
    w2 <= 1'b0;
    w3 <= 1'b0;
      case (state)
        s0: begin
                                            clr_s <= 1'b1;
            if (button)                     load_m <= 1'b1;
            else if (has_e)                 load_b <= 1'b1;
            else                            clr  <= 1'b1;
            end
        s1: if (has)                        load_s <= 1'b1;
            else if (ev&&(!stay)) 
            begin
                                            load_e <= 1'b1;
                                            clr <= 1'b1;
            end
        s2: begin
                                            w2 <= 1'b1;
            if (has)                        load_s <= 1'b1;
            end
        s3: begin
                                            w3 <= 1'b1;
            if (has)                        load_s <= 1'b1;
            end
        s4: begin
                                            shift <= 1'b1;
            if (can)                        up_d <= 1'b1;
            end
        s5: begin
                                            up_d <= 1'b1;
                                            clr <= 1'b1;
           	end
        s6: begin
                                            s_f <= 1'b1;
            if (give_up)                    clr <= 1'b1;
            end
        s7: if ((!in)&&out)                 clr <= 1'b1;
      endcase
  end

  always @ (posedge clk, negedge reset) begin
    if (!reset)                state2 <= SS0;
    else
      case (state2)
        SS0: if (load_e)        state2 <= SSE;
             else               state2 <= SS0;
        SSE: if (slot_ev)       state2 <= SSE;
             else
               if (state==s0)   state2 <= SS0;
               else             state2 <= SSE;
      endcase
  end

  always @ (state2, load_e, slot_ev, state) begin
    has_e <= 1'b0;
    stay <= 1'b0;
    clr_e <= 1'b0;
      case (state2)
        SS0: if (!load_e)                 clr_e <= 1'b0;
        SSE: begin
                                          stay <= 1'b1;
             if ((!slot_ev)&&(state==s0)) 
               begin
               has_e <= 1'b1;
               clr_e <= 1'b1;
               end
             end
      endcase
  end
  
endmodule

module slot_datapath_new (
  output button, in, out, has, ev, can, fail, change, give_up, slot_ev,
  output reg [5:0] slot_n, slot_s,
  input [5:0] slot_b,
  input clr, clr_e, clr_s, load_m, load_b, load_e, s_f, load_s, shift, up_d, w2, w3,
  input pg, ps, pe, dg, ds, de, mod, in_b, out_b, can_b, fail_b, give_up_b, clk, reset
);

  reg [2:0] REG, REGE;
  reg [2:0] car;
  parameter pg_n=3'b001, ps_n=3'b010, pe_n=3'b011, dg_n=3'b100, ds_n=3'b101, de_n=3'b110;
  reg [2:0] priority1, priority2, priority3, priority4, priority5, priority6;
  reg [2:0] pr2, pr3, pr4, pr5, pr6;
  reg [7:0] decoder;
  reg [7:0] MUX;
  reg [1:0] car_2, car_1, car_0;
  parameter s00=2'b00, s01=2'b01, s10=2'b10, s11=2'b11;
  reg [2:0] car_in;
  reg [5:0] en;
  reg [5:0] slot_c;
  
  wire [2:0] priority;
  wire [5:0] AND;
  wire [5:0] XOR;
  wire [5:0] pg_m, ps_m, pe_m, dg_m, ds_m, de_m;
  
  assign ev = (REG==pe_n)||(REG==de_n);
  assign has = |AND;
  assign slot_ev = slot_n[5];
  assign AND = MUX&(~slot_n);
  assign button = |car_in;
  assign priority = priority1|pr2|pr3|pr4|pr5|pr6;
  assign XOR = slot_n ^ slot_c;
  assign change = |XOR;
  assign in = in_b;
  assign out = out_b;
  assign can = can_b;
  assign fail = fail_b;
  assign give_up = give_up_b;
            //       F[5]               E[4]                                    D[3]                          C[2]                       B[1]                          A[0]
  assign pg_m = {        1'b0,                   (!w2)&(!w3), ((!mod)&(!w2)&(!w3))|(mod&w2),                          1'b0,                          1'b0,                          1'b0};
  assign ps_m = {        1'b0,                   (!w2)&(!w3), ((!mod)&(!w2)&(!w3))|(mod&w2), ((!mod)&(!w2)&(!w3))|(mod&w2),                          1'b0,                          1'b0};
  assign pe_m = { (!w2)&(!w3),                            w2,                            w3,                          1'b0,                          1'b0,                          1'b0};
  assign dg_m = {        1'b0, ((!mod)&w2)|(mod&(!w2)&(!w3)),          ((!mod)&w2)|(mod&w3),                          1'b0, ((!mod)&(!w2)&(!w3))|(mod&w2), ((!mod)&(!w2)&(!w3))|(mod&w2)};
  assign ds_m = {        1'b0, ((!mod)&w2)|(mod&(!w2)&(!w3)),          ((!mod)&w2)|(mod&w3),          ((!mod)&w2)|(mod&w3), ((!mod)&(!w2)&(!w3))|(mod&w2), ((!mod)&(!w2)&(!w3))|(mod&w2)};
  assign de_m = { (!w2)&(!w3),                            w3,                            w3,                          1'b0,                            w2,                            w2};
  
  always @ (pg, ps, pe, dg, ds, de) begin
                 car <= 3'b000;
    if (pg)      car <= pg_n;
    else if (ps) car <= ps_n;
    else if (pe) car <= pe_n;
    else if (dg) car <= dg_n;
    else if (ds) car <= ds_n;
    else if (de) car <= de_n;
    else         car <= 3'b000;
  end
  
  always @ (posedge clk, negedge reset) begin
    if (!reset) car_2 <= s00;
    else
      case (car_2)
        s00: if (car[2]) car_2 <= s01;
             else        car_2 <= s00;
        s01:             car_2 <= s10;
        s10: if (car[2]) car_2 <= s11;
             else        car_2 <= s00;
        s11: if (car[2]) car_2 <= s11;
             else        car_2 <= s00; 
      endcase
  end
  always @ (car_2) begin
    if ((car_2==s01)||(car_2==s10)) car_in[2] <= 1'b1;
    else                            car_in[2] <= 1'b0;
  end
  
  always @ (posedge clk, negedge reset) begin
    if (!reset) car_1 <= s00;
    else
      case (car_1)
        s00: if (car[1]) car_1 <= s01;
             else        car_1 <= s00;
        s01:             car_1 <= s10;
        s10: if (car[1]) car_1 <= s11;
             else        car_1 <= s00;
        s11: if (car[1]) car_1 <= s11;
             else        car_1 <= s00; 
      endcase
  end
  always @ (car_1) begin
    if ((car_1==s01)||(car_1==s10)) car_in[1] <= 1'b1;
    else                            car_in[1] <= 1'b0;
  end
  
  always @ (posedge clk, negedge reset) begin
    if (!reset) car_0 <= s00;
    else
      case (car_0)
        s00: if (car[0]) car_0 <= s01;
             else        car_0 <= s00;
        s01:             car_0 <= s10;
        s10: if (car[0]) car_0 <= s11;
             else        car_0 <= s00;
        s11: if (car[0]) car_0 <= s11;
             else        car_0 <= s00; 
      endcase
  end
  always @ (car_0) begin
    if ((car_0==s01)||(car_0==s10)) car_in[0] <= 1'b1;
    else                            car_in[0] <= 1'b0;
  end
  
  always @ (posedge clk, negedge reset) begin
    if (!reset)      REG <= 3'b000;
    else if (clr)    REG <= 3'b000;
    else if (load_m) REG <= load_m | car_in;
    else if (load_b) REG <= load_b | REGE;
    else             REG <= REG;
  end
  
  always @ (posedge clk, negedge reset) begin
    if (!reset)      REGE <= 3'b000;
    else if (clr_e)  REGE <= 3'b000;   
    else if (load_e) REGE <= REG;
    else             REGE <= REGE;
  end
  
  always @ (REG, mod, w2, w3) begin
    case (REG)
      pg_n: MUX <= pg_m;
      ps_n: MUX <= ps_m;
      pe_n: MUX <= pe_m;
      dg_n: MUX <= dg_m;
      ds_n: MUX <= ds_m;
      de_n: MUX <= de_m;
      default MUX <= 6'b0;
    endcase
  end
  
  always @ (posedge clk, negedge reset) begin
    if (!reset)  en <= 6'b111_110;
    else
      if (shift) en <= {en[4:0], en[5]};
      else       en <= en;
  end

  always @ (AND, en) begin
    if (en[0])             priority1 <= 3'b000;
    else begin
         if (AND[0]==1'b1) priority1 <= 3'b001;
    else if (AND[1]==1'b1) priority1 <= 3'b010;
    else if (AND[2]==1'b1) priority1 <= 3'b011;
    else if (AND[3]==1'b1) priority1 <= 3'b100;
    else if (AND[4]==1'b1) priority1 <= 3'b101;
    else if (AND[5]==1'b1) priority1 <= 3'b110;
    end
  end
  
  always @ (AND, en) begin
    if (en[1])             priority2 <= 3'b000;
    else begin
         if (AND[1]==1'b1) priority2 <= 3'b001;
    else if (AND[2]==1'b1) priority2 <= 3'b010;
    else if (AND[3]==1'b1) priority2 <= 3'b011;
    else if (AND[4]==1'b1) priority2 <= 3'b100;
    else if (AND[5]==1'b1) priority2 <= 3'b101;
    else if (AND[0]==1'b1) priority2 <= 3'b110;
    end
  end
  
  always @ (AND, en) begin
    if (en[2])             priority3 <= 3'b000;
    else begin
         if (AND[2]==1'b1) priority3 <= 3'b001;
    else if (AND[3]==1'b1) priority3 <= 3'b010;
    else if (AND[4]==1'b1) priority3 <= 3'b011;
    else if (AND[5]==1'b1) priority3 <= 3'b100;
    else if (AND[0]==1'b1) priority3 <= 3'b101;
    else if (AND[1]==1'b1) priority3 <= 3'b110;
    end
  end
  
  always @ (AND, en) begin
    if (en[3])             priority4 <= 3'b000;
    else begin
         if (AND[3]==1'b1) priority4 <= 3'b001;
    else if (AND[4]==1'b1) priority4 <= 3'b010;
    else if (AND[5]==1'b1) priority4 <= 3'b011;
    else if (AND[0]==1'b1) priority4 <= 3'b100;
    else if (AND[1]==1'b1) priority4 <= 3'b101;
    else if (AND[2]==1'b1) priority4 <= 3'b110;
    end
  end
  
  always @ (AND, en) begin
    if (en[4])             priority5 <= 3'b000;
    else begin
         if (AND[4]==1'b1) priority5 <= 3'b001;
    else if (AND[5]==1'b1) priority5 <= 3'b010;
    else if (AND[0]==1'b1) priority5 <= 3'b011;
    else if (AND[1]==1'b1) priority5 <= 3'b100;
    else if (AND[2]==1'b1) priority5 <= 3'b101;
    else if (AND[3]==1'b1) priority5 <= 3'b110;
    end
  end
  
  always @ (AND, en) begin
    if (en[5])             priority6 <= 3'b000;
    else begin
         if (AND[5]==1'b1) priority6 <= 3'b001;
    else if (AND[0]==1'b1) priority6 <= 3'b010;
    else if (AND[1]==1'b1) priority6 <= 3'b011;
    else if (AND[2]==1'b1) priority6 <= 3'b100;
    else if (AND[3]==1'b1) priority6 <= 3'b101;
    else if (AND[4]==1'b1) priority6 <= 3'b110;
    end
  end

  always @ (priority2) begin
    case (priority2)
      3'b000: pr2 <= 3'b000;
      3'b001: pr2 <= 3'b010;
      3'b010: pr2 <= 3'b011;
      3'b011: pr2 <= 3'b100;
      3'b100: pr2 <= 3'b101;
      3'b101: pr2 <= 3'b110;
      3'b110: pr2 <= 3'b001;
    endcase
  end
  
  always @ (priority3) begin
    case (priority3)
      3'b000: pr3 <= 3'b000;
      3'b001: pr3 <= 3'b011;
      3'b010: pr3 <= 3'b100;
      3'b011: pr3 <= 3'b101;
      3'b100: pr3 <= 3'b110;
      3'b101: pr3 <= 3'b001;
      3'b110: pr3 <= 3'b010;
    endcase
  end
      
  always @ (priority4) begin
    case (priority4)
      3'b000: pr4 <= 3'b000;
      3'b001: pr4 <= 3'b100;
      3'b010: pr4 <= 3'b101;
      3'b011: pr4 <= 3'b110;
      3'b100: pr4 <= 3'b001;
      3'b101: pr4 <= 3'b010;
      3'b110: pr4 <= 3'b011;
    endcase
  end
  
  always @ (priority5) begin
    case (priority5)
      3'b000: pr5 <= 3'b000;
      3'b001: pr5 <= 3'b101;
      3'b010: pr5 <= 3'b110;
      3'b011: pr5 <= 3'b001;
      3'b100: pr5 <= 3'b010;
      3'b101: pr5 <= 3'b011;
      3'b110: pr5 <= 3'b100;
    endcase
  end
  
  always @ (priority6) begin
    case (priority6)
      3'b000: pr6 <= 3'b000;
      3'b001: pr6 <= 3'b110;
      3'b010: pr6 <= 3'b001;
      3'b011: pr6 <= 3'b010;
      3'b100: pr6 <= 3'b011;
      3'b101: pr6 <= 3'b100;
      3'b110: pr6 <= 3'b101;
    endcase
  end
  
  always @ (priority) begin
    case (priority)
      3'd0:  decoder <= 8'b0000_0001;
      3'd1:  decoder <= 8'b0000_0010;
      3'd2:  decoder <= 8'b0000_0100;
      3'd3:  decoder <= 8'b0000_1000;
      3'd4:  decoder <= 8'b0001_0000;
      3'd5:  decoder <= 8'b0010_0000;
      3'd6:  decoder <= 8'b0100_0000;
      3'd7:  decoder <= 8'b1000_0000;
    endcase
  end
  
  always @ (posedge clk, negedge reset) begin
    if (!reset)      slot_s <= 6'b000_000;
    else if (clr_s)  slot_s <= 6'b000_000;
    else if (load_s) slot_s <= decoder[6:1];
    else             slot_s <= slot_s;
  end
  
  always @ (posedge clk, negedge reset) begin
    if (!reset)      slot_c <= 6'b000_000;
    else             slot_c <= slot_n;
  end
  
  always @ (posedge clk, negedge reset) begin
    if (!reset)      slot_n <= 6'b000_000;
    else if (up_d)   slot_n <= slot_n|slot_b|slot_s;
    else             slot_n <= slot_n|slot_b;
  end
  
endmodule

module slot_top_new_tb;

  reg pg, ps, pe, dg, ds, de, mod, in_b, out_b, can_b, fail_b, give_up_b, clk, reset;
  reg [5:0] slot_b;
  wire s_f;
  wire [5:0] slot_n, slot_s;

  slot_top_new uut (
    .pg(pg), 
    .ps(ps), 
    .pe(pe), 
    .dg(dg), 
    .ds(ds), 
    .de(de), 
    .mod(mod), 
    .in_b(in_b), 
    .out_b(out_b), 
    .can_b(can_b), 
    .fail_b(fail_b), 
    .give_up_b(give_up_b), 
    .clk(clk), 
    .reset(reset),
    .slot_b(slot_b),
    .s_f(s_f),
    .slot_n(slot_n), 
    .slot_s(slot_s)
  );

  always begin
    #5 clk = ~clk;
  end

  initial begin
    clk = 1;
    reset = 1;
    pg = 0;
    ps = 0;
    pe = 0;
    dg = 0;
    ds = 0;
    de = 0;
    mod = 0;
    in_b = 0;
    out_b = 0;
    can_b = 0;
    fail_b = 0;
    give_up_b = 0;
    slot_b = 6'b000_000;
    #10 reset = 0;
    #30 reset = 1;
    #10 slot_b = 6'b010_001;
    #20 slot_b = 6'b000_000;
    #18 pg = 1;
    #22 pg = 0;
    #10 in_b = 1;
    #20 can_b = 1;
  end
endmodule