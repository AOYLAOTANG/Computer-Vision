function [F,inliersIndex]=CalF(matchedPoints1,matchedPoints2)
num=sum(matchedPoints1(:,1)>0);
max=-1;
inliersIndex=1:1:num;
for sample=1:1000
    points=0;
    inIndex=1:1:num;
    for i=1:8
        a=randperm(num,1);
        x1(i)=matchedPoints1(a,1);
        y1(i)=matchedPoints1(a,2);
        x2(i)=matchedPoints2(a,1);
        y2(i)=matchedPoints2(a,2);
    end
    
    A=[
        x1(1)*x2(1) x2(1)*y1(1) x2(1) y2(1)*x1(1) y1(1)*y2(1) y2(1) x1(1) y1(1) 1;
        x1(2)*x2(2) x2(2)*y1(2) x2(2) y2(2)*x1(2) y1(2)*y2(2) y2(2) x1(2) y1(2) 1;
        x1(3)*x2(3) x2(3)*y1(3) x2(3) y2(3)*x1(3) y1(3)*y2(3) y2(3) x1(3) y1(3) 1;
        x1(4)*x2(4) x2(4)*y1(4) x2(4) y2(4)*x1(4) y1(4)*y2(4) y2(4) x1(4) y1(4) 1;
        x1(5)*x2(5) x2(5)*y1(5) x2(5) y2(5)*x1(5) y1(5)*y2(5) y2(5) x1(5) y1(5) 1;
        x1(6)*x2(6) x2(6)*y1(6) x2(6) y2(6)*x1(6) y1(6)*y2(6) y2(6) x1(6) y1(6) 1;
        x1(7)*x2(7) x2(7)*y1(7) x2(7) y2(7)*x1(7) y1(7)*y2(7) y2(7) x1(7) y1(7) 1;
        x1(8)*x2(8) x2(8)*y1(8) x2(8) y2(8)*x1(8) y1(8)*y2(8) y2(8) x1(8) y1(8) 1];
    f=null(A,'r');
    F=[
        f(1) f(2) f(3);
        f(4) f(5) f(6);
        f(7) f(8) f(9);
        ];
    %遍历所有特征匹配点根据基本矩阵求极线
    for i=1:num
        m=[matchedPoints1(i,1) matchedPoints1(i,2) 1]';
        l=F*m;
        distant=abs(l(1)*matchedPoints2(i,1)+l(2)*matchedPoints2(i,2)+l(3))/sqrt(l(1)*l(1)+l(2)*l(2));
        if(distant<0.5)
            inIndex(i)=1;
            points=points+1;
        else
            inIndex(i)=0;
        end
    end
    
    if(points>max)
        max=points;
        inliersIndex=inIndex;
    end
end