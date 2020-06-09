function X=reconstitution(data,N,m,tau)

M=N-(m-1)*tau;
for j=1:M          
    for i=1:m
        X(i,j)=data((i-1)*tau+j);
    end
end
