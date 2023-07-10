
module tt_um_neuron (
    input wire               clk,
    input wire               rst_n,
    input wire [5:0]         in_current,
    input wire               ena,
    output reg               spike
);

    reg  [5:0] state, threshold;
    wire [5:0] state_hist;
    wire reset = ! rst_n;

    assign state_hist = in_current + (spike ? 0 : (state >> 1)); // scale by 1/2


    // to-do: check for overflow
    always @(posedge clk) begin
        if (reset) begin
            threshold <= 32;
            state <= 0;
            spike <= 0;
        end else begin
            state <= state_hist;
            spike <= (state >= threshold);

        end
    end

endmodule

// module lif (
//     input wire [5:0] in_current, // 4-b Current input
//     input wire       clk, // clock
//     input wire       rst_n, // reset_n - low to reset
//     output reg [6:0] out_state,
//     output reg       out_spike
// );

//     wire reset = ! rst_n;

//     parameter THRESHOLD = 7'b100000
//     parameter LEAK_RATE = 7'b000001
    

    
//     always @(posedge clk) begin
//         // if reset, set state to 0
//         if (reset) begin
//             out_state <= 0;
//         end else begin
//             if (out_spike > THRESHOLD) begin
//                 out_state <= 0;
//                 out_spike <= 1;
//             end else
//                 out_state <= out_state - LEAK_RATE
//                 out_spike <= 0;

//     end

// endmodule


// module seg7 (
//     input wire [3:0] counter,
//     output reg [6:0] segments
// );

//     always @(*) begin
//         case(counter)
//             //                7654321
//             0:  segments = 7'b0111111;
//             1:  segments = 7'b0000110;
//             2:  segments = 7'b1011011;
//             3:  segments = 7'b1001111;
//             4:  segments = 7'b1100110;
//             5:  segments = 7'b1101101;
//             6:  segments = 7'b1111100;
//             7:  segments = 7'b0000111;
//             8:  segments = 7'b1111111;
//             9:  segments = 7'b1100111;
//             default:    
//                 segments = 7'b0000000;
//         endcase
//     end

// endmodule

