`define opWidth 6
`define regWidth 5
`define immWidth 16
`define valWidth 32
`define PCWidth 9
`define regInstr 6'b0

//combinational logic

module decodeStage (//inputs
                    instr, doutA,doutB,
                    //outputs
    opCode,PCSel,immSel,valA,valB,rd,sxImm,aluOp,shift,readA,readB);
    input [`valWidth-1:0] instr,doutA,doutB;

    output [`opWidth-1:0] opCode;
    output [`valWidth-1:0] valA, valB, sxImm;
    output [`regWidth-1:0] shift,readA,readB;

    assign opCode = instr [`valWidth-1:`valWidth-6];
    assign sxImm = {{(`valWidth-`immWidth+1){instr[`immWidth-1]}},instr[`immWidth-2:0]};
    assign valA = doutA;
    assign valB = doutB;
    assign shift = instr [`valWidth-21:`valWidth-26];
    assign readA = instr [`valWidth-7:`valWidth-11];
    assign readB = instr [`valWidth-12:`valWidth-16];

    output reg PCSel, immSel;
    output reg [`regWidth-1:0] rd;
    output reg [`opWidth-1:0] aluOp;


    always @(*)
        case (instr [`valWidth-1:`valWidth-6])
            `regInstr: {PCSel, immSel, rd, aluOp} = {2'b0, instr[`valWidth-17:`valWidth-21],instr[5:0]};

            default: {PCSel, immSel, rd, aluOp} = {1'b0,1'b1,instr[`valWidth-12:`valWidth-16],instr[`valWidth-1:`valWidth-6]}; 
        endcase

endmodule
