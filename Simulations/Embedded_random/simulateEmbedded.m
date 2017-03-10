%% simulateEmbedded
% Runs evolutionary simulation of the steal/punish game with embedded RL agents, using
% the cached outcomes from makeCache.m.
% Systematically varies the cost of punishing, holding other parameters
% constant.

% Adam Morris, James MacGlashan, Michael Littman, & Fiery Cushman
% July 2016

%% Set parameters

load('cache.mat');

% Simulation parameters
nAgents = 100; % # of agents in population
nGenerations = 10000; % # of generations to simulate
invTemp = 1 / 1000; % inverse temperature of softmax selection function
mutation = .2; % mutation rate

% Vary pctPunCost
nSamplesPerVal = 100;

%% Run simulation

% Initialize recording arrays
outcomes = zeros(nParamVals, nSamplesPerVal);

IND_FAMILIAR = 4;
IND_PARADOXICAL = 2;
IND_NOCONV = 0;

% For each value of theta..
for thisParamVal = 1:nParamVals
    pctPunCost = paramVals(thisParamVal);
    payoffs_cur = payoffs(:, :, :, :, thisParamVal);
    
    % Run all the samples
    parfor thisSample = 1:nSamplesPerVal
        [distSteal, distPun, population_full] = ...
            runMoran(payoffs_cur, nAgents, nGenerations, invTemp, mutation);
        
        % What % of the population must be a certain strategy to count the
        % simulation as having converged to that strategy?
        cutoff = 1 - mutation - .1;

        % Classify sample
        for eq = 1:9
            if mean(mean(population_full(1001:nGenerations, :) == eq)) > cutoff
                outcomes(thisParamVal, thisSample) = eq;
                break;
            end
        end
    end
end

%% Draw (part 1)
figure

% H=bar([mean(outcomes == IND_FAMILIAR, 2), mean(outcomes == IND_PARADOXICAL, 2), ...
%     mean(outcomes ~= IND_FAMILIAR & outcomes ~= IND_PARADOXICAL & outcomes ~= IND_NOCONV, 2), ...
%     mean(outcomes == IND_NOCONV, 2)], 'stacked');
H=bar([
    mean(outcomes == IND_FAMILIAR, 2), ...
    mean(outcomes == IND_NOCONV, 2), ...
    mean(outcomes == IND_PARADOXICAL, 2), ...
    mean(outcomes ~= IND_FAMILIAR & outcomes ~= IND_PARADOXICAL & outcomes ~= IND_NOCONV, 2), ...
    ], 'stacked');
set(H(1),'facecolor',[0 180 185] / 255);
set(H(2),'facecolor',[120 120 120] / 255);
set(H(3),'facecolor',[255 140 0] / 255);
set(H(4),'facecolor',[0 0 0] / 255);
set(H, 'edgecolor', [0 0 0]);
xlim([0 nParamVals + 1]);
ylim([0 1]);
hl = legend([H(1) H(3) H(4) H(2)], 'Steal bias: 0, Punish bias: +', 'Steal bias: +, Punish bias: 0', 'Other', 'No convergence', ...
    'location', 'southeast');
set(gca, 'XTick', [0 nParamVals + 1], 'XTickLabel', [.1 2], 'YTick', [0 1], 'YTickLabel', [0 1]);
xlabel('Experienced cost of punishing');
ylabel('Probability of evolutionary equilibrium');
set(gca, 'LineWidth', 4);
set(gca, 'FontSize', 40);

%% Draw (part 2)
hlt = text(...
    'Parent', hl.DecorationContainer, ...
    'String', 'Equilibrium genotype', ...
    'HorizontalAlignment', 'center', ...
    'VerticalAlignment', 'bottom', ...
    'Position', [0.5, 1.05, 0], ...
    'Units', 'normalized', ...
    'FontSize', 40, ...
    'FontWeight', 'bold');