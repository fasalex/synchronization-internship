clf ;
system("rm *.vec");
system("rm *.sca");

number_of_nodes = 16 ;
finalvec=zeros(number_of_nodes,1000,4); 
rnd = rand(1,number_of_nodes);
hold on ;

for fasika = 1:1
keep('fasika','number_of_nodes','rnd','finalvec');
algorithm = 1  ;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%          INPUT PARAMETERS FOR THE SIMULATION                         %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
run = 1 ;                           %% 1 - commandline  2 - gui 
jump = fasika ;                          %% jump to reduce the calculation burden 
sim_time_limit = 1000;		    %% Number of events needed for "limit" 
speed = 0 ;                         %%  In Kilometer per hour 
updateInterval = 1;                 %% In simulation seconds 
gain = 0.75 ;                       %% Value for computing the offsets 
express = "yes" ;                   %% Enable or Disable express mode 
alpha = 2.5 ;                       %% Channel factor - attenuation if you might say ...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%          END OF PARAMETERS , OUT                                     %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (fasika == 1)
color = 'b' ;
elseif(fasika == 2 )
color = 'r';
elseif(fasika == 3)
color = 'g';
elseif(fasika == 4)
color = 'm';
elseif(fasika == 5)
color = 'c';
elseif(fasika == 6)
color = 'w';
endif
algor = int2str(algorithm);
disp(algor) ;
prefix = "/home/fasika/mixim/trunk/examples/synchronization/graphs/";	% output directory
model = "./New";		  

% simulation command
%% create ini file

if(run==1)
system("cp Makefile_cmd Makefile");
else
system("cp Makefile_tk Makefile");
endif

system("make") ;
vectorname_m = "omnetpp.vec";
scalarname = "omnetpp.sca";
ininame = "omnetpp.ini";

spe = int2str(speed);
gai = int2str(gain*10);
no = int2str(number_of_nodes);
ra = int2str(rand()*1000 );
alp = int2str(alpha*100);
ext = '.eps';
filename = strcat(prefix,'s',ra,spe,'-g',gai,'-n',no,'-alpha',alp,ext);

playgroundSizeX =  (sqrt(number_of_nodes) + 1)*100 ;	    %% meters
playgroundSizeX = 500 ;
playgroundSizeY =  playgroundSizeX ;            %% meters

fidout = fopen(ininame, "w", "native");
fprintf(fidout, "[General]\n");
fprintf(fidout, "preload-ned-files = *.ned @nedincludes.lst\n");
fprintf(fidout, "network = mobileNet\n");
fprintf(fidout, "sim-time-limit = %d\n\n", sim_time_limit);

fprintf(fidout, "[Cmdenv]\n");
fprintf(fidout, "express-mode = %s\n", express);

fprintf(fidout, "[Parameters]\n");
fprintf(fidout, "##############################\n");
fprintf(fidout, "# Simulation parameters #\n");
fprintf(fidout, "##############################\n");
fprintf(fidout, "mobileNet.**.coreDebug = 0\n");
fprintf(fidout, "mobileNet.playgroundSizeX = %d\n", playgroundSizeX);
fprintf(fidout, "mobileNet.playgroundSizeY = %d\n", playgroundSizeY);
fprintf(fidout, "mobileNet.playgroundSizeZ = 0\n");
fprintf(fidout, "mobileNet.numHosts = %d \n", number_of_nodes);
fprintf(fidout, "mobileNet.Node[*].normalNic.jump = %d \n" , jump) ;
fprintf(fidout, "mobileNet.Node[*].normalNic.algorithm = %d \n" , algorithm) ;
fprintf(fidout, "mobileNet.Node[*].normalNic.gain = %f \n" , gain) ;
fprintf(fidout, "mobileNet.Node[*].normalNic.hosts = %d \n\n", number_of_nodes);

fprintf(fidout, "##############################\n");
fprintf(fidout, "# World Utility Parameters #\n");
fprintf(fidout, "##############################\n");
fprintf(fidout, "mobileNet.world.useTorus = 0\n");
fprintf(fidout, "mobileNet.world.use2D = 0\n\n");

fprintf(fidout, "##############################\n");
fprintf(fidout, "# Channel Parameters #\n");
fprintf(fidout, "##############################\n");
fprintf(fidout, "mobileNet.Channel.coreDebug = 0\n");
fprintf(fidout, "mobileNet.Channel.sendDirect = 0\n");
fprintf(fidout, "mobileNet.Channel.pMax = 20\n");
fprintf(fidout, "mobileNet.Channel.sat = -82\n");
fprintf(fidout, "mobileNet.Channel.alpha = %f\n",alpha);
fprintf(fidout, "mobileNet.Channel.carrierFrequency = 2.45e+9\n\n");

fprintf(fidout, "##############################\n");
fprintf(fidout, "# Host specific Parameters #\n");
fprintf(fidout, "##############################\n");
fprintf(fidout, "mobileNet.*Node*.utility.coreDebug = 0\n\n");

