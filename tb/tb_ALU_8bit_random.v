`timescale 1ns/1ps

module tb_ALU_8bit_random;

reg clk;
reg EN;
reg [3:0] op_code;
reg [7:0] A;
reg [7:0] B;

wire [15:0] result;
wire carry_flag;
wire zero_flag;
wire overflow_flag;

integer i, j;

ALU_8bit dut(
    .clk(clk),
    .EN(EN),
    .op_code(op_code),
    .A(A),
    .B(B),
    .result(result),
    .carry_flag(carry_flag),
    .zero_flag(zero_flag),
    .overflow_flag(overflow_flag)
);


always #5 clk = ~clk;

initial begin

    clk = 0;
    EN  = 1;

    $display("==============================================");
    $display("     RANDOM TEST FOR 8-BIT ALU");
    $display("==============================================");

    // Chạy từng opcode
    for(op_code = 0; op_code < 12; op_code = op_code + 1) begin

        $display("\n------------------------------------------");
        $display("Opcode = %0d", op_code);
        $display("------------------------------------------");

        // 15 testcase ngẫu nhiên
        for(i = 0; i < 15; i = i + 1) begin

            A = $random;
            B = $random;

            @(posedge clk);
            #1;

            $display(
                "Test=%02d | A=%02h B=%02h | Result=%04h | C=%b Z=%b V=%b",
                i+1,
                A,
                B,
                result,
                carry_flag,
                zero_flag,
                overflow_flag
            );

        end

    end

    $display("\n==============================================");
    $display("Random Simulation Finished");
    $display("==============================================");

    $finish;

end

endmodule