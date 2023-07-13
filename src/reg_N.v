module reg_N #(parameter N = 16) (
    input [N-1:0] d,
    input clk,
    input rst_n, // active low reset
    input ce,
    output [N-1:0] q
);
    reg [N-1:0] q;

    always @(posedge clk) begin
        if (!rst_n) begin
            q <= 0;
        end else if (ce) begin
            q <= d;
        end
    end

endmodule
