function Lo_V = VOIA(I,A)
% local variance in areas of (2*A+1)*(2*A+1)
% I-input image, A-radius

I = double(I);
[m,n] = size(I);
Lo_V = zeros(m,n);
a = A;
b = A;
M = zeros(2*a+1,2*b+1);

for i = a+1:m-a
    for j = b+1:n-b
        for x = -a:a
            for y = -b:b
                M(x+a+1,y+b+1) = I(i+x,j+y);
                Lo_V(i,j) = var(M(:));
            end
        end
    end
end

