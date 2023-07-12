module mulplier_accumulator #(parameter n_stage = 6) (
    input [(2**n_stage)-1:0] w,
    input [(2**n_stage)-1:0] x,
    output [(n_stage+1):0] y_out
);

    wire [63:0] y_plus;
    wire [63:0] y_minus;
    wire [(n_stage+1):0] sum_plus;
    wire [(n_stage+1):0] sum_minus;

    assign y_plus = x & w;
    assign y_minus = x & (~w);

    assign sum_plus = 
        y_plus[0]+
        y_plus[1]+
        y_plus[2]+
        y_plus[3]+
        y_plus[4]+
        y_plus[5]+
        y_plus[6]+
        y_plus[7]+
        y_plus[8]+
        y_plus[9]+
        y_plus[10]+
        y_plus[11]+
        y_plus[12]+
        y_plus[13]+
        y_plus[14]+
        y_plus[15]+
        y_plus[16]+
        y_plus[17]+
        y_plus[18]+
        y_plus[19]+
        y_plus[20]+
        y_plus[21]+
        y_plus[22]+
        y_plus[23]+
        y_plus[24]+
        y_plus[25]+
        y_plus[26]+
        y_plus[27]+
        y_plus[28]+
        y_plus[29]+
        y_plus[30]+
        y_plus[31]+
        y_plus[32]+
        y_plus[33]+
        y_plus[34]+
        y_plus[35]+
        y_plus[36]+
        y_plus[37]+
        y_plus[38]+
        y_plus[39]+
        y_plus[40]+
        y_plus[41]+
        y_plus[42]+
        y_plus[43]+
        y_plus[44]+
        y_plus[45]+
        y_plus[46]+
        y_plus[47]+
        y_plus[48]+
        y_plus[49]+
        y_plus[50]+
        y_plus[51]+
        y_plus[52]+
        y_plus[53]+
        y_plus[54]+
        y_plus[55]+
        y_plus[56]+
        y_plus[57]+
        y_plus[58]+
        y_plus[59]+
        y_plus[60]+
        y_plus[61]+
        y_plus[62]+
        y_plus[63];

    assign sum_minus = 
        y_minus[0]+
        y_minus[1]+
        y_minus[2]+
        y_minus[3]+
        y_minus[4]+
        y_minus[5]+
        y_minus[6]+
        y_minus[7]+
        y_minus[8]+
        y_minus[9]+
        y_minus[10]+
        y_minus[11]+
        y_minus[12]+
        y_minus[13]+
        y_minus[14]+
        y_minus[15]+
        y_minus[16]+
        y_minus[17]+
        y_minus[18]+
        y_minus[19]+
        y_minus[20]+
        y_minus[21]+
        y_minus[22]+
        y_minus[23]+
        y_minus[24]+
        y_minus[25]+
        y_minus[26]+
        y_minus[27]+
        y_minus[28]+
        y_minus[29]+
        y_minus[30]+
        y_minus[31]+
        y_minus[32]+
        y_minus[33]+
        y_minus[34]+
        y_minus[35]+
        y_minus[36]+
        y_minus[37]+
        y_minus[38]+
        y_minus[39]+
        y_minus[40]+
        y_minus[41]+
        y_minus[42]+
        y_minus[43]+
        y_minus[44]+
        y_minus[45]+
        y_minus[46]+
        y_minus[47]+
        y_minus[48]+
        y_minus[49]+
        y_minus[50]+
        y_minus[51]+
        y_minus[52]+
        y_minus[53]+
        y_minus[54]+
        y_minus[55]+
        y_minus[56]+
        y_minus[57]+
        y_minus[58]+
        y_minus[59]+
        y_minus[60]+
        y_minus[61]+
        y_minus[62]+
        y_minus[63];

    assign y_out = y_plus - y_minus;


    // wire [(2*(2**n_stage))-1:0] mult_out;

    // multiplier_stage #(n_stage) mult_uut (
    //     .w(w),
    //     .x(x),
    //     .mult_out(mult_out)
    // );

    // adder_tree #(n_stage) adder_uut (
    //     .wx(mult_out),
    //     .y_out(y_out)
    // );

endmodule
