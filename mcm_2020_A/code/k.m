function [dataX,dataY] = k_means(data)
% my_kmeans
% By Chris, zchrissirhcz@gmail.com
% 2016��9��30�� 19:13:43

% ������Ŀk
K = 4;

% ׼�����ݣ�������2ά��,80�����ݣ���data.txt�ж�ȡ
%data = zeros(100, 2);
% load 'Answer1.mat'; % ֱ�Ӵ洢��data������
% data = Answer1;
x = data(:,1);
y = data(:,2);

% �������ݣ�2άɢ��ͼ
% x,y: Ҫ���Ƶ����ݵ�  20:ɢ���С��ͬ����Ϊ20  'blue':ɢ����ɫΪ��ɫ
% s = scatter(x, y, 20, 'blue');
% title('ԭʼ���ݣ���Ȧ����ʼ���ģ����');

% ��ʼ������
sample_num = size(data, 1);       % ��������
sample_dimension = size(data, 2); % ÿ����������ά��

% �����ֶ�ָ�����ĳ�ʼλ��
clusters = zeros(K, sample_dimension);
clusters(1,:) = [-3,1];
clusters(2,:) = [2,4];
clusters(3,:) = [-1,-0.5];
clusters(4,:) = [2,-3];

% hold on; % ���ϴλ�ͼ��ɢ��ͼ�������ϣ�׼���´λ�ͼ
% ���Ƴ�ʼ����
% scatter(clusters(:,1), clusters(:,2), 'red', 'filled'); % ʵ��Բ�㣬��ʾ���ĳ�ʼλ��

c = zeros(sample_num, 1); % ÿ�����������صı��

PRECISION = 0.0001;


iter = 100; % �ٶ�������100��
for i=1:iter
    % ���������������ݣ�ȷ�������ء���ʽ1
    for j=1:sample_num
        %t = arrayfun(@(item) item
        %[min_val, idx] = min(t);
        gg = repmat(data(j,:), K, 1);
        gg = gg - clusters;   % norm:��������ģ��
        tt = arrayfun(@(n) norm(gg(n,:)), (1:K)');
        [minVal, minIdx] = min(tt);
        % data(j,:)���������ģ����ΪminIdx
        c(j) = minIdx;
    end
    
    % ���������������ݣ����´��ġ���ʽ2
    convergence = 1;
    for j=1:K
        up = 0;
        down = 0;
        for k=1:sample_num
            up = up + (c(k)==j) * data(k,:);
            down = down + (c(k)==j);
        end
        new_cluster = up/down;
        delta = clusters(j,:) - new_cluster;
        if (norm(delta) > PRECISION)
            convergence = 0;
        end
        clusters(j,:) = new_cluster;
    end
%     figure;
%     f = scatter(x, y, 20, 'blue');
%     hold on;
%     scatter(clusters(:,1), clusters(:,2), 'filled'); % ʵ��Բ�㣬��ʾ���ĳ�ʼλ��
%     title(['��', num2str(i), '�ε���']);
    
    if (convergence)
        
        dataX = clusters(i,1);
        dataY = clusters(i,2);
%         disp(['�����ڵ�', num2str(i), '�ε���']);
        break;
    end
end