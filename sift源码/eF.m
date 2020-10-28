function [F,inliersIndex]=eF(matchedPoints1,matchedPoints2)

number=sum(matchedPoints1(:,1)>0);

flag=-1;

inliersIndex=1:1:number;
for n=1:1000
    numIndex=0;
    inIndex=1:1:number;
    x1 = 1:8;
    x2 = 1:8;
    y1 = 1:8;
    y2 = 1:8;
    for i=1:8
        a=randi(number-1);
        a = a + 1;
        x1(i)=matchedPoints1(a,1);x2(i)=matchedPoints2(a,1);
        y1(i)=matchedPoints1(a,2);y2(i)=matchedPoints2(a,2);
    end
    A = zeros(8, 9);
    for i=1:8
        A(i,:) = [x1(i)*x2(i) x2(i)*y1(i) x2(i) y2(i)*x1(i) y1(i)*y2(i) y2(i) x1(i) y1(i) 1];
    end

    f=null(A,'r');
    F=[ f(1) f(2) f(3);
        f(4) f(5) f(6);
        f(7) f(8) f(9); ];
    for i=1:number
        m=[matchedPoints1(i,1) matchedPoints1(i,2) 1]';
        l=F*m;
        d=abs(l(1)*matchedPoints2(i,1)+l(2)*matchedPoints2(i,2)+l(3))/sqrt(l(1)*l(1)+l(2)*l(2));
        if(d<0.3)
            inIndex(i)=1;
            numIndex=numIndex+1;
        else
            inIndex(i)=0;
        end
    end
    if(numIndex>flag)
        flag=numIndex;
        inliersIndex=inIndex;
    end
end