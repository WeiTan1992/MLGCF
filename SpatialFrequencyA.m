function SF = SpatialFrequencyA(I,A)
% compute 1-neighbourhood spatial frequency
% SF - the spatial frequency of the image
% I - the input image
% A - radii

% TAN Wei,
% Xidian University
% Author: TAN Wei <twtanwei1992@163.com>
% Address: No. 2 South Taibai Road, Xi'an, Shaanxi 710071
I = double(I);
[m,n] = size(I);
RF = zeros(m,n);
CF = zeros(m,n);
SF = zeros(m,n);
a = A;
b = A;


for i = a+1:m-a-1
    for j = b+1:n-b-1
        for x = -a:a
            for y = -b:b
                RF(i,j) = sqrt(sum((I(i+x,j+y+1)-I(i+x,j+y))^2))/(2*a+1);
                CF(i,j) = sqrt(sum((I(i+x+1,j+y)-I(i+x,j+y))^2))/(2*b+1);
                SF(i,j) = sqrt(RF(i,j)^2+CF(i,j)^2);
            end
        end
    end
end

