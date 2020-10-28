clear;
close all;
clc;
IL = imread('teddy1.png');
left = rgb2gray(IL);
figure(1),imshow(left);
IR = imread('teddy2.png');
right = rgb2gray(IR);
figure(2),imshow(right);

%图片尺寸高度宽度
[H,W]=size(left);

%窗口半径
N=3;
%最大视差
dmax=0;       %cones
dmin=-60;
%dMax=59;      %teddy
%dMax=15;      %tsukuba
%dMax=19;      %venus

%%
im=zeros(H,W);
e=zeros(1,dmax-1);

B=zeros(2*N+1,2*N+1);
B(:)=1;%全1矩阵
IL=double(left);
IR=double(right);


meansL=conv2(IL,B,'same')/(2*N+1)^2;
meansR=conv2(IR,B,'same')/(2*N+1)^2;

%figure(3),imshow(IL,[]);
%figure(4),imshow(IR,[]);

ncc=zeros(H,W);
nccd=zeros(H,W,dmax);
curmax=zeros(H,W);
depth=zeros(H,W);
for i=1+N:H-N
    for j=1+N:W-N
        for d=dmin:dmax
            if((j+d+N<W)&&(j+d-N>0))
                dif=0;
                difL=0;
                difR=0;
                for m=-N:N
                    for n=-N:N
                        dif=dif+(IL(i+m,j+n)-meansL(i,j))*(IR(i+m,j+n+d)-meansR(i,j+d));
                        difL=difL+(IL(i+m,j+n)-meansL(i,j))^2;
                        difR=difR+(IR(i+m,j+n+d)-meansR(i,j+d))^2;
                    end
                end
                
                temp=dif/sqrt(difL*difR);              
                nccd(i,j,d-dmin+1)=temp;
            end
        end
        
%          [junk,ncc(i,j)]=max(nccd(i,j,:));
%          depth(i,j)=2550/ncc(i,j);
        
    end
end


w = fspecial('gaussian',[5,5],1);
%%
%高斯去噪
for d=dmin:dmax
    nccd(:,:,d-dmin+1)=imfilter(nccd(:,:,d-dmin+1),w,'replicate');
end

%%
for i=1+N:H-N
    for j=1+N:W-N
        curmax(i,j)=max(nccd(i,j,:));
        if (curmax(i,j)<0.5)
            ncc(i,j)=500;
        else
            [junk,ncc(i,j)]=max(nccd(i,j,:));
        end
        
        if(ncc(i,j)>0)
            depth(i,j)=5000/ncc(i,j);
        else
            depth(i,j)=0;
        end
    end
end

%depth=imfilter(depth,w,'replicate');

figure(3),
depth=imfill(depth,'holes');
result=uint8(depth);

imshow(result);
imwrite(result,'result.jpg')