fprintf(fidout, "##############################\n");
fprintf(fidout, "# Physical Layer Parameters #\n");
fprintf(fidout, "##############################\n");
fprintf(fidout, "mobileNet.Node[*].normalNic.phy.usePropagationDelay = true\n");
fprintf(fidout, "mobileNet.Node[*].normalNic.phy.thermalNoise = 1.0\n");
fprintf(fidout, "mobileNet.Node[*].normalNic.phy.analogueModels = xmldoc(\"config.xml\")\n");
fprintf(fidout, "mobileNet.Node[*].normalNic.phy.decider = xmldoc(\"config.xml\")\n");
fprintf(fidout, "mobileNet.Node[*].normalNic.phy.timeRXToTX = 0.01\n");
fprintf(fidout, "mobileNet.Node[*].normalNic.phy.timeRXToSleep = 0.015\n");
fprintf(fidout, "mobileNet.Node[*].normalNic.phy.timeTXToRX = 0.02\n");
fprintf(fidout, "mobileNet.Node[*].normalNic.phy.timeTXToSleep = 0.025\n");
fprintf(fidout, "mobileNet.Node[*].normalNic.phy.timeSleepToRX = 0.03\n");
fprintf(fidout, "mobileNet.Node[*].normalNic.phy.sensitivity = 0.2\n");
fprintf(fidout, "mobileNet.Node[*].normalNic.phy.maxTXPower = 20.0\n");
fprintf(fidout, "mobileNet.Node[*].normalNic.phy.timeSleepToTX = 0.035\n\n");

fprintf(fidout, "##############################\n");
fprintf(fidout, "# Host Parameters #\n");
fprintf(fidout, "##############################\n");
fprintf(fidout, "mobileNet.Node[*].normalNic.connectionManagerName = \"Channel\"\n");
fprintf(fidout, "mobileNet.Node[*].mobility.angle = 2\n");
fprintf(fidout, "mobileNet.Node[*].mobility.acceleration = 2 \n");

i=0;
j=0;
squ = sqrt(number_of_nodes) ;
spac = playgroundSizeX / (squ+1) ;
squ = int8(squ) ;
for(m=0:squ)
while((j<squ) && ( i < number_of_nodes))
x(i+1) = spac + j*spac ;
fprintf(fidout, "mobileNet.Node[%d].mobility.x = %f\n",i,x(i+1));
y(i+1) = spac + m*spac;
fprintf(fidout, "mobileNet.Node[%d].mobility.y = %f\n",i,y(i+1));
z(i+1) = i ;
fprintf(fidout, "mobileNet.Node[%d].mobility.z = 0\n",z(i+1));
fprintf(fidout, "mobileNet.Node[%d].normalNic.id = %d\n", i, i );
fprintf(fidout, "mobileNet.Node[%d].normalNic.start_time = %f \n",i, rnd(i+1));
j=j+1;
i=i+1;
endwhile
j=0;
endfor

%%% Changing to simulation speed
speed = speed * (1/3.6) ;
fprintf(fidout, "mobileNet.Node[*].mobility.speed= %f\n", speed);
fprintf(fidout, "mobileNet.Node[*].mobility.updateInterval= %f\n", updateInterval);
fprintf(fidout, "mobileNet.Node[*].mobility.debug = 0 \n\n");
fclose(fidout) ;

%%
%% run the simulations
%%

run_sim(model,ininame) ;

MainVector = zeros(number_of_nodes,sim_time_limit) ;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Vector file split to individual vector files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fidin = fopen(vectorname_m);
if ( fidin == -1 )
error("Unable to open the main vector file ") ;
endif
fseek(fidin,7,'bof');
[Temp,Remm]=strtok(fgetl(fidin));
[vec_num,count] = sscanf(Temp,"%d");
fclose(fidin);
system("splitvec omnetpp.vec");

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Data extract from the vector file .
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for (i=0:number_of_nodes-1)
vec_n = i + vec_num ;
vectorname = sprintf("omnetpp-%d.vec", vec_n);
fidin = fopen(vectorname, "r", "native");
if (fidin==-1)
error("Unable to open the vector file");
endif
nRows=0;
while 1
iString=fgetl(fidin);
if ~ischar(iString)
break;
endif
nRows=nRows+1;
endwhile

%Return to beginning of file
fseek(fidin,0,'bof');

%For each row, assign each space delimitted object to a cell in the "Output" matrix
for iRow=1:nRows
iCol=1;
%Temporary storage of the first object
% Note: the space delimitter used here can be replaced by any delimitter
[TempOutput,Rem]=strtok(fgetl(fidin));

%If there is now data on this row, then assign the first object to be an underscore
if (length(TempOutput) == 0)
TempOutput='_';
endif
%Build the "Output" matrix this will be the first column of the iRow-th row


ascii_output = toascii(TempOutput) ;

if(ascii_output(1) ==35)
Remm = toascii(Rem);
start = find(Remm == 91);
eend = find(Remm == 93) ;
nodde = substr(Rem, start+1, eend-start-1) ;
[node_num coun] = sscanf(nodde , "%d");
else
num = find (ascii_output == 9) ;
TempOutput = substr(TempOutput,num(1)+1,num(2)-num(1));
[val,count] = sscanf(TempOutput,"%d");
if(iRow > 1)
MainVector(node_num+1,iRow-1) = val;
endif
endif
% Repeat this only using Rem as the total string and incrementing the iCol counter
endfor
fclose(fidin);
endfor
tit = strcat('Synchronization error for ',no,' nodes moving at ',spe,' km/hr');
m = length(MainVector);
MainVector(:,sim_time_limit:m) = MainVector(1,sim_time_limit-1) ;
for(j=1:sim_time_limit)
finalvec(:,j,fasika) = (MainVector(:,j)-min(MainVector(:,j)))' ;
endfor
plot(std(MainVector)/30,color,"LineWidth",2);
MainVector = MainVector(:,1:1000);
xlabel('period(sec)');
ylabel('Synchronization error(clock cycles)');
legend("KALMAN FILTER","MEDIAN","WEIGHTED MEASURMENTS","NONLINEAR CURVE FITTING");
title(tit) ;
% print(filename);
hold on ;
endfor
disp("SIMULATION ENDED") ;
