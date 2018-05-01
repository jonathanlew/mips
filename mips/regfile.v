`define opWidth 6
`define regWidth 5
`define immWidth 16
`define valWidth 32
`define PCWidth 9

//implements a regfile module
module regfile (//inputs 
                clk,readA,readB,writeAddr,write,din,
                //outputs
                doutA,doutB
                );
    parameter data_width = 32; 
    parameter addr_width = 5;
    
    input  clk;
    input  [addr_width-1:0] readA,readB,writeAddr;
    input  write;
    input  [data_width-1:0] din;
    output [data_width-1:0] doutA, doutB;
    reg    [data_width-1:0] mem [2**addr_width-1:0];
    
    assign doutA = mem[readA];
    assign doutB = mem[readB];
    always @ (posedge clk) begin
      if (write)
        mem[writeAddr] <= din;
    end 

endmodule

module RAM(clk, read_address, write_address, write, din, dout);
  parameter data_width = 32;
  parameter addr_width = 8;
  parameter filename = "lab8fig2.txt";

  input clk;
  input [addr_width-1:0] read_address, write_address;
  input write;
  input [data_width-1:0] din;
  output [data_width-1:0] dout;
  reg [data_width-1:0] dout;

  reg [data_width-1:0] mem [2**addr_width-1:0];

  initial $readmemb(filename, mem);

  always @ (posedge clk) begin
    if (write)
      mem[write_address] <= din;
    dout <= mem[read_address]; //dout gets din one cycle late
  end
endmodule
