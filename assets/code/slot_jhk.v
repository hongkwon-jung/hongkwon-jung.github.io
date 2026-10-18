module slot_top (
  input clk,
  input reset,
  input pg,
  input ps,
  input pe,
  input dg,
  input ds,
  input de,
  input mod,
  input [9:0] slot_b,
  
  output s_f,
  output s_d,
  output [9:0] slot_n
);
  wire load_1, load_2_1, load_2_e, load_3, load_e, c_u, s_e, en_1, en_2, en_3; // control signals
  wire enter_ok, ev, has_1, has_2, has_3, has_e, button, t_d; // status signals
  
  slot_controller controller (
    .load_1(load_1),
    .load_2_1(load_2_1),
    .load_2_e(load_2_e),
    .load_3(load_3),
    .load_e(load_e),
    .c_u(c_u),
    .s_e(s_e),
    .s_f(s_f),
    .s_d(s_d),
    .en_1(en_1),
    .en_2(en_2),
    .en_3(en_3),
    .enter_ok(enter_ok),
    .ev(ev),
    .has_1(has_1),
    .has_2(has_2),
    .has_3(has_3),
    .has_e(has_e),
    .t_d(t_d),
    .button(button),
    .clk(clk),
    .reset(reset)
  );
  
  slot_datapath datapath (
    .enter_ok(enter_ok),
    .ev(ev),
    .has_1(has_1),
    .has_2(has_2),
    .has_3(has_3),
    .has_e(has_e),
    .button(button),
    .t_d(t_d),
    .slot_n(slot_n),
    .slot_b(slot_b),
    .load_1(load_1),
    .load_2_1(load_2_1),
    .load_2_e(load_2_e),
    .load_3(load_3),
    .load_e(load_e),
    .c_u(c_u),
    .s_e(s_e),
    .s_f(s_f),
    .s_d(s_d),
    .en_1(en_1),
    .en_2(en_2),
    .en_3(en_3),
    .clk(clk),
    .reset(reset),
    .pg(pg),
    .ps(ps),
    .pe(pe),
    .dg(dg),
    .ds(ds),
    .de(de),
    .mod(mod)
  );
  
endmodule

module slot_controller (
 output reg load_1, load_2_1, load_2_e, load_3, load_e, c_u, s_e, s_f, s_d, en_1, en_2, en_3,
 input enter_ok, ev, has_1, has_2, has_3, has_e, t_d, button, clk, reset
);

  reg s0, s1, s2, s3, s4, s5, s6, s7;

  always @ (posedge clk, negedge reset) begin
    s0 <= 1'b0;
    s1 <= 1'b0;
    s2 <= 1'b0;
    s3 <= 1'b0;
    s4 <= 1'b0;
    s5 <= 1'b0;
   	s6 <= 1'b0;
    s7 <= 1'b0;
    if (!reset) begin
      s0 <= 1'b0;
      s1 <= 1'b0;
      s2 <= 1'b0;
      s3 <= 1'b0;
      s4 <= 1'b0;
     	s5 <= 1'b0;
     	s6 <= 1'b0;
      s7 <= 1'b0;
    end
    else begin
      begin
        if (button)                                    s0 <= 1'b1; // new
      end 
      begin
        if (s0)
        begin
          if (enter_ok)                                s1 <= 1'b1;
          else                                         s7 <= 1'b1;
        end
      end
      begin 
        if (s1) 
     	  begin
          if (has_1)                                   s6 <= 1'b1;
          if (((~ev)&&(~has_1))||((ev&&(~has_1)&&s4))) s2 <= 1'b1;
          if (ev&&(~has_1)&&(~s4))                     s4 <= 1'b1;
        end
      end
      begin
        if (s2)
        begin
          if (has_2)                                   s6 <= 1'b1;
      	  	if (~has_2)                                  s3 <= 1'b1;
        end
     	end
      begin
        if (s3)
        begin
          if (has_3)                                   s6 <= 1'b1;
      	  	if (~has_3)                                  s7 <= 1'b1;
        end
      end
      begin
        if (s4)
        begin
          if (t_d)                                     s5 <= 1'b1;
       	  if (~t_d)                                    s4 <= 1'b1;
        end
   	  end
      begin
        if (s5)
        begin
          if (has_e)                                   s6 <= 1'b1;
       	  if (~has_e)                                  s2 <= 1'b1;
        end
      end
    end
  end

  always @ (s0, s1, s2, s3, s4, s5, s6, s7, button, enter_ok, ev, has_1, has_2, has_3, has_e) begin
    load_1 <= 1'b0; 
    load_2_1 <= 1'b0;
    load_2_e <= 1'b0;
    load_3 <= 1'b0;
    load_e <= 1'b0;
    c_u <= 1'b0;
    s_e <= 1'b0; // new
    s_f <= 1'b0;
    s_d <= 1'b0;
    if (button)                                load_1 <= 1'b1;
    if (s1&&(~ev)&&(~has_1))                   load_2_1 <= 1'b1; // new load_2
    if (s5&&(~has_e))                          load_2_e <= 1'b1;
    if (s2&&(~has_2))                          load_3 <= 1'b1;
    if (s1&&ev&&(~has_1))                      load_e <= 1'b1;
   	if (s4)                                    c_u <= 1'b1;
    if (s5)                                    s_e <= 1'b1;
    if (s6)                                    s_d <= 1'b1;
    if (s7)                                    s_f <= 1'b1;
  end

  always @ (s1, s2, s3) begin
    en_1 <= 1'b0;
    en_2 <= 1'b0;
    en_3 <= 1'b0;
    if (s1) en_1 <= 1'b1;
    if (s2) en_2 <= 1'b1;
    if (s3) en_3 <= 1'b1;
  end

