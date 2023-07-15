// number of inputs = 2**in_num_pow2
// 256*64+ 64*32+ 32*10= 16384+2048+320=18752      64 - 32 - 10 
//      number of neurons=64+32+10= 106
//                       =10*64+8*32+7*10

module neural_network_3layer_fc #(
    parameter input_number = 256,
    parameter neurons_0 = 256,
    parameter neurons_1 = 128,
    parameter neurons_2 = 10,
    // ---
    parameter weights_0_number = input_number*neurons_0,
    parameter weights_1_number = neurons_0*neurons_1,
    parameter weights_2_number = neurons_1*neurons_2,
    parameter total_weight_number = weights_0_number + weights_1_number + weights_2_number,
    parameter total_teta_bits = $clog2(neurons_0)+2+$clog2(neurons_1)+2+$clog2(neurons_2)+2,
    parameter total_BN_addend_bits = ($clog2(neurons_0)+2)*neurons_0+($clog2(neurons_1)+2)*neurons_1+($clog2(neurons_2)+2)*neurons_2,
    parameter total_neuron_number = neurons_0 + neurons_1 + neurons_2,
    parameter layer_number = 3
)
(
    input [input_number-1:0] x,
    input [total_weight_number-1:0] w,
    input [total_weight_number-1:0] connection_enabled,
    input [3*layer_number-1:0] beta_shift,
    input [total_teta_bits-1:0] minus_teta,
    input [4*total_neuron_number-1:0] BN_factor,
    input [total_BN_addend_bits-1:0] BN_addend,
    input clk,
    input rst_n,
    input ce,
    output reg [neurons_2-1:0] spike_out
);
    wire [neurons_0-1:0] spike_out_first_layer;
    wire [neurons_1-1:0] spike_out_second_layer;


    localparam w0_offset = 0;
    localparam w1_offset = weights_0_number + w0_offset;
    localparam w2_offset = weights_1_number + w1_offset;
    localparam w3_offset = weights_2_number + w2_offset;
    localparam beta0_offset = 0;
    localparam beta1_offset = 3 + beta0_offset;
    localparam beta2_offset = 3 + beta1_offset;
    localparam beta3_offset = 3 + beta2_offset;
    localparam teta0_offset = 0;
    localparam teta1_offset = $clog2(input_number)+2 + teta0_offset;
    localparam teta2_offset = $clog2(neurons_0)+2 + teta1_offset;
    localparam teta3_offset = $clog2(neurons_1)+2 + teta2_offset;
    localparam BN0_addend_offset = 0;
    localparam BN1_addend_offset = ($clog2(input_number)+2)*neurons_0;
    localparam BN2_addend_offset = ($clog2(neurons_0)+2)*neurons_1 + BN1_addend_offset;
    localparam BN3_addend_offset = ($clog2(neurons_1)+2)*neurons_2 + BN2_addend_offset;
    localparam BN0_factor_offset = 0;
    localparam BN1_factor_offset = 4*neurons_0;
    localparam BN2_factor_offset = 4*neurons_1 + BN1_factor_offset;
    localparam BN3_factor_offset = 4*neurons_2 + BN2_factor_offset;

    reg [neurons_0-1:0] CONNECTIONS_0 [0:input_number-1];
    reg [neurons_1-1:0] CONNECTIONS_1 [0:neurons_0-1];
    reg [neurons_2-1:0] CONNECTIONS_2 [0:neurons_1-1];
    initial
    begin
        $readmemb("connections_0.mem", CONNECTIONS_0);
        $readmemb("connections_1.mem", CONNECTIONS_1);
        $readmemb("connections_2.mem", CONNECTIONS_2);
    end
    wire [weights_0_number-1:0] connections_0;
    wire [weights_1_number-1:0] connections_1;
    wire [weights_2_number-1:0] connections_2;
    generate
        genvar i;
        for (i = 0; i < input_number; i = i + 1) begin
            assign connections_0[(i+1)*neurons_0-1:i*neurons_0] = CONNECTIONS_0[i];
        end
        for (i = 0; i < neurons_0; i = i + 1) begin
            assign connections_1[(i+1)*neurons_1-1:i*neurons_1] = CONNECTIONS_1[i];
        end
        for (i = 0; i < neurons_1; i = i + 1) begin
            assign connections_2[(i+1)*neurons_2-1:i*neurons_2] = CONNECTIONS_2[i];
        end
    endgenerate

    layer #($clog2(input_number), neurons_0) first_layer (
        .x(x),
        .w(w[w1_offset-1:w0_offset]),
        .connection_enabled(connections_0),
        .beta_shift(beta_shift[beta1_offset-1:beta0_offset]),
        .minus_teta(minus_teta[teta1_offset-1:teta0_offset]),
        .BN_factor(BN_factor[BN1_factor_offset-1:BN0_factor_offset]),
        .BN_addend(BN_addend[BN1_addend_offset-1:BN0_addend_offset]),
        .clk(clk),
        .rst_n(rst_n),
        .ce(ce),
        .spike_out(spike_out_first_layer)
    );

    layer #($clog2(neurons_0), neurons_1) second_layer (
        .x(spike_out_first_layer),
        .w(w[w2_offset-1:w1_offset]),
        .connection_enabled(connections_1),
        .beta_shift(beta_shift[beta2_offset-1:beta1_offset]),
        .minus_teta(minus_teta[teta2_offset-1:teta1_offset]),
        .BN_factor(BN_factor[BN2_factor_offset-1:BN1_factor_offset]),
        .BN_addend(BN_addend[BN2_addend_offset-1:BN1_addend_offset]),
        .clk(clk),
        .rst_n(rst_n),
        .ce(ce),
        .spike_out(spike_out_second_layer)
    );

    layer #($clog2(neurons_1), neurons_2) final_layer (
        .x(spike_out_second_layer),
        .w(w[w3_offset-1:w2_offset]),
        .connection_enabled(connections_2),
        .beta_shift(beta_shift[beta3_offset-1:beta2_offset]),
        .minus_teta(minus_teta[teta3_offset-1:teta2_offset]),
        .BN_factor(BN_factor[BN3_factor_offset-1:BN2_factor_offset]),
        .BN_addend(BN_addend[BN3_addend_offset-1:BN2_addend_offset]),
        .clk(clk),
        .rst_n(rst_n),
        .ce(ce),
        .spike_out(spike_out)
    );
