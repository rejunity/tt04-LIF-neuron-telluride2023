module mulplier_accumulator #(parameter n_stage = 6) (
    input [(2**n_stage)-1:0] w,
    input [(2**n_stage)-1:0] x,
    output [(n_stage+1):0] y_out
);

    wire [(2*(2**n_stage))-1:0] mult_out;

    multiplier_stage #(n_stage) mult_uut (
        .w(w),
        .x(x),
        .mult_out(mult_out)
    );

    adder_tree #(n_stage) adder_uut (
        .wx(mult_out),
        .y_out(y_out)
    );

endmodule
