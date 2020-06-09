clc;
clear all;
%% ��������
A = xlsread('�����¶ȵ����ն�������.xlsx','Monthly Data','B3:B554');
data = A(1:551);
N=length(data);
%% ����ʱ�����еı�׼���r��sigma/2��2sigma�仯��m��2��5�仯��t��1��11�仯
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
%��ͼ
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
ylabel('��S(t)');
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
xlabel('�ӳ���t');
%Ƕ��ά��m=2��ʱ���ӳ�t=3
%% �����Lyapunovָ��
lambda_1=lyapunov_wolf(data,N,2,3,10);%PΪƽ�����ڣ���������PΪ10
%% ����ռ��ع�������ݼ�
X_data = reconstitution(data,N,2,3);
X_data = X_data';