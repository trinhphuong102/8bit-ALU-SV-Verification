module ALU_8bit (
    input clk,
    input EN,
    input [3:0] op_code,
    input [7:0] A, B,

    output reg [15:0] result,
    output reg carry_flag,
    output reg zero_flag,
    output reg overflow_flag
);

reg [16:0] temp; // Thêm 1 bit để lưu carry của phép cộng/trừ

always @(posedge clk) begin
    if (EN) begin

        case(op_code)

            // ===== Arithmetic =====
            4'b0000: temp = A + B;                     // ADD
            4'b0001: temp = A - B;                     // SUB
            4'b0010: temp = A * B;                     // MUL
            4'b0011: temp = (B == 0) ? 17'd0 : A / B; // DIV

            // ===== Logic =====
            4'b0100: temp = A & B;                     // AND
            4'b0101: temp = A | B;                     // OR
            4'b0110: temp = A ^ B;                     // XOR

            // Mở rộng lên 16-bit để tránh sign extension
            4'b0111: temp = {8'b0, ~A};               // NOT

            // ===== Shift A =====
            4'b1000: temp = A << 1;                    // SHL A
            4'b1001: temp = A >> 1;                    // SHR A

            // ===== Shift B =====
            4'b1010: temp = B << 1;                    // SHL B
            4'b1011: temp = B >> 1;                    // SHR B

            default: temp = 17'd0;

        endcase

        result <= temp[15:0];

        // Kết quả bằng 0
        zero_flag <= (temp[15:0] == 16'd0);

        // Carry chỉ có ý nghĩa với ADD và SUB
        if(op_code == 4'b0000 || op_code == 4'b0001)
            carry_flag <= temp[16];
        else
            carry_flag <= 1'b0;

        // Overflow theo quy tắc số bù 2
        if(op_code == 4'b0000) begin
            overflow_flag <=
                (A[7] == B[7]) &&
                (A[7] != temp[7]);
        end
        else if(op_code == 4'b0001) begin
            overflow_flag <=
                (A[7] != B[7]) &&
                (A[7] != temp[7]);
        end
        else begin
            overflow_flag <= 1'b0;
        end

    end
end

endmodule