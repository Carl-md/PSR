%% ������
B(:,1) = A(5:end,1);
B(:,2:3) = X_data(:,1:2);
[X,ps] = mapminmax(B',0,1);
X = X';
Xte = X(477:end,2:end);
Yte = X(477:end,1);
r = randperm(476);
Xtr = X(r(1:476),2:end);
Ytr = X(r(1:476),1);
%% ����RFģ��
rng(1)
Md1 = fitrensemble(Xtr,Ytr,'OptimizeHyperparameters','auto',...
    'HyperparameterOptimizationOptions',struct('AcquisitionFunctionName',...
    'expected-improvement-plus'));
Yfit = predict(Md1,Xte);
%Ԥ��������һ��
Y_fit = mapminmax('reverse',Yfit',ps);
Y_fit = Y_fit';
yfit = Y_fit(:,1);
%% ����ָ��
RMSE = sqrt(sum((B(477:end,1)-yfit).^2))/72;
MAE = sum(abs(B(477:end,1)-yfit))/72;
%% ��ͼ
figure(1)
plot(B(477:end,1));
hold on
plot(yfit);
legend('ʵ��ֵ','Ԥ��ֵ');
title('Ԥ�����Ա�','fontsize',12);
ylabel('�õ���/mWh','fontsize',12);
xlabel('ʱ��/��','fontsize',12);
%% ��ȡ���
error = B(477:end,1)-yfit;