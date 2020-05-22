% ----------
% Author: Wei Tan
% E-mail: twtanwei1992@163.com
% Wei Tan, Huixin Zhou, Jiangluqi Song, Huan Li, Yue Yu, and Juan Du,
% "Infrared and visible image perceptive fusion through multi-level
% Gaussian curvature filtering image decomposition", Applied Optics, 2019,
% Vol. 58, No. 12, pp. 3064-3073.
% This code is only used for research.
% Please cite this publication if you use this code.


clc;
clear all;
close all;

path(path,'GCF')

I1 = imread('Marne_IR.bmp');
I1 = im2double(I1);

I2 = imread('Marne_Vis.bmp');
I2 = im2double(I2);

%% Image Decomposition
[m,n] = size(I1);
FilterType = 2;
Iteration = 5;

[Igcf1_1,energy1] = CF(I1,FilterType,Iteration);
[Igcf2_1,energy2] = CF(I2,FilterType,Iteration);

sigma = 20;
N = 1;

GaussianFilter_1 = fspecial('gaussian',[2*N+1, 2*N+1],sigma);
Ig1_1 = imfilter(I1,GaussianFilter_1,'conv');
Ig2_1 = imfilter(I2,GaussianFilter_1,'conv');

[Igcf1_2,energy3] = CF(Igcf1_1,FilterType,Iteration);
[Igcf2_2,energy4] = CF(Igcf2_1,FilterType,Iteration);

GaussianFilter_2 = fspecial('gaussian',[2*N+1, 2*N+1],sigma);
Ig1_2 = imfilter(Ig1_1,GaussianFilter_2,'conv');
Ig2_2 = imfilter(Ig2_1,GaussianFilter_2,'conv');

[Igcf1_3,energy5] = CF(Igcf1_2,FilterType,Iteration);
[Igcf2_3,energy6] = CF(Igcf2_2,FilterType,Iteration);

GaussianFilter_3 = fspecial('gaussian',[2*N+1, 2*N+1],sigma);
Ig1_3 = imfilter(Ig1_2,GaussianFilter_3,'conv');
Ig2_3 = imfilter(Ig2_2,GaussianFilter_3,'conv');

d1_10 = (I1-Igcf1_1);
d2_10 = (I2-Igcf2_1);
D1_10 = abs(d1_10);
D2_10 = abs(d2_10);

d1_11 = (Igcf1_1-Ig1_1);
d2_11 = (Igcf2_1-Ig2_1);
D1_11 = abs(d1_11);
D2_11 = abs(d2_11);

d1_20 = (Ig1_1-Igcf1_2);
d2_20 = (Ig2_1-Igcf2_2);
D1_20 = abs(d1_20);
D2_20 = abs(d2_20);

d1_21 = (Igcf1_2-Ig1_2);
d2_21 = (Igcf2_2-Ig2_2);
D1_21 = abs(d1_21);
D2_21 = abs(d2_21);

d1_30 = (Ig1_2-Igcf1_3);
d2_30 = (Ig2_2-Igcf2_3);
D1_30 = abs(d1_30);
D2_30 = abs(d2_30);

d1_31 = (Igcf1_3-Ig1_3);
d2_31 = (Igcf2_3-Ig2_3);
D1_31 = abs(d1_31);
D2_31 = abs(d2_31);

B1 = Ig1_3;
B2 = Ig2_3;

%% SF
SF1_20 = SpatialFrequencyA(d1_20,1);
SF2_20 = SpatialFrequencyA(d2_20,1);
SF1_21 = SpatialFrequencyA(d1_21,1);
SF2_21 = SpatialFrequencyA(d2_21,1);
SF1_30 = SpatialFrequencyA(d1_30,1);
SF2_30 = SpatialFrequencyA(d2_30,1);
SF1_31 = SpatialFrequencyA(d1_31,1);
SF2_31 = SpatialFrequencyA(d2_31,1);
SF_B1 = SpatialFrequencyA(B1,1);
SF_B2 = SpatialFrequencyA(B2,1);

