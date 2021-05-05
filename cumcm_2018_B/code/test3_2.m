function test3_2
clear
clc
global cnc_pos
N = 1e3;
mm = 0;
mmm = 0;
for m = 1 : N
%���ݶ���
%tmove -- RGV�ƶ�ʱ��
%tprocess -- CNC�ӹ�ʱ��
%tud -- ������ʱ��
%tclean -- ��ϴʱ��
cnc_pos = [1 1 2 2 3 3 4 4];%cnc��Ӧλ��
way = 1;%ѡ�õڼ�������
break_idx = [];
break_start = [];
break_end = [];
breakall = [];
switch way
    case 1
        tmove = [20 33 46];
        tprocess1 = 400;
        tprocess2 = 378;
        tud = repmat([28 31],1,4);
        tclean = 25;
        order1 = [1 5 8 3];
        num = 4;
    case 2
        tmove = [23 41 59];
        tprocess1 = 280;
        tprocess2 = 500;
        tud = repmat([30 35],1,4);
        tclean = 30;
        order1 = [1 7 5];
        num = 3;
    case 3
        tmove = [18 32 46];
        tprocess1 = 455;
        tprocess2 = 182;
        tud = repmat([27 32],1,4);
        tclean = 25;
        order1 = [1 8 4 6 7 2];
        num = 6;
end
target = 300;%���Ŀ������
   %˼·���ȼ����һ�֣��ټ������һ���ϴ��Ŀ��
   %����ʱ��ʱ�䣬������order�ھ��У�����minѡ����С��
   
queue1 = [];%����1�ȴ�ָ�����
queue2 = [];%����2�ȴ�ָ�����
rgv_pos = 1; %С����Ӧλ��
cnc_now = zeros(1,8);%��ǰ�ӹ���
cnc_endtime = zeros(1,8);%��ǰ�ӹ��Ľ���ʱ��
cnc_assign = 2*ones(1,8);%cnc����Ĺ���
cnt = 0;%��ǰ�ӹ���
cnt_finish = 0;%��ȫ�ӹ���
time = 0;
result = zeros(target,8);
%��Ž�������Ϻš�����1cnc��š����Ͽ�ʼʱ�䡢���Ͽ�ʼʱ�䡢
%����2cnc��š����Ͽ�ʼʱ�䡢���Ͽ�ʼʱ�䡢����ʱ��

for i = 1 : num
  cnc_assign(order1(i)) = 1; 
  %����cnc������
end

%��һ��
for i = 1 : num
   pos = cnc_pos(order1(i));%�ҳ���ǰ��ȥ��cncλ��
   if pos == rgv_pos
      result(i,1) = i;
      result(i,2) = order1(i);
      result(i,3) = time; %�����ƶ���ֱ������
      time = time + tud(order1(i));%����ʱ��
      cnc_endtime(order1(i)) = time + tprocess1;%��¼��cnc���ʱ��
      cnc_now(order1(i)) = i;%��cnc��ǰ�ڼӹ���i������
   else
       distance = abs(pos - rgv_pos);%����λ�ò�
       time = time + tmove(distance);%����ʱ��
       result(i,1) = i;
       result(i,2) = order1(i);
       result(i,3) = time; %�ƶ�ʱ���Ѹ���
       time = time + tud(order1(i));%��������ʱ��
       cnc_endtime(order1(i)) = time + tprocess1;
       cnc_now(order1(i)) = i;
   end
   rgv_pos = pos;%����С��λ��
end
cnt = num;%����cnt
%�ڶ���
%���� -- 
%���Ϻ�����ͬʱ����
flag = 1;%ִ�й��� -- 1/2
hold = 1;%���ְ��Ʒ�Ĺ���

