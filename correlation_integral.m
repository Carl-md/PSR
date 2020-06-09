function C_I=correlation_integral(X,M,r)

sum_H=0;
for i=1:M

    for j=i+1:M
        d=norm((X(:,i)-X(:,j)),inf);
        sita=heaviside(r,d);
        sum_H=sum_H+sita;
    end
end
C_I=2*sum_H/(M*(M-1));