clc;
clear all;
%% 读入数据
A = xlsread('美国月度电力终端消费量.xlsx','Monthly Data','B3:B554');
data = A(1:551);
N=length(data);
%% 计算时间序列的标准差，让r从sigma/2到2sigma变化，m从2到5变化，t从1到11变化
sigma=std(data);
max_d=11;
for t=1:max_d
    t
    s_t=0;
    delt_s_s=0;
    for m=2:5
        s_t1=0;
        for j=1:4
            r=sigma*j/2;
            data_d=disjoint(data,N,t);
            [ll,N_d]=size(data_d);
            s_t3=0;
            for i=1:t
                i
                Y=data_d(i,:);
                C_1(i)=correlation_integral(Y,N_d,r);
                X=reconstitution(Y,N_d,m,t);
                N_r=N_d-(m-1)*t;
                C_I(i)=correlation_integral(X,N_r,r);
                s_t3=s_t3+(C_I(i)-C_1(i)^m);
            end
            s_t2(j)=s_t3/t;
            s_t1=s_t1+s_t2(j);
        end
        delt_s_m(m)=max(s_t2)-min(s_t2);
        delt_s_s=delt_s_s+delt_s_m(m);
        s_t0(m)=s_t1;
        s_t=s_t+s_t0(m);
    end
    s(t)=s_t/16;
    delt_s(t)=delt_s_s/4;
    s_cor(t)=delt_s(t)+abs(s(t));
   
end
%画图
t=1:max_d;
subplot(3,1,1);plot(t,s,'b');
ylabel('S(t)');
Y=get(gca,'Ytick');
set(gca,'YTick',0:0.1:0.4);
set(gca,'YTickLabel',{'0','','0.2','','0.4'});
X=get(gca,'Xtick');
set(gca,'XTick',0:1:11);
set(gca,'XTickLabel',{''});
subplot(3,1,2), plot(t,delt_s,'b');
ylabel('ΔS(t)');
Y=get(gca,'Ytick');
set(gca,'YTick',0:0.1:0.4);
set(gca,'YTickLabel',{'0','','0.2','','0.4'});
X=get(gca,'Xtick');
set(gca,'XTick',0:1:11);
set(gca,'XTickLabel',{''});
subplot(3,1,3), plot(t,s_cor,'b');
ylabel('Scor(t)');
Y=get(gca,'Ytick');
set(gca,'YTick',0:0.25:1);
set(gca,'YTickLabel',{'0','','0.5','','1'});
xlabel('延迟量t');
%嵌入维数m=2，时间延迟t=3
%% 求最大Lyapunov指数
lambda_1=lyapunov_wolf(data,N,2,3,10);%P为平均周期，这里设置P为10
%% 求相空间重构后的数据集
X_data = reconstitution(data,N,2,3);
X_data = X_data';