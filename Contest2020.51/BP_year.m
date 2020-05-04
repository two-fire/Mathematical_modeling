clear; clc;
load factor.mat;
TestSamNum = 11;             % ѧϰ��������
ForcastSamNum = 1;           % Ԥ����������
HiddenUnitNum=8;             % ������
InDim = 4;                   % �����
OutDim = 1;                  % �����
% ԭʼ���� 
p=factor(:,2:5)'; %������
t=factor(:,1)'; %�����
%[SamIn, minp, maxp, tn, mint, maxt] = premnmx(p, t);   % ԭʼ�����ԣ�������������ʼ��
[P,minp,maxp,T,mint,maxt]= premnmx(p,t);
SamIn=P;
SamOut = T;         % �������
MaxEpochs = 50000;   % ���ѵ������
lr = 0.05;           % ѧϰ��
E0 = 1e-3;           % Ŀ�����
rng('default');
W1 = rand(HiddenUnitNum, InDim);      % ��ʼ���������������֮���Ȩֵ
B1 = rand(HiddenUnitNum, 1);          % ��ʼ���������������֮�����ֵ
W2 = rand(OutDim, HiddenUnitNum);     % ��ʼ���������������֮���Ȩֵ              
B2 = rand(OutDim, 1);                 % ��ʼ���������������֮�����ֵ
ErrHistory = zeros(MaxEpochs, 1);     
for i = 1 : MaxEpochs   
    HiddenOut = logsig(W1*SamIn + repmat(B1, 1, TestSamNum));   % �������������
    NetworkOut = W2*HiddenOut + repmat(B2, 1, TestSamNum);      % ������������
    Error = SamOut - NetworkOut;       % ʵ��������������֮��
    SSE = sumsqr(Error);               % �������������ƽ���ͣ�
    ErrHistory(i) = SSE;
    if SSE < E0
        break;
    end
    % ����������BP��������ĵĳ���
    % Ȩֵ����ֵ�����������������ݶ��½�ԭ��������ÿһ����̬������
    Delta2 = Error;
    Delta1 = W2' * Delta2.* HiddenOut.* (1 - HiddenOut);    
    dW2 = Delta2 * HiddenOut';
    dB2 = Delta2 * ones(TestSamNum, 1); 
    dW1 = Delta1 * SamIn';
    dB1 = Delta1 * ones(TestSamNum, 1);
    % ���������������֮���Ȩֵ����ֵ��������
    W2 = W2 + lr*dW2;
    B2 = B2 + lr*dB2;
    % ���������������֮���Ȩֵ����ֵ��������
    W1 = W1 + lr*dW1;
    B1 = B1 + lr*dB1;
end
HiddenOut = logsig(W1*SamIn + repmat(B1, 1, TestSamNum));   % ������������ս��
NetworkOut = W2*HiddenOut + repmat(B2, 1, TestSamNum);      % �����������ս��
a = postmnmx(NetworkOut, mint, maxt);    % ��ԭ���������Ľ��
x = 2006 : 2016;      % ʱ����̶�
newk = a(1, :);       % ��������۸�

plot(x, newk, 'r-o', x, t, 'b--+');
legend('��������۸�', 'ʵ�ʼ۸�');
xlabel('���');
ylabel('�۸�');
% ����ѵ���õ��������Ԥ��
pnew=[27093.3 28189 
    385723.25 273760
    352356.2 365600
    13.8 14];  % 2010���2011���������ݣ�
pnewn = tramnmx(pnew, minp, maxp); 
HiddenOut = logsig(W1*pnewn + repmat(B1, 1, ForcastSamNum));  % ���������Ԥ����
anewn = W2*HiddenOut + repmat(B2, 1, ForcastSamNum);          % ��������Ԥ����
anew = postmnmx(anewn, mint, maxt);
disp('Ԥ��ֵd��');
disp(anew);