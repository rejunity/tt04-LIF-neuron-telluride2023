module neuron_struct #(parameter n_stage = 4) (
    input [(2**n_stage)-1:0] w,
    input [(2**n_stage)-1:0] x,
    input [2:0] shift,
    input [(n_stage+1):0] minus_teta,
    input [3:0] BN_factor,
    input [(n_stage+1):0] BN_addend,
    input clk,
    input rst_n,
    input ce,
    output reg spike_out
);

    reg [n_stage+1:0] previus_u;
    reg [n_stage+1:0] u_out;
    reg is_spike;
    reg was_spike;

    neuron #(n_stage) neuron_uut (
        .w(w),
        .x(x),
        .shift(shift),
        .previus_u(previus_u),
        .minus_teta(minus_teta),
        .was_spike(was_spike),
        .BN_factor(BN_factor),
        .BN_addend(BN_addend),
        .u_out(u_out),
        .is_spike(is_spike)
    );

    always @(posedge clk) begin
        if (~rst_n) begin
            was_spike <= 0;
            previus_u <= 0;
            spike_out <= 0;
        end else begin
            was_spike <= is_spike;
            previus_u <= u_out;
            spike_out <= was_spike;
        end
    end

endmodule
