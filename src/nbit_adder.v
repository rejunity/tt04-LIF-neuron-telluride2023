module nbit_adder #(parameter n = 4) (
    input [(n-1):0] A,
    input [(n-1):0] B,
    output [n:0] S
);

    // Define full adder module
    module full_adder (
        input A,
        input B,
        input Cin,
        output S,
        output Cout
    );
        assign {Cout, S} = A + B + Cin;
    endmodule

    // Define half adder module
    module half_adder (
        input A,
        input B,
        output S,
        output Cout
    );
        assign {Cout, S} = A + B;
    endmodule

    // Define internal signals
    logic [n:0] Cout, Cin;

    // Generate full adders and half adders
    generate
        genvar i;
        for (i=0; i<n; i=i+1) begin : adder_i
            if (i == 0) begin : first_ha
                half_adder ha1 (
                    .A(A[i]),
                    .B(B[i]),
                    .S(S[i]),
                    .Cout(Cout[i])
                );
            end else begin : other_fa
                full_adder other_fa_i (
                    .A(A[i]),
                    .B(B[i]),
                    .Cin(Cout[i-1]),
                    .S(S[i]),
                    .Cout(Cout[i])
                );
            end
        end
    endgenerate

endmodule
