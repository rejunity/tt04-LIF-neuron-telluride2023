module decay_potential #(parameter n_stage = 10) (
    input [(n_stage+1):0] u,
    input [2:0] shift,
    output [(n_stage+1):0] beta_u
);

    wire [(n_stage+1):0] gamma_u, not_gamma_u, Cout;

    // Assign gamma_u based on shift
    assign gamma_u = (shift == 3'b001) ? u >> 1 :
                     (shift == 3'b010) ? u >> 2 :
                     (shift == 3'b011) ? u >> 3 :
                     (shift == 3'b100) ? u >> 4 :
                     (shift == 3'b101) ? u >> 5 :
                     (shift == 3'b110) ? u >> 6 :
                     (shift == 3'b111) ? u >> 7 :
                     u;

    // Calculate not_gamma_u
    assign not_gamma_u = ~gamma_u;

    // Calculate beta_u using full adder
    genvar i;
    generate
        for (i=0; i<=n_stage+1; i=i+1) begin : adder_i
            if (i == 0) begin : first_ha
                full_adder first_fa_i (
                    .A(u[i]),
                    .B(not_gamma_u[i]),
                    .Cin(1'b1),
                    .S(beta_u[i]),
                    .Cout(Cout[i])
                );
            end else begin : other_fa
                full_adder other_fa_i (
                    .A(u[i]),
                    .B(not_gamma_u[i]),
                    .Cin(Cout[i-1]),
                    .S(beta_u[i]),
                    .Cout(Cout[i])
                );
            end
        end
    endgenerate

endmodule
