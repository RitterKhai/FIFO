module LSFR #(parameter WIDTH = 16) (
   input  wire clk,
   input  wire rst_n,
   input  wire scram_rst_reg,
   input  wire scram_en_reg,

   output reg  [WIDTH-1:0] LSFR_out
);
   reg [WIDTH-1:0] x_next;
   reg [WIDTH-1:0] x_present;

   always @(*) begin
      x_next[0]  = x_present[15] ^ x_present[12] ^ x_present[11] ^ x_present[9]  ^ x_present[8]  ^ x_present[7] ^ x_present[4] ^ x_present[2] ^ x_present[1] ^ x_present[0];
      x_next[1]  = x_present[13] ^ x_present[12] ^ x_present[10] ^ x_present[9]  ^ x_present[8]  ^ x_present[5] ^ x_present[3] ^ x_present[2] ^ x_present[1];
      x_next[2]  = x_present[14] ^ x_present[13] ^ x_present[11] ^ x_present[10] ^ x_present[9]  ^ x_present[6] ^ x_present[4] ^ x_present[3] ^ x_present[2];
      x_next[3]  = x_present[15] ^ x_present[14] ^ x_present[12] ^ x_present[11] ^ x_present[10] ^ x_present[7] ^ x_present[5] ^ x_present[4] ^ x_present[3];
      x_next[4]  = x_present[13] ^ x_present[9]  ^ x_present[7]  ^ x_present[6]  ^ x_present[5]  ^ x_present[2] ^ x_present[1] ^ x_present[0];
      x_next[5]  = x_present[14] ^ x_present[10] ^ x_present[8]  ^ x_present[7]  ^ x_present[6]  ^ x_present[3] ^ x_present[2] ^ x_present[1];
      x_next[6]  = x_present[15] ^ x_present[11] ^ x_present[9]  ^ x_present[8]  ^ x_present[7]  ^ x_present[4] ^ x_present[3] ^ x_present[2];
      x_next[7]  = x_present[12] ^ x_present[10] ^ x_present[9]  ^ x_present[8]  ^ x_present[5]  ^ x_present[4] ^ x_present[3];
      x_next[8]  = x_present[13] ^ x_present[11] ^ x_present[10] ^ x_present[9]  ^ x_present[6]  ^ x_present[5] ^ x_present[4];
      x_next[9]  = x_present[14] ^ x_present[12] ^ x_present[11] ^ x_present[10] ^ x_present[7]  ^ x_present[6] ^ x_present[5];
      x_next[10] = x_present[15] ^ x_present[13] ^ x_present[12] ^ x_present[11] ^ x_present[8]  ^ x_present[7] ^ x_present[6];
      x_next[11] = x_present[14] ^ x_present[13] ^ x_present[12] ^ x_present[9]  ^ x_present[8]  ^ x_present[7];
      x_next[12] = x_present[15] ^ x_present[14] ^ x_present[13] ^ x_present[10] ^ x_present[9]  ^ x_present[8];
      x_next[13] = x_present[14] ^ x_present[12] ^ x_present[10] ^ x_present[8]  ^ x_present[7]  ^ x_present[4] ^ x_present[2] ^ x_present[1] ^ x_present[0];
      x_next[14] = x_present[15] ^ x_present[13] ^ x_present[11] ^ x_present[9]  ^ x_present[8]  ^ x_present[5] ^ x_present[3] ^ x_present[2] ^ x_present[1];
      x_next[15] = x_present[15] ^ x_present[14] ^ x_present[11] ^ x_present[10] ^ x_present[8]  ^ x_present[7] ^ x_present[6] ^ x_present[3] ^ x_present[1] ^ x_present[0];
   end
   always @(posedge clk, negedge rst_n) begin
      if (!rst_n) begin
         LSFR_out <= 16'hFFFF;
         x_present <= 16'hFFFF;
      end
      else begin
         if (!scram_rst_reg) begin
            LSFR_out <= 16'hFFFF;
            x_present <= 16'hFFFF;
         end
         else begin
            if (!scram_en_reg) begin
               LSFR_out <= 16'h0000;
            end
            else begin
               LSFR_out <= x_present;
               x_present <= x_next;
            end
         end
      end
   end
endmodule