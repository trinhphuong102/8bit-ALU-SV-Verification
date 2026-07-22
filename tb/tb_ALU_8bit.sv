`timescale 1ns/1ps

module tb_ALU_8bit;

logic clk , EN;
logic [3:0] op_code;
logic [7:0] A, B;

logic [15:0] result;
logic carry_flag, zero_flag, overflow_flag;

integer f_in;
integer f_out;
integer status;

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

// Sinh clock chu kỳ 10ns
always #5 clk = ~clk;

initial begin

    clk = 0;
    EN  = 1;

    // Mở file input và file output
    f_in  = $fopen("alu_input.txt","r");
    f_out = $fopen("alu_output.txt","w");

    if(f_in == 0 || f_out == 0) begin
        $display("Khong mo duoc file!");
        $finish;
    end

    // Đọc toàn bộ test vectors
    while(!$feof(f_in)) begin

        status = $fscanf(
            f_in,
            "%h %h %h\n",
            op_code,
            A,
            B
        );

        // Đợi DUT xử lý ở cạnh lên clock
        @(posedge clk);

        // Chờ output ổn định
        #1;

        // Ghi kết quả RTL
        $fwrite(
            f_out,
            "%04h\n",
            result
        );

    end

    $fclose(f_in);
    $fclose(f_out);

    $display("--------------------------------");
    $display("Da chay xong 786432 test cases");
    $display("--------------------------------");

    $finish;

end

endmodule