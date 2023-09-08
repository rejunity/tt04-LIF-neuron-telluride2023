//`define LARGE_NEURON

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
    assign uio_oe[7:0] = 8'b0000_0000;
    assign uio_out[7:0] = 8'b0000_0000;
    assign uo_out[7:1] = 7'b000_0000;

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

endmodule

module tt_um_rejunity_telluride2023_neuron
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
    assign uio_oe[7:0] = 8'b0000_0000;
    assign uio_out[7:0] = 8'b0000_0000;
    assign uo_out[7:1] = 7'b000_0000;

`ifdef LARGE_NEURON
    localparam N_STAGES = 5;
`else
    localparam N_STAGES = 3;
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
`ifdef LARGE_NEURON
            x <= { x[INPUTS-8-1:0], ui_in[7:0] };
`else
            x <= ui_in[INPUTS-1:0];
`endif
        end
    end

endmodule
