module multiplier (
    input xi,
    input wi,
    output [1:0] y
);

    assign y[0] = xi;
    assign y[1] = xi & (~wi);

endmodule
