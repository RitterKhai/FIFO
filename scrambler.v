module scrambler #(parameter WIDTH = 16) (
   input  wire clk,
   input  wire rst_n,
   input  wire scram_en,
	input  wire scram_rst,
   input  wire [WIDTH-1:0] in,

   output reg  [WIDTH-1:0] out
);

   reg scram_en_reg;
   reg scram_rst_reg;
	
   wire [WIDTH-1:0] LSFR_out;

   reg [WIDTH-1:0] out_reg;
   reg [WIDTH-1:0] in_reg;

	always @(posedge clk, negedge rst_n) begin
		if (!rst_n) begin
			in_reg <= 'd0;
			scram_rst_reg <= 'd0;
			scram_en_reg <= 'd0;
		end
		else begin
			in_reg <= in;
			scram_rst_reg <= scram_rst;
			scram_en_reg <= scram_en;
		end
	end
					  
   LSFR u_LFSR_0 (
                 .clk(clk),
                 .rst_n(rst_n),
                 .scram_rst_reg(scram_rst_reg),
                 .scram_en_reg(scram_en_reg),
                 .LSFR_out(LSFR_out)
                 );
  always @(*) begin
      if (!scram_en_reg) begin
         out_reg = in_reg;
      end
      else begin
         out_reg[0]  = in_reg[0]  ^ LSFR_out[15];
         out_reg[1]  = in_reg[1]  ^ LSFR_out[15] ^ LSFR_out[14];
         out_reg[2]  = in_reg[2]  ^ LSFR_out[15] ^ LSFR_out[14] ^ LSFR_out[13];
         out_reg[3]  = in_reg[3]  ^ LSFR_out[14] ^ LSFR_out[13] ^ LSFR_out[12];
         out_reg[4]  = in_reg[4]  ^ LSFR_out[15] ^ LSFR_out[13] ^ LSFR_out[12] ^ LSFR_out[11];
         out_reg[5]  = in_reg[5]  ^ LSFR_out[14] ^ LSFR_out[12] ^ LSFR_out[11] ^ LSFR_out[10];
         out_reg[6]  = in_reg[6]  ^ LSFR_out[13] ^ LSFR_out[11] ^ LSFR_out[10] ^ LSFR_out[9];
         out_reg[7]  = in_reg[7]  ^ LSFR_out[15] ^ LSFR_out[12] ^ LSFR_out[11] ^ LSFR_out[10] ^ LSFR_out[9]  ^ LSFR_out[8];
         out_reg[8]  = in_reg[8]  ^ LSFR_out[15] ^ LSFR_out[14] ^ LSFR_out[11] ^ LSFR_out[9]  ^ LSFR_out[8]  ^ LSFR_out[7];
         out_reg[9]  = in_reg[9]  ^ LSFR_out[15] ^ LSFR_out[14] ^ LSFR_out[13] ^ LSFR_out[10] ^ LSFR_out[8]  ^ LSFR_out[7] ^ LSFR_out[6];
         out_reg[10] = in_reg[10] ^ LSFR_out[14] ^ LSFR_out[13] ^ LSFR_out[12] ^ LSFR_out[9]  ^ LSFR_out[7]  ^ LSFR_out[6] ^ LSFR_out[5];
         out_reg[11] = in_reg[11] ^ LSFR_out[15] ^ LSFR_out[13] ^ LSFR_out[12] ^ LSFR_out[11] ^ LSFR_out[8]  ^ LSFR_out[6] ^ LSFR_out[5] ^ LSFR_out[4];
         out_reg[12] = in_reg[12] ^ LSFR_out[15] ^ LSFR_out[14] ^ LSFR_out[12] ^ LSFR_out[11] ^ LSFR_out[10] ^ LSFR_out[7] ^ LSFR_out[5] ^ LSFR_out[4] ^ LSFR_out[3];
         out_reg[13] = in_reg[13] ^ LSFR_out[14] ^ LSFR_out[13] ^ LSFR_out[11] ^ LSFR_out[10] ^ LSFR_out[9]  ^ LSFR_out[6] ^ LSFR_out[4] ^ LSFR_out[3] ^ LSFR_out[2];
         out_reg[14] = in_reg[14] ^ LSFR_out[13] ^ LSFR_out[12] ^ LSFR_out[10] ^ LSFR_out[9]  ^ LSFR_out[8]  ^ LSFR_out[5] ^ LSFR_out[3] ^ LSFR_out[2] ^ LSFR_out[1];
         out_reg[15] = in_reg[15] ^ LSFR_out[15] ^ LSFR_out[12] ^ LSFR_out[11] ^ LSFR_out[9]  ^ LSFR_out[8]  ^ LSFR_out[7] ^ LSFR_out[4] ^ LSFR_out[2] ^ LSFR_out[1] ^ LSFR_out[0];
      end
   end
	
	always @(posedge clk, negedge rst_n) begin
		if (!rst_n) begin
			out <= 'd0;
		end
		else begin
			out <= out_reg;
		end
	end
	
endmodule