% VOI
V1_20 = VOIA(d1_20,1);
V2_20 = VOIA(d2_20,1);
V1_21 = VOIA(d1_21,1);
V2_21 = VOIA(d2_21,1);
V1_30 = VOIA(d1_30,1);
V2_30 = VOIA(d2_30,1);
V1_31 = VOIA(d1_31,1);
V2_31 = VOIA(d2_31,1);
V_B1 = VOIA(B1,1);
V_B2 = VOIA(B2,1);

% Initialization
W1_20 = zeros(m,n);
W1_21 = zeros(m,n);
W1_30 = zeros(m,n);
W1_31 = zeros(m,n);
WB = zeros(m,n);

for i = 1:m
    for j = 1:n
        if (SF1_20(i,j)>SF2_20(i,j) && V1_20(i,j)>V2_20(i,j))
            W1_20(i,j) = 1;
        else
            W1_20(i,j) = 0;
        end
    end
end

for i = 1:m
    for j = 1:n
        if (SF1_21(i,j)>SF2_21(i,j) && V1_21(i,j)>V2_21(i,j))
            W1_21(i,j) = 1;
        else
            W1_21(i,j) = 0;
        end
    end
end

for i = 1:m
    for j = 1:n
        if (SF1_30(i,j)>SF2_30(i,j) && V1_30(i,j)>V2_30(i,j))
            W1_30(i,j) = 1;
        else
            W1_30(i,j) = 0;
        end
    end
end

for i = 1:m
    for j = 1:n
        if (SF1_31(i,j)>SF2_31(i,j) && V1_31(i,j)>V2_31(i,j))
            W1_31(i,j) = 1;
        else
            W1_31(i,j) = 0;
        end
    end
end

for i = 1:m
    for j = 1:n
        if (SF_B1(i,j)>SF_B2(i,j) && V_B1(i,j)>V_B2(i,j))
            WB(i,j) = 1;
        else
            WB(i,j) = 0;
        end
    end
end

for i = 1:m
    for j = 1:n
        if D1_10(i,j)>D2_10(i,j)
            DF_10(i,j) = d1_10(i,j);
        else
            DF_10(i,j) = d2_10(i,j);
        end
    end
end

for i = 1:m
    for j = 1:n
        if D1_11(i,j)>D2_11(i,j)
            DF_11(i,j) = d1_11(i,j);
        else
            DF_11(i,j) = d2_11(i,j);
        end
    end
end

for i = 1:m
    for j = 1:n
        DF_20(i,j) = W1_20(i,j)*d1_20(i,j)+(1-W1_20(i,j))*d2_20(i,j);
    end
end

for i = 1:m
    for j = 1:n
        DF_21(i,j) = W1_21(i,j)*d1_21(i,j)+(1-W1_21(i,j))*d2_21(i,j);
    end
end

for i = 1:m
    for j = 1:n
        DF_30(i,j) = W1_30(i,j)*d1_30(i,j)+(1-W1_30(i,j))*d2_30(i,j);
    end
end

for i = 1:m
    for j = 1:n
        DF_31(i,j) = W1_31(i,j)*d1_31(i,j)+(1-W1_31(i,j))*d2_31(i,j);
    end
end

% Energy
mB1 = mean(B1(:));
mB2 = mean(B2(:));
MB1 = median(B1(:));
MB2 = median(B2(:));
G1 = (mB1+MB1)/2;
G2 = (mB2+MB2)/2;

w1 = zeros(m,n);
w2 = zeros(m,n);
a = 4;
for i = 1:m
    for j = 1:n
        w1(i,j) = exp(a*abs(B1(i,j)-G1));
        w2(i,j) = exp(a*abs(B2(i,j)-G2));
        WB1(i,j) = w1(i,j)/(w1(i,j)+w2(i,j));
        WB2(i,j) = w2(i,j)/(w1(i,j)+w2(i,j));
    end
end


for i = 1:m
    for j = 1:n
        BF(i,j) = WB1(i,j)*B1(i,j)+WB2(i,j)*B2(i,j);
    end
end

F = DF_10+DF_11+DF_20+DF_21+DF_30+DF_31+BF;

figure,imshow(I1);
figure,imshow(I2);
figure,imshow(F);