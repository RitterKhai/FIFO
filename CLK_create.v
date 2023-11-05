module CLK_create #(parameter [26:0] freq = 5) (
    input  wire clk,
    input  wire rst_n,
  	 output reg clk_out
);
  
reg [29:0] count_s;
  

always @(posedge clk, negedge rst_n) begin 
   if (!rst_n) begin 
      count_s <= 'd0; 
      clk_out <= 'd0;
   end 
   else begin
      if (count_s >= (freq-1)) begin
          count_s <= 'd0;
          clk_out <= ~clk_out;
      end 
      else begin 
         count_s <= count_s + 'd1;
      end
   end
end

endmodule