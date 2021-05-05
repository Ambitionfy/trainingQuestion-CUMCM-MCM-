function test6

q = zeros(245,59);%30��������
w = zeros(245,59);%25��������
x_flag = 0;
for m = 0.6:0.1:25
   x_flag = x_flag + 1;
   y_flag = 0;
   for n = 0.6:0.1:6.4 
        y_flag = y_flag + 1;
        qq = getq3(m,n);
        q(x_flag,y_flag) = qq(1801);
        w(x_flag,y_flag) = qq(1501);
   end
end
m = 0.6:0.1:25;
n = 0.6:0.1:6.4;
[mm,nn] = meshgrid(m,n);
figure(1)
mesh(mm',nn',q);
title('����30����ʱ��������¶�');
xlabel('II����/mm');
ylabel('IV����/mm');
zlabel('����30����ʱ��������¶�/���϶�');
figure(2)
mesh(mm',nn',w)
title('����25����ʱ��������¶�');
xlabel('II����/mm');
ylabel('IV����/mm');
zlabel('����25����ʱ��������¶�/���϶�');