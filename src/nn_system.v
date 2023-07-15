module nn_system (
    input [1:0] nn_parameters,
    input [7:0] inputs,
    input fifo_w_ce,
    input fifo_beta_shift_ce,
    input fifo_minus_teta_ce,
    input fifo_BN_factor_ce,
    input fifo_BN_addend_ce,
    input fifo_inputs_ce,
    input clk,
    input rst_n,
    input ce,
    output [9:0] outputs
);

    localparam input_number = 32;
    localparam neurons_0 = 256;
    localparam neurons_1 = 32;
    localparam neurons_2 = 10;

    localparam weights_0_number = input_number*neurons_0;
    localparam weights_1_number = neurons_0*neurons_1;
    localparam weights_2_number = neurons_1*neurons_2;
    localparam total_weight_number = weights_0_number + weights_1_number + weights_2_number;
    localparam total_neuron_number = neurons_0 + neurons_1 + neurons_2;
    localparam layer_number = 3;

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

    wire [input_number-1:0] x;

    wire [neurons_0-1:0] spike_out_first_layer;
    wire [neurons_1-1:0] spike_out_second_layer;
    wire [neurons_2-1:0] spike_out;

    wire [total_weight_number-1:0] w;
    wire [beta3_offset-1:0] beta_shift;
    wire [teta3_offset-1:0] minus_teta;
    wire [BN3_factor_offset-1:0] BN_factor;
    wire [BN3_addend_offset-1:0] BN_addend;

    // wire [SIZE_LAYER_1*SIZE_LAYER_2-1:0] L1_out_a;
    // wire [SIZE_LAYER_1*SIZE_LAYER_2-1:0] L1_out_b;
    // wire [SIZE_LAYER_2*SIZE_LAYER_3-1:0] L2_out_a;
    // wire [SIZE_LAYER_2*SIZE_LAYER_3-1:0] L2_out_b;
    // wire [SIZE_LAYER_3-1:0] L3_out;
    // layer l1 (.in(x), .out(L1_out_a));
    // assign L1_out_b = CONNECTIONS_L12 & L1_out_a;
    // layer l2 (.in(L1_out_b), .out(L2_out_a));
    // assign L2_out_b = CONNECTIONS_L23 & L2_out_a;
    // layer l3 (.in(L2_out_b), .out(L3_out));

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
        for (i = 0; i < input_number; i++) begin
            assign connections_0[(i+1)*neurons_0-1:i*neurons_0] = CONNECTIONS_0[i];
        end
        for (i = 0; i < neurons_0; i++) begin
            assign connections_1[(i+1)*neurons_1-1:i*neurons_1] = CONNECTIONS_1[i];
        end
        for (i = 0; i < neurons_1; i++) begin
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

    // //neural_network #(.in_num_pow2(8), .weight_number(18752), .layer_number(3)) neural_network_uut (
    // neural_network_3layer_fc #(input_number,neurons_0,neurons_1,neurons_2) neural_network_uut (
    //     .x(x),
    //     .w(w),
    //     .beta_shift(beta_shift),
    //     .minus_teta(minus_teta),
    //     .BN_factor(BN_factor),
    //     .BN_addend(BN_addend),
    //     .clk(clk),
    //     .rst_n(rst_n),
    //     .ce(ce),
    //     .spike_out(spike_out)
    // );

    SIPO #(.N(2), .M(total_weight_number)) SIPO_w (
        .serial_in(nn_parameters),
        .clk(clk),
        .rst_n(rst_n),
        .ce(fifo_w_ce),
        .parallel_out(w)
    );

    SIPO #(.N(2), .M(beta3_offset)) SIPO_beta_shift (
        .serial_in(nn_parameters),
        .clk(clk),
        .rst_n(rst_n),
        .ce(fifo_beta_shift_ce),
        .parallel_out(beta_shift)
    );
    
    SIPO #(.N(2), .M(teta3_offset)) SIPO_minus_teta (
        .serial_in(nn_parameters),
        .clk(clk),
        .rst_n(rst_n),
        .ce(fifo_minus_teta_ce),
        .parallel_out(minus_teta)
    );

    SIPO #(.N(2), .M(BN3_factor_offset)) SIPO_BN_factor (
        .serial_in(nn_parameters),
        .clk(clk),
        .rst_n(rst_n),
        .ce(fifo_BN_factor_ce),
        .parallel_out(BN_factor)
    );

    SIPO #(.N(2), .M(BN3_addend_offset)) SIPO_BN_addend (
        .serial_in(nn_parameters),
        .clk(clk),
        .rst_n(rst_n),
        .ce(fifo_BN_addend_ce),
        .parallel_out(BN_addend)
    );

    SIPO #(.N(8), .M(input_number)) SIPO_inputs (
        .serial_in(inputs),
        .clk(clk),
        .rst_n(rst_n),
        .ce(fifo_inputs_ce),
        .parallel_out(x)
    );

    assign outputs = spike_out;

endmodule
