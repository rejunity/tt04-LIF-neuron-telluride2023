module SIPO #(
    parameter N = 4,
    parameter M = 64
)
(
    input [N-1:0] serial_in,
    input clk,
    input rst_n,
    input ce,
    output [M-1:0] parallel_out
);
    wire [M-1:0] x;

    genvar i;
    generate
        for (i = 0; i < M/N; i = i + 1) begin : SH_REG
            if (i == 0) begin : first_reg
                reg_N #(N) r (
                    .d(serial_in),
                    .clk(clk),
                    .rst_n(rst_n),
                    .ce(ce),
                    .q(x[N-1:0])
                );
            end else begin : other_regs
                reg_N #(N) r (
                    .d(x[(i*N)-1:((i-1)*N)]),
                    .clk(clk),
                    .rst_n(rst_n),
                    .ce(ce),
                    .q(x[((i+1)*N)-1:(i*N)])
                );
            end
        end
    endgenerate

    assign parallel_out = x;

endmodule
