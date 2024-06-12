%%This code use
%%https://www.mathworks.com/matlabcentral/fileexchange/64303-mqtt-in-matlab 
%%Please install it to run
%%The variable declaration may differ from the paper

%clear all
clc
clear all

%MQTT connection
myMQTT = mqtt('tcp://broker.hivemq.com');

%Topic Name
topicName = 'Incoming/Data/Random';

%MQTT Subscription
mySub = subscribe(myMQTT,topicName);

%MQTT Callback
mySub.Callback = @myMQTT_Callback;

global K
K = 0;
global data
global Lmean
global LX
global Gmean
global X
global DataDensity
global AverdistValve
AverdistValve = 0;
global LocalDensity
global MeanDataDensity
global MeanLocalDataDensity
global eADPValve
eADPValve = 1;
global PA
global PAIndex
global anomalyIDX
global anomalyclustIDX
global anomalyCluster
global anomalyData
global anomalyCount
anomalyCount = 1;

global centerFC   
global supportFC
global supportAVG 

global clustMember
global clustMemberIDX

global L

%global capture
%global xCat
%global yCat

function myMQTT_Callback(topic,msg)
    %declare global memory
    global K
    global data
    global Gmean
    global X
    global DataDensity
    global d
    global L
    global Lmean
    global LX
    global LocalDensity
    global MeanDataDensity
    global MeanLocalDataDensity
    global eADPValve
    global PA
    global IDPA
    global AverdistValve
    global eADPValve
    global PA
    global Cmean
    global CX
    global PAdataDensity
    global Dcenter
    global cluster
    global support
    global center
    global mindistVal
    global mindist
    global nD

    global anomalyIDX
    global anomalyclustIDX
    global anomalyCluster
    global anomalyData
    global anomalyCount
    global PAIndex
    global clustMemberIDX

    global centerFC   
    global supportFC
    global supportAVG 


    global xCat
    global yCat
    global capture

    global clustMember

     if topic == "Incoming/Data/Random"
        tic
        K = K + 1;
        data(K,:) = double(strsplit(msg,','));
        
        if K == 1
            %global mean
            Gmean = data(K,:);
            %average scalar product
            X = sum(data(K,:).^2);
            %First data density is 1
            DataDensity = 1;
            %PreviousDataDensity = 1;
            %first cummulative proximity
            d=0;
               
            %NEW INVENTION
            MeanDataDensity = 1;
            MeanLocalDataDensity = 1;

            LocalDensity = 0;
            %PreviousLocalDataDensity = 0;

            L = 1;
        else
            %update global mean using recursive calc
            Gmean = ((K-1)/(K))*Gmean + ((1/K)*data(K,:));
            %update average scalar product using recursive calc
            X = (((K-1)/K) * X) + ((sum(data(K,:).^2)) / K);
            %update data density using recursive calculation
            DataDensity = 1 / (1+sum((data(K,:) - Gmean).^2)+X-sum(Gmean.^2));
            MeanDataDensity = ((K-1)/(K))*MeanDataDensity + ((1/K)*DataDensity);
            %update cumulative proximity
            CumProx = K * (sum((data(K,:) - Gmean).^2) + X - sum(Gmean.^2));
            %Level of Granuality is 0
            d = d + (2 * CumProx);
            %if cumulative proximity less than total cumulative proximity
            if CumProx <= d
                if AverdistValve == 0 %if first initialization
                    %first data
                    L = 1;
                    %first mean
                    Lmean = data(K,:);
                    %first average scalar product
                    LX = sum(data(K,:).^2);
                    %AverdistValve is 1 to turn on update for next data
                    AverdistValve = 1;
                elseif AverdistValve == 1 %update
                    %update L
                    L = L + 1;
                    %update local mean using recursive calc
                    Lmean = ((L-1)/(L))*Lmean + ((1/L)*data(K,:));
                    %update local average scalar product using recursive calc
                    LX = (((L-1)/L) * LX) + ((sum(data(K,:).^2)) / L);
                    AverdistValve = 1;
                end
                %update local density recursively
                LocalDensity = 1/(1+ (sum((data(K,:) - Lmean).^2) / LX - sum(Lmean.^2)));
                if isinf(LocalDensity) == 1
                    LocalDensity = 0;
                end
                MeanLocalDataDensity = ((L-1)/(L)*MeanLocalDataDensity) + ((1/L)*LocalDensity);
            else
                LocalDensity = 0;
                MeanLocalDataDensity = ((L-1)/(L))*MeanLocalDataDensity + ((1/L)*LocalDensity);
            end
        end
        if MeanDataDensity > DataDensity || MeanLocalDataDensity > LocalDensity
            PA(eADPValve,:) = data(K,:);
            PAIndex(eADPValve) = K;
            if eADPValve==1 %initialization
                %first cluster
                cluster = 1;
                %first support
                support(cluster) = 1;
                %first center for first cluster
                center(cluster,:) = data(K,:);
                %center density for first cluster
                Dcenter(cluster) = 1;
                PAdataDensity(eADPValve) = 1;
                Cmean = data(K,:);
                CX = sum(data(K,:).^2);
                eADPValve = eADPValve + 1;
            else
                Cmean = ((eADPValve-1)/(eADPValve))*Cmean + ((1/eADPValve)*data(K,:));
                CX = (((eADPValve-1)/eADPValve) * CX) + ((sum(data(K,:).^2)) / eADPValve);
                PAdataDensity(eADPValve) = 1 / (1+sum((data(K,:) - Cmean).^2)+CX-sum(Cmean.^2));
                if PAdataDensity(eADPValve) > max(Dcenter) || PAdataDensity(eADPValve) < min(Dcenter) %if data density is more then max or ...
                     %new cluster
                     cluster = cluster + 1;
                     %new support
                     support(cluster) = 1;
                     %new center of cluster
                     center(cluster,:) = data(K,:);
                     %new data density of center 
                     Dcenter(cluster) = PAdataDensity(eADPValve);
                else
                     [mindistVal,mindist] = min(pdist2(data(K,:),center)); %find nearest dist between data and center
                     %sigma or data driven threshold
                     nD = sqrt(2 * (CX - sum(Cmean(1,:).^2)));
                     if mindistVal < (nD/2) %if min dist between data and center less than sigma
                        %update support
                        support(mindist) = support(mindist) + 1;
                        %update center
                        center(mindist,:) = ((support(mindist)-1)/(support(mindist)) * center(mindist,:)) + (1/support(mindist) * data(K,:));
                        %update center data density 
                        Dcenter(mindist) = support(mindist) / (1 + (pdist2(center(mindist,:),Cmean(1,:)) / (CX - sum(Cmean(1,:).^2))));
                     else
                        cluster = cluster + 1; %new cluster
                        support(cluster) = 1; %new support
                        center(cluster,:) = data(K,:); %new center
                        Dcenter(cluster) = PAdataDensity(eADPValve);  %new data density
                     end
                end
                eADPValve = eADPValve + 1;
            end
            %%data cloud formation (Voronoi Tessellation)
            %find distance between potential anomaly (PA) and detected cluster
            %center(center)
            distFC = pdist2(PA,center,'euclidean');
            %find minimum distance index from distFC
            [valFC,IDXFC] = min(distFC,[],2);
            %set number of data(PA) and number of center in LFC and CFC respectively
            [LFC,CFC]=size(distFC);
            %Set 0 matrix in number of matrix (CFC) * 1 in supportFC
            supportFC=zeros(CFC,1);
            %Set number column of data in WFC
            WFC = length(center(1,:));
            %Set 0 matrix in number of matrix(CFC) * number of column (WFC) in centerFC
            centerFC = zeros(CFC,WFC);
            %cluster member cell%%
            clustMember = cell(CFC,1);
            clustMemberIDX = cell(CFC,1);
            %clusterCounter%%
            counterCenter = 0;
            %Loop in CFC times
            for j = 1:1:CFC%Find IDXFC that is equal to j and safe it in seqFC
                seqFC=find(IDXFC==j);
                if ~isempty(seqFC)
                    %update support using size of seqFC where seqFC represent how many data
                    %located near the center
                    supportFC(j) = length(seqFC);
                    %find the mean between nearest data center, this then form data clouds
                    centerFC(j,:)=mean(PA(seqFC,:),1);
                    counterCenter = counterCenter + 1;
                    clustMember{counterCenter}(end + seqFC, :) = PA(seqFC,:);
                    %clustMemberIDX{counterCenter}(end + seqFC) = PAIndex(seqFC);
                    clustMember{counterCenter}(all(clustMember{counterCenter}==0,2),:)=[];
                    %clustMemberIDX{counterCenter}(all(clustMemberIDX{counterCenter,1}==0,2))=[];
                    %clustMember{counterCenter}(end + 1, :) = mean(PA(seqFC,:),1);
                    supportFC(j) = size(clustMember{counterCenter},1);
                end
            end
            %check anomaly%
            %calculate average support
            centerFC(all(centerFC==0,2),:)=[];   
            supportFC(all(supportFC==0,2),:)=[];
            supportAVG = (1/size(centerFC,1)) * sum(supportFC,'all');
            %if more than or equal to supportFCAVG, declared anomaly
            anomalyclustIDX = find(supportFC < supportAVG);
            anomalyCluster = centerFC(anomalyclustIDX,:);%detected anomaly
        end
        toc
     end
end