module layer #(parameter n_stage = 8, parameter neuron_num = 64) (
    input [(2**n_stage)-1:0] x,
    input [(neuron_num*(2**n_stage))-1:0] w,
    input [(neuron_num*(2**n_stage))-1:0] connection_enabled,
    input [2:0] beta_shift,
    input [(n_stage+1):0] minus_teta,
    input [(4*neuron_num)-1:0] BN_factor,
    input [(n_stage+2)*neuron_num-1:0] BN_addend,
    input clk,
    input rst_n,
    input ce,
    output reg [(neuron_num-1):0] spike_out
);

    genvar i;
    generate
        for (i = 0; i < neuron_num; i = i + 1) begin : neurons
            neuron_struct #(n_stage) neuron_i (
                .w(w[(i+1)*(2**n_stage)-1 : i*(2**n_stage)]),
                // .x(x),
                .x(connection_enabled[i*(2**n_stage)] & x),
                .shift(beta_shift),
                .minus_teta(minus_teta),
                .BN_factor(BN_factor[(4*(i+1))-1 : i*4]),
                .BN_addend(BN_addend[((i+1)*(n_stage+2))-1 : i*(n_stage+2)]),
                .clk(clk),
                .rst_n(rst_n),
                .ce(ce),
                .spike_out(spike_out[i])
            );
        end
    endgenerate

endmodule
