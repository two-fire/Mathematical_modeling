clc,clear 
load yuce.txt   %ԭʼ�������������ķ�ʽ����ڴ��ı��ļ��� 
yt=yuce; 
n=length(yt); 
alpha=0.3; 
st1(1)=yt(1); 
st2(1)=yt(1); 
for i=2:n     
    st1(i)=alpha*yt(i)+(1-alpha)*st1(i-1);    
    st2(i)=alpha*st1(i)+(1-alpha)*st2(i-1); 
end 
xlswrite('pinghua2Ԥ��.xls',[st1',st2'],'Sheet1','A1') 
a=2*st1-st2 
b=alpha/(1-alpha)*(st1-st2) 
yhat=a+b; 
xlswrite('fadian.xls',yhat','Sheet1','C2') 

plot(1:n,yt,'*',1:n,yhat(1:n),'O') 
legend('ʵ��ֵ','Ԥ��ֵ') 


