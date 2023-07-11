module multiplier_stage #(parameter n_stage = 5) (
    input [(2**n_stage)-1:0] w,
    input [(2**n_stage)-1:0] x,
    output [(2*(2**n_stage))-1:0] mult_out
);
    // Generate instances of multiplier for each element in w and x
    genvar i;
    generate
        for (i=0; i<(2**n_stage); i=i+1) begin : mult_i
            multiplier multiplier_uut (
                .xi(x[i]),
                .wi(w[i]),
                .y(mult_out[2*i+1:2*i])
            );
        end
    endgenerate

endmodule
