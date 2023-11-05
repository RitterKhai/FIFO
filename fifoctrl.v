module fifoctrl
    (
     clkw, //clock write
     clkr, //clock read
     rst_n,
     
     fiford,    // FIFO control
     fifowr,

     fifofull,  // high when fifo full
     empty,     // high when fifo empty
//     fifolen,   // fifo length

                // Connect to memories
     write,     // enable to write memories
     wraddr,    // write address of memories
     read,      // enable to read memories
     rdaddr     // read address of memories
     );

parameter ADDRBIT = 5;
parameter LENGTH = 32;

input   clkw,
        clkr,
        rst_n,
        fiford,
        fifowr;

output  reg fifofull;
output  reg empty;

//output [ADDRBIT:0] fifolen;

output  write;
output  read;

output reg [ADDRBIT-1:0] wraddr;
output reg [ADDRBIT-1:0] rdaddr;

//reg     [ADDRBIT:0]   fifo_len;

//assign  fifolen     =   fifo_len;
wire    write;
assign  write       =   (fifowr & !fifofull);
wire    read;
assign  read        =   (fiford & !empty);

always @(posedge clkr or negedge rst_n)begin
    if(!rst_n) begin
		rdaddr <= 'd0;
	 end
    else begin
		 if(fiford && !empty && rdaddr == 5'h1f) begin
			 rdaddr <= 'd0;
		 end
		 else if (fiford && !empty) begin
			 rdaddr <= rdaddr + 'd1;
		 end
    end
end

always @(posedge clkw or negedge rst_n)begin
    if(!rst_n) begin
		wraddr <= 'd0;
	 end
    else begin
		 if(fifowr && !fifofull && wraddr == 5'h1f) begin
			 wraddr <= 'd0;
		 end
		 else if (fifowr && !fifofull) begin
			 wraddr <= wraddr + 'd1;
		 end
    end
end

/*
always @(posedge clkr or negedge rst_n) begin
    if(!rst_n) begin
		fifo_len  <= {1'b0,{ADDRBIT{1'b0}}};
	 end
    else begin
        case({read,write})
        2'b01: fifo_len <= fifo_len + 1'b1;
        2'b10: fifo_len <= fifo_len - 1'b1;
        default: fifo_len <= fifo_len;
        endcase
		end
	end
*/
	 
always @(*) begin
/*
always @(posedge clkr or negedge rst_n) begin
    if(!rst_n) begin
		fifofull <= 'd0;
		empty <= 'd0;
	 end
    else begin
*/
		  if (((wraddr + 1) == rdaddr) || (wraddr ==  5'h1f && rdaddr == 5'h0)) begin
				fifofull <= 'd1;
				empty <= 'd0;
		  end
		  else if (wraddr == rdaddr) begin
				fifofull <= 'd0;
				empty <= 'd1;
		  end
		  else begin
				fifofull <= 'd0;
				empty <= 'd0;		  
		  end

//    end
end
endmodule
