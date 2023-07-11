module full_adder (
    input A,
    input B,
    input Cin,
    output S,
    output Cout
);

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
    logic ha1_S, ha1_Cout, ha2_Cout;

    // Instantiate half adders
    half_adder ha1 (
        .A(A),
        .B(B),
        .S(ha1_S),
        .Cout(ha1_Cout)
    );
    half_adder ha2 (
        .A(ha1_S),
        .B(Cin),
        .S(S),
        .Cout(ha2_Cout)
    );

    // Calculate Cout
    assign Cout = ha1_Cout | ha2_Cout;

endmodule
