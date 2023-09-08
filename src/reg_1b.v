module reg_1b (
    input d,
    input clk,
    input rst_n, // active low reset
    input ce,
    output reg q
);
    always @(posedge clk) begin
        if (!rst_n) begin
            q <= 0;
        end else if (ce) begin
            q <= d;
        end
    end

endmodule
