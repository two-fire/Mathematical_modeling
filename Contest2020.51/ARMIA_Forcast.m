%% 1.��������
close all
clear all
load  value_month_evyear.mat %06~19��ÿ��ƽ��ú��
load yuceprice.mat %ͨ��Ԥ��δ��Ӱ�����ӵ�ֵ�������𲽻ع�õ��ĺ����������ú��Ԥ��ֵ
len =173;
data = v';
%% 2.ƽ���Լ���
% ԭ����
y_h_adf = adftest(data)
y_h_kpss = kpsstest(data)
% һ�ײ�֣����ƽ�ȡ�������ɲ�ƽ�ȵĻ����ٴ����֣�ֱ��ͨ������
Yd1 = diff(data);
yd1_h_adf = adftest(Yd1)
yd1_h_kpss = kpsstest(Yd1)
Y = diff(data);
%% 3.ȷ��ARMAģ�ͽ���
% ACF��PACF����ȷ������
figure
autocorr(Y)
figure
parcorr(Y)
% ͨ��AIC��BIC��׼����ѡ������
%max_ar = 3;
%max_ma = 3;
%[AR_Order,MA_Order] = ARMA_Order_Select(Y,max_ar,max_ma,1);    
AR_Order=2,MA_Order=3
%% 4.�в����
Mdl = arima(AR_Order, 1, MA_Order);  %�ڶ�������ֵΪ1����һ�ײ��
EstMdl = estimate(Mdl,data);
[res,~,logL] = infer(EstMdl,data);   %res���в�

stdr = res/sqrt(EstMdl.Variance);
figure('Name','�в����')
subplot(2,3,1)
plot(stdr)
title('Standardized Residuals')
subplot(2,3,2)
histogram(stdr,10)
title('Standardized Residuals')
subplot(2,3,3)
autocorr(stdr)
subplot(2,3,4)
parcorr(stdr)
subplot(2,3,5)
qqplot(stdr)
% Durbin-Watson ͳ���Ǽ�������ѧ��������õ�����ض���
diffRes0 = diff(res);  
SSE0 = res'*res;
DW0 = (diffRes0'*diffRes0)/SSE0 % Durbin-Watson statistic����ֵ�ӽ�2���������Ϊ���в�����һ������ԡ�
%% 5.Ԥ��
step = 36;
[forData,YMSE] = forecast(EstMdl,step,'Y0',data);   %matlab2019дΪ[forData,YMSE] = forecast(EstMdl,step,data); 
lower = forData - 1.96*sqrt(YMSE); %95������������
upper = forData + 1.96*sqrt(YMSE); %95������������

figure()
plot(data,'Color',[.7,.7,.7]);
hold on
h1 = plot(length(data):length(data)+step,[data(end);lower],'r:','LineWidth',2);
plot(length(data):length(data)+step,[data(end);upper],'r:','LineWidth',2)
h2 = plot(length(data):length(data)+step,[data(end);forData],'k','LineWidth',2);
hold on
legend([h1 h2],'95% ��������','Ԥ��ֵ',...
	     'Location','NorthWest')
yuceprice=imresize(yuceprice,[36 1]);
plot(length(data):length(data)+step-1,yuceprice);
title('Forecast')
hold off