`timescale 1ps/1ps

module tb_assert;
  logic clock, reset;
  logic scram_en;
  logic scram_rst;
  logic read;
  logic write;

logic clk_out1s;
logic clk_out2s;
logic [16-1:0] out_LFSR;
  logic [4:0] wraddr;
  logic [4:0] rdaddr;
  logic [6:0] HEX_D[6];
  logic fifofull;
  logic empty;

  top_lab3 dut (
	.CLOCK_50(clock), 
  	.SW0({read}),
  	.SW1({write}),
  	.SW2({scram_en}),
//  	.SW3(SW[3]),
// 	.SW4(SW[4]),
//  	.SW5(SW[5]),
//  	.SW6(SW[6]),
//  	.SW7(SW[7]),
//  	.SW8(SW[8]),
//  	.SW9(SW[9]),
  	.KEY0({reset}),
  	.KEY1({scram_rst}),
//  	.KEY2(KEY[2]),
//  	.KEY3(KEY[3]),
	.wraddr(wraddr),
	.rdaddr(rdaddr),
	.clk_out1s(clk_out1s),
	.clk_out2s(clk_out2s),
	.out_LFSR(out_LFSR),
  	.HEX5(HEX_D[5]), 
  	.HEX4(HEX_D[4]), 
  	.HEX3(HEX_D[3]),
  	.HEX2(HEX_D[2]), 
  	.HEX1(HEX_D[1]), 
  	.HEX0(HEX_D[0]),
  	.LED0(fifofull),
  	.LED1(empty)
//  	.LED2(LED_D[2]),
//  	.LED3(LED_D[3]),
//  	.LED4(LED_D[4]),
//  	.LED5(LED_D[5]),
//  	.LED6(LED_D[6]),
//  	.LED7(LED_D[7]),
// 	.LED8(LED_D[8]),
//  	.LED9(LED_D[9])
  );

property rst_start;
  @(posedge clock) !reset |-> ##1 (wraddr == 0 && rdaddr == 0 && empty == 1);
endproperty

property rst;
  @(negedge reset) 1'b1  |-> ##1 @(posedge clock) (wraddr == 0 && rdaddr == 0 && empty == 1);
endproperty

property dont_write_if_full;
	@(posedge clk_out2s) disable iff(!reset) (write && fifofull) |-> ##1 wraddr == $past(wraddr);
endproperty

property dont_read_if_empty;
	@(posedge clk_out1s) disable iff(!reset) (read && empty) |-> ##1 rdaddr == $past(rdaddr);
endproperty

property write_incr;
	@(posedge clk_out2s) disable iff(!reset) (write && !fifofull) |-> ##1 wraddr-1'b1 == $past(wraddr);
endproperty

property read_incr;
	@(posedge clk_out1s) disable iff(!reset) (read && !empty) |-> ##1 rdaddr-1'b1 == $past(rdaddr);
endproperty

property LFSR_en;
  @(posedge clock) disable iff(!reset) (!scram_en) |-> ##5 out_LFSR == 16'h0001;
endproperty

property LFSR_rst;
  @(posedge clock) disable iff(!reset) (!scram_rst) |-> ##5 out_LFSR == 16'h760C;
endproperty

property LFSR;
  @(posedge clock) disable iff(!reset) (scram_en) |-> ##5 out_LFSR != $past(out_LFSR);
endproperty

property dont_write_if_full_v2;
  @(posedge clk_out2s) disable iff(!reset) (write && fifofull) |-> ##1 wraddr == rdaddr - 1'b1;
endproperty

  initial begin
    clock = 1'b0;
    forever #5 clock = ~clock;
  end

  initial begin
// rst
    reset <= 1'b0;
    scram_en <= 1'b0;
    scram_rst <= 1'b0;
    read <= 1'b0;
    write <= 1'b0;

    #20;
// dont_read_if_empty
    reset <= 1'b1;
    scram_en <= 1'b1;
    scram_rst <= 1'b1;
    read <= 1'b1;
    write <= 1'b0;

    #100;
// write_incr
    reset <= 1'b1;
    scram_en <= 1'b1;
    scram_rst <= 1'b1;
    read <= 1'b0;
    write <= 1'b1;
// dont_write_if_full

    #1500;
// read_incr
    reset <= 1'b1;
    scram_en <= 1'b1;
    scram_rst <= 1'b1;
    read <= 1'b1;
    write <= 1'b0;

    #1500;
//rst
    reset <= 1'b0;
    scram_en <= 1'b0;
    scram_rst <= 1'b0;
    read <= 1'b0;
    write <= 1'b0;
 
    #100;
//check LFSR enable
    reset <= 1'b1;
    scram_en <= 1'b0;
    scram_rst <= 1'b1;
    read <= 1'b0;
    write <= 1'b0;

    #100;
//check LFSR enable
    reset <= 1'b1;
    scram_en <= 1'b1;
    scram_rst <= 1'b0;
    read <= 1'b0;
    write <= 1'b0;


    #100;
    reset <= 1'b0;
    scram_en <= 1'b0;
    scram_rst <= 1'b0;
    read <= 1'b0;
    write <= 1'b0;
    #100;
    reset <= 1'b1;
    scram_en <= 1'b1;
    scram_rst <= 1'b1;
    read <= 1'b0;
    write <= 1'b1;
    #1500;
    reset <= 1'b1;
    scram_en <= 1'b1;
    scram_rst <= 1'b1;
    read <= 1'b1;
    write <= 1'b0;
    #600;
    reset <= 1'b1;
    scram_en <= 1'b1;
    scram_rst <= 1'b1;
    read <= 1'b0;
    write <= 1'b1;
    #1500;
    reset <= 1'b0;
    scram_en <= 1'b0;
    scram_rst <= 1'b0;
    read <= 1'b0;
    write <= 1'b0;

    end

initial begin
assert property(rst_start) $display ("Test case 1, OK");
 else $error("Test case 1, wrong");
#20;
assert property(dont_read_if_empty) $display ("Test case 4, OK");
 else $error("Test case 4, wrong");
#200;
assert property(write_incr) $display ("Test case 5, OK");
 else $error("Test case 5, wrong");
#100;
assert property(LFSR) $display ("Test case 9, OK");
 else $error("Test case 9, wrong");
#1300;   
assert property(dont_write_if_full) $display ("Test case 3, OK");
 else $error("Test case 3, wrong");
#500;
assert property(read_incr) $display ("Test case 6, OK");
 else $error("Test case 6, wrong");  
assert property(rst) $display ("Test case 2, OK");
 else $error("Test case 2, wrong");
#1000;
assert property(LFSR_en) $display ("Test case 7, OK");
 else $error("Test case 7, wrong"); 
#200;
assert property(LFSR_rst) $display ("Test case 8, OK");
 else $error("Test case 8, wrong"); 
#3500;
assert property(dont_write_if_full_v2) $display ("Test case 10, OK");
 else $error("Test case 10, wrong"); 
end
endmodule
