module adder_tree #(parameter n_stage = 5) (
    input [(2*(2**n_stage))-1:0] wx,
    output [(n_stage+1):0] y_out
);
    localparam OUTPUTS_PER_STAGE = 2*(n_stage+2)*(2**(n_stage-1)-1);
    wire [n_stage*OUTPUTS_PER_STAGE-1:0] s_out;

    // Generate stages of adders
    generate
        genvar i, j;
        for (i=1; i<=n_stage; i=i+1) begin : stage_i
            if (i == 1) begin : first_stage
                for (j=1; j<=(2**(n_stage-1)); j=j+1) begin : adders_j
                    nbit_adder #(i+1) adders_i (
                        .A(wx[(2*(i+1)*(j-1))+i:
                               2*(i+1)*(j-1)]),
                        .B(wx[(2*(i+1)*(j-1))+(2*(i+1))-1:
                               2*(i+1)*(j-1)+i+1]),
                        .S(s_out[(i-1)*OUTPUTS_PER_STAGE+((i+2)*(j-1))+(i+2)-1:
                                 (i-1)*OUTPUTS_PER_STAGE+((i+2)*(j-1))])
                    );
                end
            end else begin : other_stages
                for (j=1; j<=(2**(n_stage-i)); j=j+1) begin : adders_j
                    nbit_adder #(i+1) adders_i (
                        .A(s_out[(i-2)*OUTPUTS_PER_STAGE+(2*(i+1)*(j-1))+i:
                                 (i-2)*OUTPUTS_PER_STAGE+(2*(i+1)*(j-1))]),
                        .B(s_out[(i-2)*OUTPUTS_PER_STAGE+(2*(i+1)*(j-1))+(2*(i+1))-1:
                                 (i-2)*OUTPUTS_PER_STAGE+(2*(i+1)*(j-1))+i+1]),
                        .S(s_out[(i-1)*OUTPUTS_PER_STAGE+((i+2)*(j-1))+(i+2)-1:
                                 (i-1)*OUTPUTS_PER_STAGE+((i+2)*(j-1))])
                    );
                end
            end
        end
    endgenerate

    assign y_out = s_out[(n_stage-1)*OUTPUTS_PER_STAGE+n_stage+1:
                         (n_stage-1)*OUTPUTS_PER_STAGE+0];

endmodule
