function data_d=disjoint(data,N,t)

for i=1:t
    for j=1:(N/t)
        data_d(i,j)=data(i+(j-1)*t);
    end
end