clear;
close all;
clc;
Il = imread('test2.png');
figure(1),imshow(Il);
left = rgb2gray(Il);
Ir = imread('test1.png');
figure(2),imshow(Ir);
right = rgb2gray(Ir);

%图片尺寸高度宽度
[H,W]=size(left);

%窗口半径
N=1;
%最大视差
dMax=59;       %cones
%dMax=59;      %teddy
%dMax=15;      %tsukuba
%dMax=19;      %venus

%%
im=zeros(H,W);
e=zeros(1,dMax-1);

B=zeros(2*N+1,2*N+1);
B(:)=1;%全1矩阵
Il=left;
Ir=right;

Ir2=Ir.^2;
Il2=Il.^2;

D2=conv2(Il2,B,'valid');
D3=conv2(Ir2,B,'valid'); %卷积

[H1,W1]=size(D2);
e=zeros(H1,W1);
NCCD=zeros(H1,W1,dMax-1);

for k=1:1:dMax
    IlIr=Il(1:H,1+dMax:W).*Ir(1:H,1+dMax-k:W-k); % Il(i,j)*Ir(i,j-k),大小为H*W-dMax（1：H,1+dMax:W）
    D1=conv2(IlIr,B,'valid');
    
    for i=1:H1
        for j=1+dMax:W1
     
           nCCD=D1(i,j-dMax)/sqrt(D2(i,j)*D3(i,j-k));
           e(i,j)=nCCD;
        end
   end
   NCCD(:,:,k)=e;
end

for i=1:H1
    for j=1:W1
        [junk,im(i,j)]=max(NCCD(i,j,:));
    end
end
imgn=zeros(H,W);
imgn(1+N:H-N,1+dMax+N:W1+N)=im(1:H1,1+dMax:W1);
imgn=medfilt1(imgn,5);
%%
% 根据匹配图片需要修改
imgn=4*imgn;   %cones
%imgn=4*imgn;  %teddy
%imgn=16*imgn; %tsukuba
%imgn=8*imgn;  %venus
figure(3),
imshow(imgn,[]);
imwrite(imgn/255,'result.jpg')