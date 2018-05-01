`define opWidth 6
`define regWidth 5
//`define immWidth 16
`define valWidth 32
`define PCWidth 9


module IFID(//input
    clk, en, //allows stalls
    bubbleSel, //sets stage to nop
    instrIn, nextPCIn,
    instrOut, nextPCOut);
    input clk, en, bubbleSel;
    input [`valWidth-1:0]   instrIn;
    input [`PCWidth-1:0]    nextPCIn;
    output [`valWidth-1:0]   instrOut;
    output [`PCWidth-1:0]    nextPCOut;

    vDFFE #(`valWidth) instr    (clk, en, instrIn, instrOut);
    vDFFE #(`PCWidth)  nextPC   (clk, en, nextPCIn, nextPCOut);
endmodule

/*
module IFID(//input
    clk, en, //allows stalls
    bubbleSel, //sets stage to nop
    opCodeIn, rmIn, rnIn, rdIn, immIn, nextPCIn,
    opCodeOut, rmOut, rnOut, rdOut, immOut, nextPCOut);
    input clk, en, bubbleSel;
    input [`opWidth-1:0]    opCodeIn;
    input [`regWidth-1:0]   rmIn, rnIn, rdIn;
    input [`immWidth-1:0]   immIn;
    input [`PCWidth-1:0]    nextPCIn;
    output [`opWidth-1:0]   opCodeOut;
    output [`regWidth-1:0]  rmOut, rnOut, rdOut;
    output [`immWidth-1:0]  immOut;
    output [`PCWidth-1:0]   nextPCOut;

    vDFFE #(`opWidth)  opCode   (clk, en, opCodeIn, opCodeOut);
    vDFFE #(`regWidth) rm       (clk, en, rmIn, rmOut);
    vDFFE #(`regWidth) rn       (clk, en, rnIn, rnOut);
    vDFFE #(`regWidth) rd       (clk, en, rdIn, rdOut);
    vDFFE #(`immWidth) imm      (clk, en, immIn, immOut);
    vDFFE #(`PCWidth)  nextPC   (clk, en, nextPCIn, nextPCOut);
endmodule
*/


module IDEX(//input
    clk, en, //allows stalls
    bubbleSel, //sets stage to nop
    opCodeIn, PCSelIn, immSelIn, valAIn, valBIn, rdIn, sxImmIn, aluOpIn, shiftIn, nextPCIn,
    opCodeOut, PCSelOut, immSelOut, valAOut, valBOut, rdOut, sxImmOut, aluOpOut, shiftOut, nextPCOut);

    input clk, en, PCSelIn, immSelIn, bubbleSel;
    input [`opWidth-1:0]    opCodeIn, aluOpIn;
    input [`regWidth-1:0]   rdIn, shiftIn;
    input [`valWidth-1:0]   sxImmIn, valAIn, valBIn;
    input [`PCWidth-1:0]    nextPCIn;

    output PCSelOut, immSelOut; 
    output [`opWidth-1:0]   opCodeOut, aluOpOut;
    output [`regWidth-1:0]  rdOut, shiftOut;
    output [`valWidth-1:0]  sxImmOut, valAOut, valBOut;
    output [`PCWidth-1:0]   nextPCOut;

    vDFFE PCSel     (clk, en, PCSelIn, PCSelOut);
    vDFFE immSel    (clk, en, immSelIn, immSelOut);
    vDFFE #(`opWidth)  opCode   (clk, en, opCodeIn, opCodeOut);
    vDFFE #(`regWidth) rd       (clk, en, rdIn, rdOut);
    vDFFE #(`opWidth)  aluOp    (clk, en, aluOpIn, aluOpOut);
    vDFFE #(`regWidth) shift    (clk, en, shiftIn, shiftOut);
    vDFFE #(`valWidth) valA     (clk, en, valAIn, valAOut);
    vDFFE #(`valWidth) valB     (clk, en, valBIn, valBOut);
    vDFFE #(`valWidth) sxImm    (clk, en, sxImmIn, sxImmOut);
    vDFFE #(`PCWidth)  nextPC   (clk, en, nextPCIn, nextPCOut);
endmodule

module EXME(//input
    clk, en, //allows stalls
    bubbleSel, //sets stage to nop
    opCodeIn, zeroIn, aluIn, rdIn, sxImmIn, nextPCIn,
    opCodeOut, zeroOut, aluOut, rdOut, sxImmOut, nextPCOut);

    input clk, en, zeroIn, bubbleSel;
    input [`opWidth-1:0]    opCodeIn;
    input [`regWidth-1:0]   rdIn;
    input [`valWidth-1:0]   sxImmIn, aluIn;
    input [`PCWidth-1:0]    nextPCIn;

    output zeroOut; 
    output [`opWidth-1:0]    opCodeOut;
    output [`regWidth-1:0]   rdOut;
    output [`valWidth-1:0]   sxImmOut, aluOut;
    output [`PCWidth-1:0]    nextPCOut;

    vDFFE #(`opWidth)  opCode   (clk, en, opCodeIn, opCodeOut);
    vDFFE zero    (clk, en, zeroIn, zeroOut);
    vDFFE #(`valWidth) alu     (clk, en, aluIn, aluOut);
    vDFFE #(`regWidth) rd       (clk, en, rdIn, rdOut);
    vDFFE #(`valWidth) sxImm    (clk, en, sxImmIn, sxImmOut);
    vDFFE #(`PCWidth)  nextPC   (clk, en, nextPCIn, nextPCOut);
endmodule

module MEWB(//input
    clk, en, //allows stalls
    bubbleSel, //sets stage to nop
    opCodeIn, memIn, aluIn, rdIn, sxImmIn, 
    opCodeOut, memOut, aluOut, rdOut, sxImmOut);

    input clk, en, bubbleSel;
    input [`opWidth-1:0]    opCodeIn;
    input [`regWidth-1:0]   rdIn;
    input [`valWidth-1:0]   sxImmIn, aluIn, memIn;

    output [`opWidth-1:0]    opCodeOut;
    output [`regWidth-1:0]   rdOut;
    output [`valWidth-1:0]   sxImmOut, aluOut, memOut;

    vDFFE #(`opWidth)  opCode   (clk, en, opCodeIn, opCodeOut);
    vDFFE #(`valWidth) alu     (clk, en, aluIn, aluOut);
    vDFFE #(`valWidth) mem     (clk, en, memIn, memOut);
    vDFFE #(`regWidth) rd       (clk, en, rdIn, rdOut);
    vDFFE #(`valWidth) sxImm    (clk, en, sxImmIn, sxImmOut);
endmodule

module vDFFE(clk,load,in,out);
  parameter k=1;
  input clk, load;
  input [k-1:0] in; 
  output reg [k-1:0] out;
  wire [k-1:0] next_out = load ? in : out;
  always @(posedge clk)
    out = next_out;
endmodule

module vDFF(clk,in,out);
  parameter k=1;
  input clk;
  input [k-1:0] in; 
  output reg [k-1:0] out;
  always @(posedge clk)
    out <= in; 
endmodule
