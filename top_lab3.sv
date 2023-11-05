module top_lab3
  (input  logic       CLOCK_50,
   input  logic       KEY0, KEY1,/* KEY2, KEY3,*/
   input  logic       SW0, SW1, SW2, /*SW3, SW4, SW5, SW6, SW7, SW8, SW9,*/
	output logic 		 LED0, LED1,/* LED2, LED3, LED4, LED5, LED6, LED7, LED8, LED9,*/
	output logic [5-1:0] wraddr, rdaddr,
	output logic clk_out1s, clk_out2s,
	output logic [16-1:0] out_LFSR,
   output logic [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0
	);
//rst == KEY0
//fiford == SW8 SW0
//fifowr == SW9 SW1
//scram_en == SW2
//scram_rst == KEY1
//clk == key3

//LED0 == fifofull
//LED1 == empty

//logic clk_out1s;
//logic clk_out2s;
logic [16-1:0] in_LFSR;
//logic [16-1:0] out_LFSR;
logic write;
//logic [5-1:0] wraddr;
logic read;
//logic [5-1:0] rdaddr;
logic [23:0]  q_a;
logic [23:0]  q_b;
logic [5-1:0] rdaddr_reg;
assign in_LFSR = 16'd1;
 
//CLK_create  #(.freq(25000000)) CLK_create_1sec (.clk(CLOCK_50), .rst_n(KEY0), .clk_out(clk_out1s));	
//CLK_create  #(.freq(50000000)) CLK_create_2sec (.clk(CLOCK_50), .rst_n(KEY0), .clk_out(clk_out2s));
CLK_create  #(.freq(1)) CLK_create_1sec (.clk(CLOCK_50), .rst_n(KEY0), .clk_out(clk_out1s));	
CLK_create  #(.freq(2)) CLK_create_2sec (.clk(CLOCK_50), .rst_n(KEY0), .clk_out(clk_out2s));

scrambler LFSR_0 (.clk(CLOCK_50), 
						.rst_n(KEY0), 
						.scram_en(SW2),
						.scram_rst(KEY1),
						.in(in_LFSR),
						.out(out_LFSR)
						);
						
fifoctrl fifoctrl_0 (
							.clkw(clk_out2s),
							.clkr(clk_out1s),
							.rst_n(KEY0),
							.fiford(SW0),
							.fifowr(SW1),
							.fifofull(LED0),
							.empty(LED1),
//							.fifolen(fifolen),
							.write(write),
							.wraddr(wraddr),
							.read(read),
							.rdaddr(rdaddr)
							);
							
RAM RAM_0 (
			.address_a(wraddr),
			.address_b(rdaddr),
			.clock_a(clk_out2s),
			.clock_b(clk_out1s),
			.data_a({8'd0,out_LFSR}),
			.data_b({8'd0,out_LFSR}),
			.rden_a(),
			.rden_b(read),
			.wren_a(write),
			.wren_b(),
			.aclr_a(!KEY0),
			.aclr_b(!KEY0),
			.q_a(q_a),
			.q_b(q_b)
			);
			
always @(posedge clk_out1s, negedge KEY0) begin
	if (!KEY0) begin
		rdaddr_reg <= 'd0;
	end
	else begin
		rdaddr_reg <= rdaddr;
	end
end

bcdtohex bcdtohex_0 (.bcd(wraddr[3:0]), .segment(HEX0));
bcdtohex bcdtohex_1 (.bcd({3'b000,wraddr[4]}), .segment(HEX1));
bcdtohex bcdtohex_2 (.bcd(rdaddr_reg[3:0]), .segment(HEX2));
bcdtohex bcdtohex_3 (.bcd({3'b000,rdaddr_reg[4]}), .segment(HEX3));
bcdtohex bcdtohex_4 (.bcd(q_b[3:0]), .segment(HEX4));
bcdtohex bcdtohex_5 (.bcd(q_b[7:4]), .segment(HEX5));			
endmodule	
	