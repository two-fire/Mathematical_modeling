%% 求关联度。动态过程发展态势的量化比较分析
clc,clear 
load yingxiang.txt   %把原始数据存放在纯文本文件
x=yingxiang
for i=1:7
    x(i,:)=x(i,:)/x(i,1);   %标准化数据 
end
data=x;
n=size(data,2); %求矩阵的列数，即观测时刻的个数
ck=data(1,:);  %提出参考数列
bj=data(2:end,:); %提出比较数列
m2=size(bj,1); %求比较数列的个数 
for j=1:m2       
    t(j,:)=bj(j,:)-ck;
end
mn=min(min(abs(t')));  %求小差 
mx=max(max(abs(t')));  %求大差 
rho=0.5;  %分辨系数设置
ksi=(mn+rho*mx)./(abs(t)+rho*mx);  %求关联系数
r=sum(ksi')/n  %求关联度
[rs,rind]=sort(r,'descend')   %对关联度进行排序
bar(1:6,rs); %根据rind对下标设值
x_change={	'国际价格'	'煤炭产量' '平均气温' '上下游产品价格' '全国铁路煤炭发运量' '新增产能'};
set (gca,'xticklabel',x_change);
xlabel('影响因素');
ylabel('关联度');