%% ������ȡ���̬���̷�չ̬�Ƶ������ȽϷ���
clc,clear 
load yingxiang.txt   %��ԭʼ���ݴ���ڴ��ı��ļ�
x=yingxiang
for i=1:7
    x(i,:)=x(i,:)/x(i,1);   %��׼������ 
end
data=x;
n=size(data,2); %���������������۲�ʱ�̵ĸ���
ck=data(1,:);  %����ο�����
bj=data(2:end,:); %����Ƚ�����
m2=size(bj,1); %��Ƚ����еĸ��� 
for j=1:m2       
    t(j,:)=bj(j,:)-ck;
end
mn=min(min(abs(t')));  %��С�� 
mx=max(max(abs(t')));  %���� 
rho=0.5;  %�ֱ�ϵ������
ksi=(mn+rho*mx)./(abs(t)+rho*mx);  %�����ϵ��
r=sum(ksi')/n  %�������
[rs,rind]=sort(r,'descend')   %�Թ����Ƚ�������
bar(1:6,rs); %����rind���±���ֵ
x_change={	'���ʼ۸�'	'ú̿����' 'ƽ������' '�����β�Ʒ�۸�' 'ȫ����·ú̿������' '��������'};
set (gca,'xticklabel',x_change);
xlabel('Ӱ������');
ylabel('������');