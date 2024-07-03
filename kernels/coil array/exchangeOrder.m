% exchange the order of vector and matrix element
% for example, from [b1,b2,b3,b4]' = A[x1,x2,x3,x4]' to
% [b1,b3,b2,b4]' = A1[x1,x3,x2,x4]'
% A1 = exchangeOrder(A)
% input: A - orginal matrix
%        index - index vector
% output: A1 - new matrix
% Mengjia He, 2022.06.21

function A1 = exchangeOrder(A, index)
A1 = zeros(size(A));
A_temp = zeros(size(A));

for i = 1:length(index)
    A_temp(i,:) = A(index(i),:);
end

for i = 1:length(index)
    A1(:,i) = A_temp(:,index(i));
end

end