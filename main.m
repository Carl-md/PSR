%% 样本集
B(:,1) = A(5:end,1);
B(:,2:3) = X_data(:,1:2);
[X,ps] = mapminmax(B',0,1);
X = X';
Xte = X(477:end,2:end);
Yte = X(477:end,1);
r = randperm(476);
Xtr = X(r(1:476),2:end);
Ytr = X(r(1:476),1);
%% 构建RF模型
rng(1)
Md1 = fitrensemble(Xtr,Ytr,'OptimizeHyperparameters','auto',...
    'HyperparameterOptimizationOptions',struct('AcquisitionFunctionName',...
    'expected-improvement-plus'));
Yfit = predict(Md1,Xte);
%预测结果反归一化
Y_fit = mapminmax('reverse',Yfit',ps);
Y_fit = Y_fit';
yfit = Y_fit(:,1);
%% 评价指标
RMSE = sqrt(sum((B(477:end,1)-yfit).^2))/72;
MAE = sum(abs(B(477:end,1)-yfit))/72;
%% 画图
figure(1)
plot(B(477:end,1));
hold on
plot(yfit);
legend('实际值','预测值');
title('预测结果对比','fontsize',12);
ylabel('用电量/mWh','fontsize',12);
xlabel('时间/月','fontsize',12);
%% 提取误差
error = B(477:end,1)-yfit;