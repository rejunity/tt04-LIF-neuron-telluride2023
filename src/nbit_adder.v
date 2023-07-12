module nbit_adder #(
    parameter n = 4
)
(
    input [(n-1):0] A,
    input [(n-1):0] B,
    output [n:0] S
);

    assign S = A + B;
    // wire [n-1:0] Cout;

    // // Bit0 -> half adder
    // half_adder ha0 (
    //     .A(A[0]),
    //     .B(B[0]),
    //     .S(S[0]),
    //     .Cout(Cout[0])
    // );

    // // Bit1:n -> full adders
    // genvar i;
    // generate
    // for (i = 1; i < n; i = i+1) begin
    //     full_adder faI (
    //         .A(A[i]),
    //         .B(B[i]),
    //         .Cin(Cout[i-1]),
    //         .S(S[i]),
    //         .Cout(Cout[i])
    //     );
    // end
    // endgenerate

    // assign S[n] = Cout[n-1];

endmodule

module nbit_adder_with_sign_extend #(
    parameter n = 4
)
(
    input [(n-1):0] A,
    input [(n-1):0] B,
    output [n:0] S
);

    assign S =  $signed(A + B);

    // wire [n-1:0] Cout;

    // // Bit0 -> half adder
    // half_adder ha0 (
    //     .A(A[0]),
    //     .B(B[0]),
    //     .S(S[0]),
    //     .Cout(Cout[0])
    // );

    // // Bit1:n -> full adders
    // genvar i;
    // generate
    // for (i = 1; i < n; i = i+1) begin
    //     full_adder faI (
    //         .A(A[i]),
    //         .B(B[i]),
    //         .Cin(Cout[i-1]),
    //         .S(S[i]),
    //         .Cout(Cout[i])
    //     );
    // end
    // endgenerate

    // assign S[n] = S[n-1];

endmodule
