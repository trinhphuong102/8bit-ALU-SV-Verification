clc;
clear;

fid_in   = fopen('alu_input.txt','w');
fid_gold = fopen('alu_gold.txt','w');

% 12 operations × 256 × 256 test vectors
for op = 0:11
    for A = 0:255
        for B = 0:255

            % Ghi input cho RTL testbench
            fprintf(fid_in,'%1x %02x %02x\n',op,A,B);

            % Golden Model độc lập
            switch op

                case 0      % ADD
                    gold = A + B;

                case 1      % SUB
                    gold = mod(A - B,65536);

                case 2      % MUL
                    gold = A * B;

                case 3      % DIV
                    if B == 0
                        gold = 0;
                    else
                        gold = floor(A/B);
                    end

                case 4      % AND
                    gold = bitand(A,B);

                case 5      % OR
                    gold = bitor(A,B);

                case 6      % XOR
                    gold = bitxor(A,B);

                case 7      % NOT
                    gold = bitxor(A,255);

                case 8      % SHL A
                    gold = bitshift(A,1);

                case 9      % SHR A
                    gold = bitshift(A,-1);

                case 10     % SHL B
                    gold = bitshift(B,1);

                case 11     % SHR B
                    gold = bitshift(B,-1);

            end

            % Giới hạn về 16 bit giống RTL
            gold = bitand(gold,65535);

            fprintf(fid_gold,'%04X\n',gold);

        end
    end
end

fclose(fid_in);
fclose(fid_gold);

disp('Da tao xong 786432 test vectors!');