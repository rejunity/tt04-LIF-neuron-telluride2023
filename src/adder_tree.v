module adder_tree
#(
    parameter   n_stage = 5     // Minumum is 1 stage
)
(
    input   [(2**(n_stage+1)-1):0]  wx,
    output  [(n_stage+1):0]         y_out
);

assign y_out = 
        wx[1:0]+
        wx[3:2]+
        wx[5:4]+
        wx[7:6]+
        wx[9:8]+
        wx[11:10]+
        wx[13:12]+
        wx[15:14]+
        wx[17:16]+
        wx[19:18]+
        wx[21:20]+
        wx[23:22]+
        wx[25:24]+
        wx[27:26]+
        wx[29:28]+
        wx[31:30]+
        wx[33:32]+
        wx[35:34]+
        wx[37:36]+
        wx[39:38]+
        wx[41:40]+
        wx[43:42]+
        wx[45:44]+
        wx[47:46]+
        wx[49:48]+
        wx[51:50]+
        wx[53:52]+
        wx[55:54]+
        wx[57:56]+
        wx[59:58]+
        wx[61:60]+
        wx[63:62]+
        wx[65:64]+
        wx[67:66]+
        wx[69:68]+
        wx[71:70]+
        wx[73:72]+
        wx[75:74]+
        wx[77:76]+
        wx[79:78]+
        wx[81:80]+
        wx[83:82]+
        wx[85:84]+
        wx[87:86]+
        wx[89:88]+
        wx[91:90]+
        wx[93:92]+
        wx[95:94]+
        wx[97:96]+
        wx[99:98]+
        wx[101:100]+
        wx[103:102]+
        wx[105:104]+
        wx[107:106]+
        wx[109:108]+
        wx[111:110]+
        wx[113:112]+
        wx[115:114]+
        wx[117:116]+
        wx[119:118]+
        wx[121:120]+
        wx[123:122]+
        wx[125:124]+
        wx[127:126];

    // genvar i, j;
    // generate
    // // Generate connections
    // for (i = 0; i < n_stage; i = i+1) begin : connection
    //     wire [(i+2):0] sum [(2**(n_stage-1-i)-1):0]; // partial sum
    // end

    // // Stage 1
    // for (j = 0; j < 2**(n_stage-1); j = j+1) begin : first_stage
    //     nbit_adder_with_sign_extend #(2) adder (
    //         .A(wx[(4*j+1):(4*j+0)]),
    //         .B(wx[(4*j+3):(4*j+2)]),
    //         .S(connection[0].sum[j])
    //     );
    // end

    // // Remaining stages
    // for (i = 1; i < n_stage; i = i+1) begin : stage_loop
    //     for (j = 0; j < 2**(n_stage-1-i); j = j+1) begin : stage
    //         nbit_adder_with_sign_extend #(i+2) adder (
    //             .A(connection[i-1].sum[2*j+0]),
    //             .B(connection[i-1].sum[2*j+1]),
    //             .S(connection[i].sum[j])
    //         );
    //     end
    // end

    // assign y_out = connection[n_stage-1].sum[0];
    // endgenerate

endmodule
