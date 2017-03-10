%% simulateReplicators
% Simulates the stochastic evolution of a finite population of agents
% playing the steal/punish game, using the larger 5x5 strategy space (for
% each role, all 4 reactive strategies plus 1 learning strategy).
% Systematically varies theta while randomly sampling other parameters.

% Adam Morris, James MacGlashan, Michael Littman, & Fiery Cushman
% July 2016

%% Set parameters

% Simulation parameters
nAgents = 100;
nGenerations = 10000;
invTemp = 1 / 1000;

% Vary theta
thetaVals = linspace(0, 1, 51);
nThetaVals = length(thetaVals);
nSamplesPerVal = 10;

% Randomly sample other parameters
N = 10000;
%mutation = .01 + rand(nThetaVals, nSamplesPerVal) * .65; % .1 to .66
mutation = repmat(.2, nThetaVals, nSamplesPerVal);
x = 0 + rand(nThetaVals, nSamplesPerVal) * 6;
y = 0 + rand(nThetaVals, nSamplesPerVal) * 2;
s = 0 + rand(nThetaVals, nSamplesPerVal) * 2;
sp = 0 + rand(nThetaVals, nSamplesPerVal) * 2;
c = y .* sp;
p = (x + 1) .* s;

%% Run simulation

% Initialize recording arrays
outcomes = zeros(nThetaVals, nSamplesPerVal);

IND_FAMILIAR = 10;
IND_PARADOXICAL = 21;
IND_NOCONV = 0;

% For each value of theta..
for thisParamVal = 1:nThetaVals
    theta = thetaVals(thisParamVal);
    
    % Run all the samples
    parfor thisSample = 1:nSamplesPerVal
        payoffs = getPayoffs(N, ...
            s(thisParamVal, thisSample), sp(thisParamVal, thisSample), ...
            c(thisParamVal, thisSample), p(thisParamVal, thisSample), ...
            theta);
        
        [~, ~, population_full] = ...
            runMoran(payoffs, nAgents, nGenerations, invTemp, mutation(thisParamVal, thisSample));
        
        % What % of the population must be a certain strategy to count the
        % simulation as having converged to that strategy?
        cutoff = 1 - mutation(thisParamVal, thisSample) - .1;

        % Classify sample
        for eq = 1:25
            if mean(mean(population_full(1001:nGenerations, :) == eq)) > cutoff
                outcomes(thisParamVal, thisSample) = eq;
                break;
            end
        end
    end
end

%% Draw (part 1)
figure

H=bar([mean(outcomes == IND_FAMILIAR, 2), mean(outcomes == IND_PARADOXICAL, 2), ...
    mean(outcomes ~= IND_FAMILIAR & outcomes ~= IND_PARADOXICAL & outcomes ~= IND_NOCONV, 2), ...
    mean(outcomes == IND_NOCONV, 2)], 'stacked');
set(H(1),'facecolor',[0 180 185] / 255);
set(H(2),'facecolor',[255 140 0] / 255);
set(H(3),'facecolor',[0 0 0] / 255);
set(H(4),'facecolor',[120 120 120] / 255);
set(H, 'edgecolor', [0 0 0]);
xlim([0 nThetaVals + 1]);
ylim([0 1]);
hl = legend('Persistent punishment', 'Persistent theft', 'Other', 'No convergence', ...
    'location', 'northoutside');
legend('boxoff');
set(gca, 'XTickLabel', {'0', '', '', '', '', '', '', '', '', '', '1'}, 'YTick', [0 1], 'YTickLabel', [0 1]);
xlabel('Risk of victim exploitation (?)');
ylabel(sprintf('Probability of\nequilibrium'));
set(gca, 'LineWidth', 4);
set(gca, 'FontSize', 55);

%% Draw (part 2)
hlt = text(...
    'Parent', hl.DecorationContainer, ...
    'String', 'Population converges to:', ...
    'HorizontalAlignment', 'center', ...
    'VerticalAlignment', 'bottom', ...
    'Position', [0.5, 1.05, 0], ...
    'Units', 'normalized', ...
    'FontSize', 55, ...
    'FontWeight', 'bold');