function test1_2
global cnc_pos
%���ݶ���
%tmove -- RGV�ƶ�ʱ��
%tprocess -- CNC�ӹ�ʱ��
%tud -- ������ʱ��
%tclean -- ��ϴʱ��
cnc_pos = [1 1 2 2 3 3 4 4];%cnc��Ӧλ��
way = 3;%ѡ�õڼ�������
switch way
    case 1
        tmove = [20 33 46];
        tprocess = 560;
        tud = repmat([28 31],1,4);
        tclean = 25;
    case 2
        tmove = [23 41 59];
        tprocess = 580;
        tud = repmat([30 35],1,4);
        tclean = 30;
    case 3
        tmove = [18 32 46];
        tprocess = 545;
        tud = repmat([27 32],1,4);
        tclean = 25;
end
target = 400;%���Ŀ������
% order = perms(1:8); %ȫ����
order = [1 3 5 7 8 6 4 2];
queue = [];%�ȴ�ָ�����
rgv_pos = 1; %С����Ӧλ��
cnc_now = zeros(1,8);%��ǰ�ӹ���
cnc_endtime = zeros(1,8);%��ǰ�ӹ��Ľ���ʱ��
cnt = 0;%��ǰ�ӹ���
cnt_finish = 0;%��ȫ�ӹ���
time = 0;
result = zeros(target,5);
%��Ž�������Ϻš�cnc��š����Ͽ�ʼʱ�䡢���Ͽ�ʼʱ�䡢����ʱ��

%��һ��
for i = 1 : 8
   pos = cnc_pos(order(i));%�ҳ���ǰ��ȥ��cncλ��
   if pos == rgv_pos
      result(i,1) = i;
      result(i,2) = order(i);
      result(i,3) = time; %�����ƶ���ֱ������
      time = time + tud(order(i));%����ʱ��
      cnc_endtime(order(i)) = time + tprocess;%��¼��cnc���ʱ��
      cnc_now(order(i)) = i;%��cnc��ǰ�ڼӹ���i������
   else
       distance = abs(pos - rgv_pos);%����λ�ò�
       time = time + tmove(distance);%����ʱ��
       result(i,1) = i;
       result(i,2) = order(i);
       result(i,3) = time; %�ƶ�ʱ���Ѹ���
       time = time + tud(order(i));%��������ʱ��
       cnc_endtime(order(i)) = time + tprocess;
       cnc_now(order(i)) = i;
   end
   rgv_pos = pos;%����С��λ��
end
cnt = 8;%����cnt
%�ڶ���
%���� -- ����+��ϴ+����+�ӹ�
%���Ϻ�����ͬʱ����
while cnt_finish < target
   if time >= 8*3600
      break; 
   end
   if time < min(cnc_endtime) %���еĶ����ڹ���
       time = min(cnc_endtime);%ʱ������ȥ
       continue;
   else
       queue = check(time,cnc_endtime);%��ȡ��ɵĶ���
       [idx,dis] = getClosest(rgv_pos,queue);%��ȡ�����������cnc�;���
       if dis > 0 %�����Ҫ�ƶ�
          time = time + tmove(dis);%����ʱ�� 
          rgv_pos = cnc_pos(idx);
       end
       %������ + �ӹ���ϴ
       temp = cnc_now(idx);%��ȡ��ǰcnc�ӹ���ϵĻ�����
       result(temp,4) = time;%��¼�ö��������Ͽ�ʼʱ��
       cnt = cnt + 1;%��ʼ�ӹ���һ������
       result(cnt,1) = cnt;
       result(cnt,2) = idx;
       result(cnt,3) = time;%������ͬʱ����
       time = time + tud(idx);%����ʱ��
       cnc_now(idx) = cnt; %���µ�ǰ�ڼӹ�����
       cnc_endtime(idx) = time + tprocess; %���½���ʱ��
       time = time + tclean; %����ʱ��
       result(cnt,5) = time;
       cnt_finish = cnt_finish + 1;
   end
end
cnt_finish


function queue = check(time,cnc_endtime)
%��������ɹ�����cnc
queue = [];
for i = 1 : 8
   if cnc_endtime(i) <= time
      queue = [queue i]; 
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