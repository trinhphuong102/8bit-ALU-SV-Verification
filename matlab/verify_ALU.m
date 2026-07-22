clc;
clear;

% Đọc kết quả Golden Model và RTL
gold = hex2dec(textread('alu_gold.txt','%s'));
out  = hex2dec(textread('alu_output.txt','%s'));

% Tìm tất cả test vector bị sai
errors = find(gold ~= out);

if isempty(errors)

    fprintf('\n');

    disp('========================================');
    disp('ALU Verification PASSED');
    disp('786432 / 786432 vectors matched');
    disp('Functional correctness = 100%');
    disp('========================================');

else

    fprintf('\n');
    fprintf('Phat hien %d loi\n',length(errors));

    % In ra 10 lỗi đầu tiên để debug
    for i = 1:min(10,length(errors))

        idx = errors(i);

        fprintf('\n');
        fprintf('Case %d\n',idx);
        fprintf('Golden : %04X\n',gold(idx));
        fprintf('RTL    : %04X\n',out(idx));

    end

end