function  test5
clear
clc
% for mm = 0.6 : 0.1 : 25
%    q = getq2(mm);
%    if (q(3601) < 47) && (q(3301) < 44)
%        l2 = mm;
%        break;
%    end
% end
% for x = 0.6 : 0.1 : 25
%     q1 = getq2(x);
%     time = q1(find(q1 > 44));
%     if sum(time) == 0
%        time = 0;
%     else
%         time = time(1);
%     end
%     temp = [x q1(3601) time];
%     q = [q;temp];
% end
%%ͼ
q = [];
for x = 0.6 : 0.1 : 25
    q1 = getq2(x);
    temp = [x q1(3601) q1(3301)];
    q = [q;temp];
end
x = 0.6 : 0.1 : 25;
w = q(:,2);
e = q(:,3);
figure(1)
plot(x,w);
title('����60����ʱ������Ƥ������¶�');
hold on 
plot(x,47*ones(size(x)));
figure(2)
plot(x,e);
xlabel('II��ĺ��/mm')
ylabel('�¶�/���϶�')
title('����55����ʱ������Ƥ������¶�');
hold on
plot(x,44*ones(size(x)));
xlabel('II��ĺ��/mm')
ylabel('�¶�/���϶�')
%%��
q = [];
for x = [0.6 6 10 13 16 20 22 25]
    q1 = getq2(x);
    temp = [x q1(3601) q1(3301)];
    q = [q;temp];
end
q