while cnt_finish < target
   if time >= 8*3600
        break;
   end
   
	xtemp = [];
    for i = 1 : length(break_idx)
        if time >= break_start(i) && time <= break_end(i)
           cnc_now(break_idx(i)) = 0;%��ǰ�ӹ��ı�����
           cnc_endtime(break_idx(i)) = 9999999;
        elseif time >= break_end(i)
            cnc_endtime(break_idx(i)) = time;
            xtemp = [xtemp,i];
        end
    end
    break_start(xtemp) = [];
    break_end(xtemp) = [];
    break_idx(xtemp) = [];
   
   if time < min(cnc_endtime(cnc_assign == flag)) %���еĶ����ڹ���
       time = min(cnc_endtime(cnc_assign == flag));%ʱ������ȥ
       continue;
   else
       [queue1,queue2] = check(time,cnc_endtime,cnc_assign);%��ȡ��ɵĶ���
       if flag == 1%��һ��Ҫ�����ǹ���1
           [idx,dis] = getClosest(rgv_pos,queue1);%��ȡ�����������cnc�;���
           if dis > 0 %�����Ҫ�ƶ�
              time = time + tmove(dis);%����ʱ�� 
              rgv_pos = cnc_pos(idx);
           end
           %������ + �ӹ���ϴ
           temp = cnc_now(idx);%��ȡ��ǰcnc�ӹ���ϵĻ�����
           if temp == 0
                cnt = cnt + 1; % ȡһ���µ�����
                result(cnt,1) = cnt;
                result(cnt,2) = idx;
                result(cnt,3) = time;
                time = time + tud(idx); % �����ϲ���ʱ������
                cnc_now(idx) = cnt; %���¼ӹ��������
                cnc_endtime(idx) = time + tprocess1; % ���¼ӹ����ʱ��
                flag = 1;
           else
               result(temp,4) = time;%��¼�ö��������Ͽ�ʼʱ��
               cnt = cnt + 1;%��ʼ�ӹ���һ������
               result(cnt,1) = cnt;
               result(cnt,2) = idx;
               result(cnt,3) = time;%������ͬʱ����
               time = time + tud(idx);%����ʱ��         
               cnc_now(idx) = cnt; %���µ�ǰ�ڼӹ�����
               cnc_endtime(idx) = time + tprocess1; %���½���ʱ��
               if getp() == 1
                   break_idx = [break_idx,idx];
                   start_time = time + rand*tprocess1;
                   time_break = 10 + 10*rand;
                   break_start = [break_start,start_time];
                   break_end = [break_end,start_time+time_break]; 
                   breakall = [breakall;idx,start_time,time_break];
               end
               hold = temp;
               flag = 2;
           end
       else
           [idx,dis] = getClosest(rgv_pos,queue2);%��ȡ�����������cnc�;���
           if dis > 0 %�����Ҫ�ƶ�
              time = time + tmove(dis);%����ʱ�� 
              rgv_pos = cnc_pos(idx);
           end
           if cnc_now(idx) > 0 %̨�����ж���������һ��֮��
              temp = cnc_now(idx);%��¼���
              result(temp,7) = time;%���Ͽ�ʼ
              sp = 1;%���̨���ж���
           else
              sp = 0;
           end
           result(hold,5) = idx;%��¼���������cnc��
           result(hold,6) = time;%��¼���Ͽ�ʼʱ��
           time = time + tud(idx);%����ʱ��
           cnc_now(idx) = hold;%���¼ӹ����
           cnc_endtime(idx) = time + tprocess2;%���½���ʱ��
           if getp() == 1
               break_idx = [break_idx,idx];
               start_time = time + rand*tprocess2;
               time_break = 10 + 10*rand;
               break_start = [break_start,start_time];
               break_end = [break_end,start_time+time_break]; 
               breakall = [breakall;idx,start_time,time_break];
           end
           if sp == 1 %����ж���
               cnt_finish = cnt_finish + 1;
               time = time + tclean;%����ʱ��
               result(temp,8) = time;%��¼���ʱ��
           end
           flag = 1;%��һ������Ϊ1
       end
   end
end
% cnt_finish
% breakall
mm = mm + cnt_finish;
mmm = mmm + length(breakall);
end
mm/N
mmm/N



function [queue1,queue2] = check(time,cnc_endtime,cnc_assign)
%��������ɹ�����cnc
queue1 = [];
queue2 = [];
for i = 1 : 8
   if cnc_endtime(i) <= time
      if cnc_assign(i) == 1
         queue1 = [queue1 i];
      else
         queue2 = [queue2 i];
      end
   end
end


function [idx,d] = getClosest(rgv_pos,queue)
%���ص�ǰ�������������ź;���
global cnc_pos
d = 1e5;
for i = 1 : length(queue) %��������queue�ڵ�
    if abs(cnc_pos(queue(i)) - rgv_pos) < d
       d =  abs(cnc_pos(queue(i)) - rgv_pos);
       idx = queue(i);
    end
end

function [key] = getp()
x = ceil(rand*100);
if x == 1
   key = 1;
else
    key = 0;
end