endmodule


module neural_network #(parameter in_num_pow2 = 8, weight_number = 18752, layer_number = 3) (
    input [(2**in_num_pow2)-1:0] x,
    input [weight_number-1:0] w,
    input [weight_number-1:0] connection_enabled,
    input [3*layer_number-1:0] beta_shift,
    input [((in_num_pow2+2)*layer_number)-1:0] minus_teta,
    input [4*106-1:0] BN_factor,
    input [966-1:0] BN_addend,
    input clk,
    input rst_n,
    input ce,
    output reg [(10-1):0] spike_out
);
    wire [(63-1):0] spike_out_first_layer;
    wire [(31-1):0] spike_out_second_layer;

    layer #(in_num_pow2, 64) first_layer (
        .x(x),
        .w(w[(16384-1):0]),
        .connection_enabled(connection_enabled[16384-1:0]),
        .beta_shift(beta_shift[(2):0]),
        .minus_teta(minus_teta[(in_num_pow2+1):0]),
        .BN_factor(BN_factor[(4*64-1):0]),
        .BN_addend(BN_addend[((in_num_pow2+2)*64-1):0]),
        .clk(clk),
        .rst_n(rst_n),
        .ce(ce),
        .spike_out(spike_out_first_layer)
    );

    layer #(6, 32) second_layer (
        .x(spike_out_first_layer),
        .w(w[(16384+2048-1):16384]),
        .connection_enabled(connection_enabled[16384+2048-1:16384]),
        .s(NET_SPARSITY[16384+2048-1:16384]),
        .beta_shift(beta_shift[(5):3]),
        .minus_teta(minus_teta[(14):7]),
        .BN_factor(BN_factor[(4*(64+32)-1):4*64]),
        .BN_addend(BN_addend[((6+2)*(64+32)-1):(6+2)*64]),
        .clk(clk),
        .rst_n(rst_n),
        .ce(ce),
        .spike_out(spike_out_second_layer)
    );

    layer #(5, 10) final_layer (
        .x(spike_out_second_layer),
        .w(w[(16384+2048+320-1):(16384+2048)]),
        .connection_enabled(connection_enabled[16384+2048+320-1:(16384+2048)]),
        .beta_shift(beta_shift[(8):6]),
        .minus_teta(minus_teta[(21):15]),
        .BN_factor(BN_factor[(4*(64+32+10)-1):4*(64+32)]),
        .BN_addend(BN_addend[((5+2)*(64+32+10)-1):(5+2)*(64+32)]),
        .clk(clk),
        .rst_n(rst_n),
        .ce(ce),
        .spike_out(spike_out)
    );

endmodule
