function createEmbeddedFigure(YMatrix1, YMatrix2)
%CREATEFIGURE(YMATRIX1, YMATRIX2)
%  YMATRIX1:  matrix of y data
%  YMATRIX2:  matrix of y data

%  Auto-generated by MATLAB on 19-Jul-2016 10:58:34

% Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1,...
    'Position',[0.13 0.11 0.278333333333333 0.607777777777778]);
hold(axes1,'on');

% Create multiple lines using matrix input to plot
plot1 = plot(YMatrix1,'Parent',axes1);
set(plot1(1),'DisplayName','Steal bias: 0, Punish bias: +');
set(plot1(2),'DisplayName','Steal bias: +, Punish bias: 0');
set(plot1(3),'DisplayName','Other','Color',[0 0 0]);

% Create xlabel
xlabel('Generation');

% Create ylabel
ylabel('% of population');

box(axes1,'on');
% Set the remaining axes properties
set(axes1,'FontSize',40,'LineWidth',4,'XTick',[0 10000],'YTick',[0 100]);
% Create legend
legend1 = legend(axes1,'show');
set(legend1,...
    'Position',[0.773492324561403 0.420017667844523 0.269473684210527 0.136631330977621],...
    'FontSize',30);%,...
    %'Color',[0.247058823529412 0.247058823529412 0.247058823529412]);
legend boxoff
    
% Create axes
axes2 = axes('Parent',figure1,...
    'Position',[0.465653409090909 0.108888888888889 0.280179924242424 0.611111111111111]);
hold(axes2,'on');

% Create multiple lines using matrix input to plot
plot2 = plot(YMatrix2,'Parent',axes2);
set(plot2(3),'Color',[0 0 0]);

% Create xlabel
xlabel('Generation');

box(axes2,'on');
% Set the remaining axes properties
set(axes2,'FontSize',40,'LineWidth',4,'XTick',[0 10000],'YTick',[]);
% Create textbox
annotation(figure1,'textbox',...
    [0.834302704905732 0.558438555162937 0.0986842105263158 0.0506478209658422],...
    'String',{'Genotype'},...
    'LineStyle','none',...
    'FontWeight','bold',...
    'FontSize',32);

% Create textbox
annotation(figure1,'textbox',...
    [0.233776389116257 0.730405575186489 0.0810526315789473 0.055359246171967],...
    'String',{'Costly'},...
    'LineStyle','none',...
    'FontWeight','bold',...
    'FontSize',36);

% Create textbox
annotation(figure1,'textbox',...
    [0.559565862800467 0.730405575186488 0.114736842105263 0.055359246171967],...
    'String',{'Not costly'},...
    'LineStyle','none',...
    'FontWeight','bold',...
    'FontSize',36);

% Create textbox
annotation(figure1,'textbox',...
    [0.351671125958363 0.826989791912046 0.206578947368421 0.0694935217903416],...
    'String',{'Punishment is...'},...
    'LineStyle','none',...
    'FontSize',48);

