`timescale 1ns/1ps

// a demo to detect a certain series(multiple files are used here just for a demo)
module demo(
        input clk,
        input rst,
        input wire a,
        output reg w
    );

    reg [2:0] buffer; //length of series is 3
    wire result;
    always @(posedge clk) begin
        if(rst) begin
            buffer <= 3'b0;
            w <= 1'b0;
        end
        else begin
            buffer <= {buffer[1:0], a};

            //equals to w <=  (buffer[1] & (~buffer[0]) & a);
            w <= result;
        end
    end

    series u_series(
        .in({buffer[1], buffer[0], a}),
        .out(result)
    );

endmodule
