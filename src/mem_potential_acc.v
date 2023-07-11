module mem_potential_acc #(parameter n_stage = 6) (
    input [(n_stage+1):0] beta_u,
    input [(n_stage+1):0] sum_wx,
    input [(n_stage+1):0] minus_teta,
    input was_spike,
    output reg [(n_stage+1):0] u_out
);

    // Define n-bit adder module
    module nbit_adder #(parameter n = 4) (
        input [(n-1):0] A,
        input [(n-1):0] B,
        output [n:0] S
    );
        assign S = A + B;
    endmodule

    reg [(n_stage+2):0] s_out_1, s_out_2;

    // Calculate Adder1 = beta*u(t-1) + sum[w*x(t)]
    nbit_adder #(n_stage+2) Adder_1 (
        .A(beta_u),
        .B(sum_wx),
        .S(s_out_1)
    );

    // Calculate Adder2 = beta*u(t-1) + sum[w*x(t)] + minus_teta
    nbit_adder #(n_stage+2) Adder_2 (
        .A(s_out_1[(n_stage+1):0]),
        .B(minus_teta),
        .S(s_out_2)
    );

    // Assign u_out based on was_spike
    always @(posedge clk) begin
        if (was_spike)
            u_out <= s_out_1[(n_stage+1):0];
        else
            u_out <= s_out_2[(n_stage+1):0];
    end

endmodule

