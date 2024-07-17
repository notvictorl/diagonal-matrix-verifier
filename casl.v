module caslDRPred #(parameter WIDTH = 10, parameter SIZE = 1024)
    (
        input clk, input rst,
        input [WIDTH * SIZE - 1:0] offsets,
        input [WIDTH * SIZE - 1:0] colIdx,
        input [WIDTH - 1:0] numRow, input [WIDTH - 1:0] NNZ,
        output reg flag, output reg done
    );

    reg [WIDTH - 1:0] i;
    reg [SIZE - 1:0] a;
    reg [SIZE - 1:0] b;

    initial begin
        done = 1'b0;
        flag = 1'b1;
        i = 1;
        a = {SIZE{1'b1}};
        b = {SIZE{1'b1}};
    end

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            done <= 0;
            flag <= 1;
            i <= 1;
        end else if (!done) begin
            if (i < numRow) begin
                a[i - 1] = offsets[i * WIDTH +: WIDTH] - offsets[(i - 1) * WIDTH +: WIDTH] == 1;
            end
            if (i < NNZ) begin
                b[i - 1] = colIdx[i * WIDTH +: WIDTH] - colIdx[(i - 1) * WIDTH +: WIDTH] == 1;
            end

            i <= i + 1;

            // if (!(&a && &b)) begin
            //     flag = 0;
            //     done = 1;
            // end

            if (i >= numRow && i >= NNZ) begin
                if (!(&a && &b)) flag = 0;
                done = 1;
            end
        end
    end
endmodule