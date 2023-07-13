//`define LARGE
`define HUGE

`ifdef HUGE
module tt_um_neuron_net #(  parameter input_bits = 256,
                            parameter neurons_0 = 256,
                            parameter neurons_1 = 128,
                            parameter neurons_2 = 10
)
(
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    wire reset = !rst_n;
    assign uio_oe = 0;
    assign uo_out[7:1] = 0;

    wire [7:0] inputs = ui_in[7:0];
    wire [1:0] nn_parameters = uio_in[1:0];
    wire fifo_w_ce = uio_in[2];
    wire fifo_beta_shift_ce = uio_in[3];
    wire fifo_minus_teta_ce = uio_in[4];
    wire fifo_BN_factor_ce = uio_in[5];
    wire fifo_BN_addend_ce = uio_in[6];
    wire fifo_inputs_ce = uio_in[7];

    wire spike = uo_out[0];
    wire [9:0] outputs;
    assign spike = outputs[0];

    nn_system nn_system (
        .nn_parameters(nn_parameters),
        .inputs(inputs),
        .fifo_w_ce(fifo_w_ce),
        .fifo_beta_shift_ce(fifo_beta_shift_ce),
        .fifo_minus_teta_ce(fifo_minus_teta_ce),
        .fifo_BN_factor_ce(fifo_BN_factor_ce),
        .fifo_BN_addend_ce(fifo_BN_addend_ce),
        .fifo_inputs_ce(fifo_inputs_ce),
        .clk(clk),
        .rst_n(rst_n),
        .ce(1'b1),
        .outputs(outputs)
    );

    // wire [neurons_2-1:0] spike_out;
    // wire [10-1:0] beta_shift_SIPO_out;

    // wire [neurons_0-1:0] spike_out_first_layer;
    // wire [neurons_1-1:0] spike_out_second_layer;

    // wire [input_number-1:0] x;
    // wire [total_weight_number-1:0] w;

    // // input [3*layer_number-1:0] beta_shift,
    // // input [((in_num_pow2+2)*layer_number)-1:0] minus_teta
    // // input [4*106-1:0] BN_factor,
    // // input [966-1:0] BN_addend,


    // //layer #(in_num_pow2, 1) first_layer (
    // layer #(input_bits, 1) first_layer (
    //     .x(x),
    //     .w(w[weights_0_number-1:0]),
    //     //.s(NET_SPARSITY[(16384-1):0]),
    //     .beta_shift(beta_shift[2:0]),
    //     .minus_teta(minus_teta[(input_bits+1):0]),
    //     //.BN_factor(BN_factor[(4*64-1):0]),
    //     //.BN_addend(BN_addend[((in_num_pow2+2)*64-1):0]),
    //     .BN_factor(BN_factor[4:0]),
    //     .BN_addend(BN_addend[6:0]),
    //     .clk(clk),
    //     .rst_n(rst_n),
    //     .ce(ce),
    //     .spike_out(spike_out_first_layer)
    // );

    // // layer #(2, 4) second_layer (
    // //     .x(spike_out_first_layer),
    // //     .w(w[(16384+2048-1):16384]),
    // //     .s(NET_SPARSITY[16384+2048-1:16384]),
    // //     .beta_shift(beta_shift[(5):3]),
    // //     .minus_teta(minus_teta[(14):7]),
    // //     .BN_factor(BN_factor[(4*(64+32)-1):4*64]),
    // //     .BN_addend(BN_addend[((6+2)*(64+32)-1):(6+2)*64]),
    // //     .clk(clk),
    // //     .rst_n(rst_n),
    // //     .ce(ce),
    // //     .spike_out(spike_out_second_layer)
    // // );

    // // layer #(2, 10) final_layer (
    // //     .x(spike_out_second_layer),
    // //     .w(w[(16384+2048+320-1):(16384+2048)]),
    // //     .s(NET_SPARSITY[16384+2048-1:16384]),
    // //     .beta_shift(beta_shift[(8):6]),
    // //     .minus_teta(minus_teta[(21):15]),
    // //     .BN_factor(BN_factor[(4*(64+32+10)-1):4*(64+32)]),
    // //     .BN_addend(BN_addend[((5+2)*(64+32+10)-1):(5+2)*(64+32)]),
    // //     .clk(clk),
    // //     .rst_n(rst_n),
    // //     .ce(ce),
    // //     .spike_out(spike_out)
    // // );

    // //SIPO #(.N(2), .M(18752)) SIPO_w (
    // SIPO #(.N(2), .M(total_weight_number)) SIPO_w (
    //     .serial_in(nn_parameters),
    //     .clk(clk),
    //     .rst_n(rst_n),
    //     .ce(fifo_w_ce),
    //     .parallel_out(w)
    // );

    // SIPO #(.N(2), .M(10)) SIPO_beta_shift (
    //     .serial_in(nn_parameters),
    //     .clk(clk),
    //     .rst_n(rst_n),
    //     .ce(fifo_beta_shift_ce),
    //     .parallel_out(beta_shift_SIPO_out)
    // );
    
    // wire [8:0] beta_shift;
    // assign beta_shift = beta_shift_SIPO_out[8:0];

    // SIPO #(.N(2), .M(30)) SIPO_minus_teta (
    //     .serial_in(nn_parameters),
    //     .clk(clk),
    //     .rst_n(rst_n),
    //     .ce(fifo_minus_teta_ce),
    //     .parallel_out(minus_teta)
    // );

    // SIPO #(.N(2), .M(4*106)) SIPO_BN_factor (
    //     .serial_in(nn_parameters),
    //     .clk(clk),
    //     .rst_n(rst_n),
    //     .ce(fifo_BN_factor_ce),
    //     .parallel_out(BN_factor)
    // );

    // SIPO #(.N(2), .M(966)) SIPO_BN_addend (
    //     .serial_in(nn_parameters),
    //     .clk(clk),
    //     .rst_n(rst_n),
    //     .ce(fifo_BN_addend_ce),
    //     .parallel_out(BN_addend)
    // );

    // SIPO #(.N(8), .M(2**input_bits)) SIPO_inputs (
    //     .serial_in(inputs),
    //     .clk(clk),
    //     .rst_n(rst_n),
    //     .ce(fifo_inputs_ce),
    //     .parallel_out(x)
    // );

    // assign outputs = spike_out;

endmodule

`else
module tt_um_neuron 
(
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);
    wire reset = !rst_n;
    assign uio_oe = 0;
    assign uo_out[7:1] = 0;

`ifdef LARGE
    localparam N_STAGES = 5;
`else
    localparam N_STAGES = 2;
`endif
    localparam INPUTS = 2**N_STAGES;
    localparam WEIGHTS = INPUTS;
    localparam OUTPUT_PRECISION = N_STAGES+2;

    //wire [INPUTS-1:0] x = ui_in[INPUTS-1:0];      // # inputs
    wire spike = uo_out[0];
    wire [OUTPUT_PRECISION-1:0] u_out;
                        // uo_out[OUTPUT_PRECISION:1]; // output precision

    reg [INPUTS-1: 0] x;                            // # inputs
    reg [WEIGHTS-1:0] w;                            // # weights
    reg [OUTPUT_PRECISION-1:0] previus_u;           // output precision
    reg [OUTPUT_PRECISION-1:0] minus_teta;          // output precision
    reg [2:0] shift;
    reg was_spike;

    neuron #(.n_stage(N_STAGES)) neuron_uut (
        .w(w),
        .x(x),
        .shift(shift),
        .previus_u(previus_u),
        .minus_teta(minus_teta),
        .was_spike(was_spike),
        .u_out(u_out),
        .is_spike(spike)
    );

    always @(posedge clk) begin
        if (reset) begin
            w <= x; // load weights upon reset
            x <= 0;
            shift <= 0;
            minus_teta <= -5;
            previus_u <= 0;
            was_spike <= 0;
        end else begin
            was_spike <= spike;
            previus_u <= u_out;
`ifdef LARGE
            x <= { x[INPUTS-8-1:0], ui_in[7:0] };
`else
            x <= ui_in[INPUTS-1:0];
`endif
        end
    end

endmodule

`endif