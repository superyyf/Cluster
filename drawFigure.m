% save('./data/data_1.mat','OurMethod','LPM','LAF','VFC','InlierRatio');

% OurMethod = table2array(OurMethod);
% LPM = table2array(LPM);
% LAF = table2array(LAF);
% VFC = table2array(VFC);
% InlierRatio = table2array(InlierRatio);

figure(1);
axis([0 1 0 1]); box on;hold on;
s1 = scatter(OurMethod(:,1),OurMethod(:,2),36,'r');
s2 = scatter(LPM(:,1),LPM(:,2),36,'b','^');
s3 = scatter(VFC(:,1),VFC(:,2),36,'m','*');
s4 = scatter(LAF(:,1),LAF(:,2),36,'g','s');

xlabel('Precision');
ylabel('Recall');
legend([s1(1),s2(1),s3(1),s4(1)],'OurMethod,    p=90.35%, r=76.08%','LPM,   p=81.08%, r=90.09%','VFC,   p=80.26, r=87.00%','LAF,    p=85.14%, r=84.28%','Location','southwest');

hold off

figure(2);
axis([0 1 0 1]); box on;hold on;
InlierRatio = sort(InlierRatio);
Cumulative = (1:size(InlierRatio,1));
Cumulative = Cumulative .* 0.1;
s5 = plot(InlierRatio,Cumulative,'-ob');
plot([InlierRatio(1),InlierRatio(1)],[0,Cumulative(1)],'-b');
xlabel('Inlier Ratio');
ylabel('Cumulative Distribution');