endmodule

module slot_datapath (
  output enter_ok, ev, has_1, has_2, has_3, has_e, button,
  output reg t_d,
  output reg [9:0] slot_n,
  input [9:0] slot_b,
  input load_1, load_2_1, load_2_e, load_3, load_e, c_u, s_e, s_f, s_d, en_1, en_2, en_3, clk, reset,
  input pg, ps, pe, dg, ds, de, mod
);

  reg [2:0] REG1, REG2, REG3, REGE;
  reg [2:0] car;
  parameter pg_n=3'b001, ps_n=3'b010, pe_n=3'b011, dg_n=3'b100, ds_n=3'b101, de_n=3'b110;
  reg [3:0] priority1, priority2, priority3;
  reg [15:0] decoder1, decoder2, decoder3;
  reg [9:0] MUX1, MUX2, MUX3;
  reg [3:0] counter;
  reg [1:0] car_2, car_1, car_0;
  parameter s00=2'b00, s01=2'b01, s10=2'b10;
  reg [2:0] car_in;
  
  wire slot_7, slot_9; //new
  wire [9:0] pg_1, pg_2, pg_3, ps_1, ps_2, ps_3, pe_1, pe_2, pe_3, dg_1, dg_2, dg_3, ds_1, ds_2, ds_3, de_1, de_2, de_3;
  wire [9:0] AND1, AND2, AND3;
  
  wire g_0 = (!slot_n[1])||(!slot_n[3])||(!slot_n[5])||(!slot_n[6])||(!slot_n[8]);
  wire s_0 = (!slot_n[4]);
  wire d_0 = (!slot_n[0])||(!slot_n[2]);
  
  assign ev = (REG1==pe_n)||(REG1==de_n);
  assign enter_ok = ((REG1==pg_n)&&g_0)||((REG1==ps_n)&&(g_0||s_0))||((REG1==dg_n)&&(g_0||d_0))||((REG1==ds_n)&&(g_0||d_0||s_0))||(REG1==pe_n)||(REG1==de_n);
  
  assign has_1 = |AND1;
  assign has_2 = |AND2;
  assign has_3 = |AND3;
  assign has_e = slot_7||slot_9;
  
  assign AND1=MUX1&(~slot_n);
  assign AND2=MUX2&(~slot_n);
  assign AND3=MUX3&(~slot_n);
  
  assign slot_7 = s_e&&(!slot_n[7]);
  assign slot_9 = s_e&&(!slot_n[9]);
  
  assign button = |car_in;
  
  //              j[9]  i[8]  h[7]  g[6]  f[5]  e[4]  d[3]  c[2]  b[1]  a[0]
  assign pg_1 = { 1'b0, 1'b1, 1'b0, 1'b1, ~mod, 1'b0, ~mod, 1'b0, ~mod, 1'b0 };
  assign pg_2 = { 1'b0, 1'b0, 1'b0, 1'b0,  mod, 1'b0,  mod, 1'b0,  mod, 1'b0 };
  assign pg_3 = { 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0 };

  assign ps_1 = { 1'b0, 1'b1, 1'b0, 1'b1, ~mod, 1'b0, ~mod, ~mod, ~mod, 1'b0 };
  assign ps_2 = { 1'b0, 1'b0, 1'b0, 1'b0,  mod, 1'b0,  mod,  mod,  mod, 1'b0 };
  assign ps_3 = { 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0 };

  assign pe_1 = { 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0 };
  assign pe_2 = { 1'b0, 1'b1, 1'b0, 1'b1, ~mod, 1'b0, ~mod, 1'b0, ~mod, 1'b0 };
  assign pe_3 = { 1'b0, 1'b0, 1'b0, 1'b0,  mod, 1'b0,  mod, 1'b0,  mod, 1'b0 };

  assign dg_1 = { 1'b0,  mod, 1'b0,  mod, 1'b0, 1'b0, 1'b0, ~mod, 1'b0, ~mod };
  assign dg_2 = { 1'b0, ~mod, 1'b0, ~mod, ~mod, 1'b0, ~mod,  mod, ~mod,  mod };
  assign dg_3 = { 1'b0, 1'b0, 1'b0, 1'b0,  mod, 1'b0,  mod, 1'b0,  mod, 1'b0 };

  assign ds_1 = { 1'b0,  mod, 1'b0,  mod, 1'b0, 1'b0, 1'b0, ~mod, 1'b0, ~mod };
  assign ds_2 = { 1'b0, ~mod, 1'b0, ~mod, ~mod, ~mod, ~mod,  mod, ~mod,  mod };
  assign ds_3 = { 1'b0, 1'b0, 1'b0, 1'b0,  mod, 1'b0,  mod, 1'b0,  mod, 1'b0 };

  assign de_1 = { 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0 };
  assign de_2 = { 1'b0,  mod, 1'b0,  mod, 1'b0, 1'b0, 1'b0, ~mod, 1'b0, ~mod };
  assign de_3 = { 1'b0, ~mod, 1'b0, ~mod, 1'b1, 1'b0, 1'b1,  mod, 1'b1,  mod };


  
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
        s01: if (car[2]) car_2 <= s10;
             else        car_2 <= s00;
        s10: if (car[2]) car_2 <= s10;
             else        car_2 <= s00;
      endcase
  end
  always @ (car_2) begin
    if (car_2==s01) car_in[2] <= 1'b1;
    else            car_in[2] <= 1'b0;
  end
  
  always @ (posedge clk, negedge reset) begin
    if (!reset) car_1 <= s00;
    else
      case (car_1)
        s00: if (car[1]) car_1 <= s01;
             else        car_1 <= s00;
        s01: if (car[1]) car_1 <= s10;
             else        car_1 <= s00;
        s10: if (car[1]) car_1 <= s10;
             else        car_1 <= s00;
      endcase
  end
  always @ (car_1) begin
    if (car_1==s01) car_in[1] <= 1'b1;
    else            car_in[1] <= 1'b0;
  end
  
  always @ (posedge clk, negedge reset) begin
    if (!reset) car_0 <= s00;
    else
      case (car_0)
        s00: if (car[0]) car_0 <= s01;
             else        car_0 <= s00;
        s01: if (car[0]) car_0 <= s10;
             else        car_0 <= s00;
        s10: if (car[0]) car_0 <= s10;
             else        car_0 <= s00;
      endcase
  end
  always @ (car_0) begin
    if (car_0==s01) car_in[0] <= 1'b1;
    else            car_in[0] <= 1'b0;
  end
  
  always @ (posedge clk, negedge reset) begin
    if (!reset) 
      begin
      REG1<=3'b000;
      REG2<=3'b000;
      REG3<=3'b000;
      REGE<=3'b000;
      end
    else 
    begin
      begin 
        if (load_1)     REG1 <= car_in;
        else            REG1 <= REG1;
      end
      begin
        if (load_e)     REGE <= REG1;
        else            REGE <= REGE;
      end
      begin
        if (load_2_1)   REG2 <= REG1;
        else         
          if (load_2_e) REG2 <= REGE;
          else          REG2 <= REG2;
      end
      begin
        if (load_3)     REG3 <= REG2;
        else            REG3 <= REG3;
      end
    end
  end
  
  always @ (REG1, pg_1, ps_1, pe_1, dg_1, ds_1, de_1) begin
    case (REG1)
      pg_n: MUX1 <= pg_1;
      ps_n: MUX1 <= ps_1;
      pe_n: MUX1 <= pe_1;
      dg_n: MUX1 <= dg_1;
      ds_n: MUX1 <= ds_1;
      de_n: MUX1 <= de_1;
      default MUX1 <= 10'b0;
    endcase
  end
  
  always @ (REG2, pg_2, ps_2, pe_2, dg_2, ds_2, de_2) begin
    case (REG2)
      pg_n: MUX2 <= pg_2;
      ps_n: MUX2 <= ps_2;
      pe_n: MUX2 <= pe_2;
      dg_n: MUX2 <= dg_2;
      ds_n: MUX2 <= ds_2;
      de_n: MUX2 <= de_2;
      default MUX2 <= 10'b0;
    endcase
  end
  
  always @ (REG3, pg_3, ps_3, pe_3, dg_3, ds_3, de_3) begin
    case (REG3)
      pg_n: MUX3 <= pg_3;
      ps_n: MUX3 <= ps_3;
      pe_n: MUX3 <= pe_3;
      dg_n: MUX3 <= dg_3;
      ds_n: MUX3 <= ds_3;
      de_n: MUX3 <= de_3;
      default MUX3 <= 10'b0;
    endcase
  end

  always @ (AND1) begin
    priority1 <= 4'b1111;
    if (AND1[0]==1'b1)      priority1 <= 4'b0000;
    else if (AND1[1]==1'b1) priority1 <= 4'b0001;
    else if (AND1[2]==1'b1) priority1 <= 4'b0010;
    else if (AND1[3]==1'b1) priority1 <= 4'b0011;
    else if (AND1[4]==1'b1) priority1 <= 4'b0100;
    else if (AND1[5]==1'b1) priority1 <= 4'b0101;
    else if (AND1[6]==1'b1) priority1 <= 4'b0110;
    else if (AND1[7]==1'b1) priority1 <= 4'b0111;
    else if (AND1[8]==1'b1) priority1 <= 4'b1000;
    else if (AND1[9]==1'b1) priority1 <= 4'b1001;
  end
  
  always @ (AND2) begin
    priority2 <= 4'b1111;
    if (AND2[0]==1'b1)      priority2 <= 4'b0000;
    else if (AND2[1]==1'b1) priority2 <= 4'b0001;
    else if (AND2[2]==1'b1) priority2 <= 4'b0010;
    else if (AND2[3]==1'b1) priority2 <= 4'b0011;
    else if (AND2[4]==1'b1) priority2 <= 4'b0100;
    else if (AND2[5]==1'b1) priority2 <= 4'b0101;
    else if (AND2[6]==1'b1) priority2 <= 4'b0110;
    else if (AND2[7]==1'b1) priority2 <= 4'b0111;
    else if (AND2[8]==1'b1) priority2 <= 4'b1000;
    else if (AND2[9]==1'b1) priority2 <= 4'b1001;
  end
  
  always @ (AND3) begin
    priority3 <= 4'b1111;
    if (AND3[0]==1'b1)      priority3 <= 4'b0000;
    else if (AND3[1]==1'b1) priority3 <= 4'b0001;
    else if (AND3[2]==1'b1) priority3 <= 4'b0010;
    else if (AND3[3]==1'b1) priority3 <= 4'b0011;
    else if (AND3[4]==1'b1) priority3 <= 4'b0100;
    else if (AND3[5]==1'b1) priority3 <= 4'b0101;
    else if (AND3[6]==1'b1) priority3 <= 4'b0110;
    else if (AND3[7]==1'b1) priority3 <= 4'b0111;
    else if (AND3[8]==1'b1) priority3 <= 4'b1000;
    else if (AND3[9]==1'b1) priority3 <= 4'b1001;
  end

  always @ (priority1, en_1) begin
    if (en_1) begin
        case (priority1)
            4'd0:  decoder1 <= 16'b0000000000000001;
            4'd1:  decoder1 <= 16'b0000000000000010;
            4'd2:  decoder1 <= 16'b0000000000000100;
            4'd3:  decoder1 <= 16'b0000000000001000;
            4'd4:  decoder1 <= 16'b0000000000010000;
            4'd5:  decoder1 <= 16'b0000000000100000;
            4'd6:  decoder1 <= 16'b0000000001000000;
            4'd7:  decoder1 <= 16'b0000000010000000;
            4'd8:  decoder1 <= 16'b0000000100000000;
            4'd9:  decoder1 <= 16'b0000001000000000;
            4'd10: decoder1 <= 16'b0000010000000000;
            4'd11: decoder1 <= 16'b0000100000000000;
            4'd12: decoder1 <= 16'b0001000000000000;
            4'd13: decoder1 <= 16'b0010000000000000;
            4'd14: decoder1 <= 16'b0100000000000000;
            4'd15: decoder1 <= 16'b1000000000000000;
        endcase
    end
    else           decoder1 <= 16'b0;
  end
  
  always @ (priority2, en_2) begin
    if (en_2) begin
        case (priority2)
            4'd0:  decoder2 <= 16'b0000000000000001;
            4'd1:  decoder2 <= 16'b0000000000000010;
            4'd2:  decoder2 <= 16'b0000000000000100;
            4'd3:  decoder2 <= 16'b0000000000001000;
            4'd4:  decoder2 <= 16'b0000000000010000;
            4'd5:  decoder2 <= 16'b0000000000100000;
            4'd6:  decoder2 <= 16'b0000000001000000;
            4'd7:  decoder2 <= 16'b0000000010000000;
            4'd8:  decoder2 <= 16'b0000000100000000;
            4'd9:  decoder2 <= 16'b0000001000000000;
            4'd10: decoder2 <= 16'b0000010000000000;
            4'd11: decoder2 <= 16'b0000100000000000;
            4'd12: decoder2 <= 16'b0001000000000000;
            4'd13: decoder2 <= 16'b0010000000000000;
            4'd14: decoder2 <= 16'b0100000000000000;
            4'd15: decoder2 <= 16'b1000000000000000;
        endcase
    end
    else           decoder2 <= 16'b0;
  end
  
  always @ (priority3, en_3) begin
    if (en_3) begin
        case (priority3)
            4'd0:  decoder3 <= 16'b0000000000000001;
            4'd1:  decoder3 <= 16'b0000000000000010;
            4'd2:  decoder3 <= 16'b0000000000000100;
            4'd3:  decoder3 <= 16'b0000000000001000;
            4'd4:  decoder3 <= 16'b0000000000010000;
            4'd5:  decoder3 <= 16'b0000000000100000;
            4'd6:  decoder3 <= 16'b0000000001000000;
            4'd7:  decoder3 <= 16'b0000000010000000;
            4'd8:  decoder3 <= 16'b0000000100000000;
            4'd9:  decoder3 <= 16'b0000001000000000;
            4'd10: decoder3 <= 16'b0000010000000000;
            4'd11: decoder3 <= 16'b0000100000000000;
            4'd12: decoder3 <= 16'b0001000000000000;
            4'd13: decoder3 <= 16'b0010000000000000;
            4'd14: decoder3 <= 16'b0100000000000000;
            4'd15: decoder3 <= 16'b1000000000000000;
        endcase
    end
    else           decoder3 <= 16'b0;
  end
  
  always @ (posedge clk, negedge reset) begin
    if (!reset) 
      slot_n <= 10'b0;
    else begin
      slot_n[6:0] <= slot_b[6:0] | slot_n[6:0] | decoder1[6:0] | decoder2[6:0] | decoder3[6:0];
      slot_n[7]   <= slot_b[7]   | slot_n[7]   | decoder1[7]   | decoder2[7]   | decoder3[7]  | slot_7;
      slot_n[8]   <= slot_b[8]   | slot_n[8]   | decoder1[8]   | decoder2[8]   | decoder3[8];
      slot_n[9]   <= slot_b[9]   | slot_n[9]   | decoder1[9]   | decoder2[9]   | decoder3[9]  | slot_9;
    end
  end
  
  always @ (posedge clk, negedge reset) begin
    if (!reset) counter <= 4'b0;
    else if (c_u) counter <= counter + 1'b1;
    else          counter <= 4'b0;
  end
  
  always @ (counter) begin
    if (counter==4'b0100) t_d <= 1'b1;
    else                  t_d <= 1'b0;
  end
  
endmodule

module slot_top_tb;

  reg clk;
  reg reset;
  reg pg, ps, pe, dg, ds, de, mod;
  reg [9:0] slot_b;
  wire s_f, s_d;
  wire [9:0] slot_n;

  slot_top uut (
    .clk(clk),
    .reset(reset),
    .pg(pg),
    .ps(ps),
    .pe(pe),
    .dg(dg),
    .ds(ds),
    .de(de),
    .mod(mod),
    .slot_b(slot_b),
    .s_f(s_f),
    .s_d(s_d),
    .slot_n(slot_n)
  );

  always begin
    #5 clk = ~clk;
  end

  initial begin
    clk = 1;
    reset = 0;
    pg = 0;
    ps = 0;
    pe = 0;
    dg = 0;
    ds = 0;
    de = 0;
    mod = 0;
    slot_b = 10'b00000_00000;
    #20 reset = 1;
    #10 slot_b = 10'b10010_10001;
    #20 slot_b = 10'b00000_00000;
    #18 pg = 1;
    #22 pg = 0;
    #30 mod = 1;
    #10 ps = 1;
    #10 ps = 0;
    #10 pe = 1;
    #15 pe = 0;
    #10 de = 1;
    #15 de = 0;
    #10 ds = 1;
    #15 ds = 0;
    #10 de = 1;
    #15 de = 0;
    #10 dg = 1;
    #15 dg = 0;
    #10 pg = 1;
    #15 pg = 0;
    #10 pg = 1;
    #15 pg = 0;
  end
endmodule