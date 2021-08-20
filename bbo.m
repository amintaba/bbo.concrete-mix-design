clc;
clear;
close all;

%% Problem Definition

CostFunction=@(x) Sphere(x);        % Cost Function

nVar=9;                             % Number of Decision Variables

VarSize=[1 nVar];                     % Decision Variables Matrix Size

w_min = 0;                          % Decision Variables Lower Bound   
c_min = 0;
coarseag_min =0 ;
fineag_min = ;
micro_min= 0;
nano_min = 0;
steel_alyaf_min = 0; 
pp_alyaf_min = 0;
glass_alyaf_min = 0;

w_max =  1;                         % Decision Variables Upper Bound
c_max =  1;
coarseag_max = 1;
fineag_max = 1;
micro_max = 1;
nano_max = 1;
steel_alyaf_max = 1;
pp_alyaf_max = 1;
glass_alyaf_max = 1 ;

% BBO Parameters

MaxIt=1000;                          % Maximum Number of Iterations

nPop=20;                            % Number of Habitats (Population Size)

KeepRate=0.2;                        % Keep Rate
nKeep=round(KeepRate*nPop);          % Number of Kept Habitats

nNew=nPop-nKeep;                     % Number of New Habitats

% Migration Rates
mu=linspace(1,0,nPop);               % Emmigration Rates
lambda=1-mu;                         % Immigration Rates

alpha=0.9;

pMutation=0.1;

sigma(1)=0.00002*(w_max - w_min);
sigma(2)=0.00002*(c_max - c_min);
sigma(3)=0.00002*(coarseag_max - coarseag_min);
sigma(4)=0.00002*(fineag_max - fineag_min);
sigma(5)=0.00002*(micro_max - micro_min);
sigma(6)=0.00002*(nano_max - nano_min);
sigma(7)=0.00002*(steel_alyaf_max - steel_alyaf_min);
sigma(8)=0.00002*(pp_alyaf_max - pp_alyaf_min);
sigma(9)=0.00002*(glass_alyaf_max - glass_alyaf_min);


%% Initialization

% Empty Habitat
habitat.Position=[];
habitat.Cost=[];

% Create Habitats Array
pop=repmat(habitat,nPop,1);

% Initialize Habitats
for i=1:nPop
    pop(i).Position = [randi([w_min , w_max] , 1,1) , randi([c_min , c_max] , 1,1) , randi([coarseag_min , coarseag_max] , 1,1), randi([fineag_min , fineag_max]  , 1,1) , randi([micro_min , micro_max]  , 1,1), randi([nano_min , nano_max]  , 1,1) , randi([steel_alyaf_min , steel_alyaf_max]  , 1,1) , randi([pp_alyaf_min , pp_alyaf_max]  , 1,1) , randi([glass_alyaf_min , glass_alyaf_max] ,1,1)];
    pop(i).Cost=CostFunction(pop(i).Position);
  
end

% Sort Population
[~, SortOrder]=sort([pop.Cost]);
pop=pop(SortOrder);

% Best Solution Ever Found
BestSol=pop(1);

% Array to Hold Best Costs
BestCost=zeros(MaxIt,1);

%% BBO Main Loop

for it=1:MaxIt
    
    newpop=pop;
    for i=1:nPop
        for k=1:nVar
            % Migration
            if rand<=lambda(i)
                % Emmigration Probabilities
                EP=mu;
                EP(i)=0;
                EP=EP/sum(EP);
                
                % Select Source Habitat
                j=RouletteWheelSelection(EP);
                
                % Migration
                newpop(i).Position(k)=pop(i).Position(k) ...
                    +0.001*(pop(j).Position(k)+pop(i).Position(k));
                
            end
            
            % Mutation
           % if rand<=pMutation
              %  for j = 1:9
              %  newpop(i).Position(k)=newpop(i).Position(k)+sigma(j)*randn;
             %   end
          %  end
       end
       
        % Evaluation
        newpop(i).Cost=CostFunction(newpop(i).Position);
    end
    
    % Sort New Population
    [~, SortOrder]=sort([newpop.Cost]);
    newpop=newpop(SortOrder);
    
    % Select Next Iteration Population
    %pop=[pop(1:nKeep)
      %   newpop(1:nNew)];
     
    % Sort Population
   % [~, SortOrder]=sort([pop.Cost]);
    %pop=pop(SortOrder);
    
    % Update Best Solution Ever Found
   % BestSol=pop(1);
    
    % Store Best Cost Ever Found
    %BestCost(it)=BestSol.Cost;
    
    % Show Iteration Information
    %disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
    
end

%% Results

%figure;
%plot(BestCost,'LineWidth',2);
%semilogy(BestCost,'LineWidth',2);
%xlabel('Iteration');
%ylabel('Best Cost');

