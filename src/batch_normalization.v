module batch_normalization
#(
    parameter n_stage = 2
)
(
    input [(n_stage+1):0] BN_u_in,
    input [3:0] BN_factor,
    input [(n_stage+1):0] BN_addend,
    output [(n_stage+1):0] BN_u_out
);

    wire [(n_stage+1):0] shift_1_out, shift_2_out, adder2_in;
    wire[(n_stage+2):0] adder1_out, adder2_out;

    assign shift_1_out =    (BN_factor[1:0] == 2'b01) ? BN_u_in >> 1 :
                            (BN_factor[1:0] == 2'b10) ? BN_u_in << 1 :
                            (BN_factor[1:0] == 2'b11) ? BN_u_in << 3 :
                            0;


    assign shift_2_out =    (BN_factor[3:2] == 2'b01) ? BN_u_in :
                            (BN_factor[3:2] == 2'b10) ? BN_u_in >> 2 :
                            (BN_factor[3:2] == 2'b11) ? BN_u_in << 2 :
                            0;

    // Calculate adder_1: shift_1_out + shift_2_out
    nbit_adder #(n_stage+2) adder_1 (
        .A(shift_1_out),
        .B(shift_2_out),
        .S(adder1_out)
    );

    assign adder2_in = adder1_out[(n_stage+1):0];

    // Calculate adder_2: BN_addend + adder2_in
    nbit_adder #(n_stage+2) adder_2 (
        .A(BN_addend),
        .B(adder2_in),
        .S(adder2_out)
    );

    assign BN_u_out = adder2_out[(n_stage+1):0];

endmodule

