module spike_generator #(parameter n_stage = 2) (
    input [(n_stage+1):0] u,
    input [(n_stage+1):0] minus_teta,
    output is_spike
);

    // Define n-bit adder module
    module nbit_adder #(parameter n = 4) (
        input [(n-1):0] A,
        input [(n-1):0] B,
        output [n:0] S
    );
        assign S = A + B;
    endmodule

    reg [(n_stage+2):0] s_out;

    // Calculate Adder_1 = u + minus_teta
    nbit_adder #(n_stage+2) Adder_1 (
        .A(u),
        .B(minus_teta),
        .S(s_out)
    );

    // Assign is_spike based on s_out
    assign is_spike = ~s_out[(n_stage+2)];

endmodule

