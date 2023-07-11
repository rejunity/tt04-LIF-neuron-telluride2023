
module tt_neuron (
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

    localparam N_STAGES = 2;
    localparam INPUTS = 2**N_STAGES;
    localparam WEIGHTS = INPUTS;
    localparam OUTPUT_PRECISION = N_STAGES+2;

    wire [INPUTS-1:0] x = ui_in[INPUTS-1:0];        // # inputs
    wire spike = uo_out[0];
    wire [OUTPUT_PRECISION-1:0] u_out =
                        uo_out[OUTPUT_PRECISION:1]; // output precision

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

    always @(posedge clk ) begin
        if (reset) begin
            w <= 1;
            shift <= 1;
            minus_teta <= 5; // max 2^3=8
            previus_u <= 0;
            was_spike <= 0;
        end else begin
            was_spike <= spike;
            previus_u <= u_out;
        end
    end

endmodule

