function test2
%ѹ���뵯��ģ�����
a = xlsread('3.xlsx');
format long
x = a(:,1);
y = a(:,2);
p = polyfit(x,y,5)
yfit = polyval(p,x);
val = sum(abs(yfit-y).^2)
plot(x,y,'b-','linewidth',1);
hold on 
plot(x,yfit,'r-','linewidth',1);
xlabel('ѹ��/MPa');
ylabel('���Թ���/MPa');
title('ѹ���뵯��ģ���������');
legend('ԭʼ����','�������')