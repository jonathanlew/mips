`define opWidth 6
`define regWidth 5
`define immWidth 16
`define valWidth 32
`define PCWidth 9

module fetchStageA(PC,mem_addr);
    input [`PCWidth-1:0] PC;
    output [`PCWidth-1:0] mem_addr;
    assign mem_addr = PC;
endmodule


module fetchStageB(PC,dout,nextPC,instructions);
    input [`PCWidth-1:0] PC;
    input [`valWidth-1:0] dout;
    output [`PCWidth-1:0] nextPC;
    assign nextPC = PC + 4;
    output [`valWidth-1:0] instructions;
    assign instructions = dout;
endmodule
