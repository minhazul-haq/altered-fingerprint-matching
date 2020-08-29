

function baselineMatching( inputFilename, probableAlteredArea )

maxMatchingScore = 0;
files = dir('template data set 1/*.xyt');
file_names = {files.name};


for file_no = 1 : size(file_names,2)

    close all;
    
    templateFilename = strcat( 'template data set 1/', char(file_names(1,file_no)) );    
    
    %read minutiae from file
    templateMinutiae = readMinutiae(templateFilename,0);
    inputMinutiae = readMinutiae(strcat(inputFilename,'.xyt'),probableAlteredArea);


    % 1. local minutiae matching
    totalTemplateMinutiae = size(templateMinutiae,2);
    totalInputMinutiae = size(inputMinutiae,2);

    %neighbors in templateMinutiae
    for i=1:totalTemplateMinutiae
        templateMinutiae(i).neighbor = [];
        for j=1:totalTemplateMinutiae
            if ( (i~=j) && (spatialDistance( templateMinutiae(i), templateMinutiae(j) ) <= 80) )
                templateMinutiae(i).neighbor(end+1) = j;
           end
        end
    end

    %neighbors in inputMinutiae
    for i=1:totalInputMinutiae
        inputMinutiae(i).neighbor = [];
        for j=1:totalInputMinutiae
            if ( (i~=j) && (spatialDistance( inputMinutiae(i), inputMinutiae(j) ) <= 80) )
                inputMinutiae(i).neighbor(end+1) = j;
           end
        end
    end


    thresholdDistance = 15;
    thresholdAngle = 15;
    thresholdQuality = 10;

    penalizedInput = zeros(totalInputMinutiae,totalTemplateMinutiae);
    penalizedTemplate = zeros(totalTemplateMinutiae,totalInputMinutiae);

    k1 =  convhull([inputMinutiae.x]',[inputMinutiae.y]');
    k2 =  convhull([templateMinutiae.x]',[templateMinutiae.y]');

    for p=1:totalInputMinutiae
        for q=1:totalTemplateMinutiae

           xDiff = inputMinutiae(p).x - templateMinutiae(q).x;
           yDiff = inputMinutiae(p).y - templateMinutiae(q).y;
           aDiff = inputMinutiae(p).theta - templateMinutiae(q).theta;

           mp=0;
           up=0;

           for a = inputMinutiae(p).neighbor     
               matching = 0;
               for b = templateMinutiae(q).neighbor     
                   %similar location & direction
                   if ( (neighborDistance( inputMinutiae(a), xDiff, yDiff, aDiff, templateMinutiae(b) ) <= thresholdDistance) && ( neighborAngle( inputMinutiae(a), aDiff, templateMinutiae(b) ) <= thresholdAngle ) )
                       matching = 1;
                       break;
                   end
               end

               if (matching==1)
                   mp = mp + 1;
               else
                   if ((inputMinutiae(a).quality <= thresholdQuality))% || (inConvexHull(inputMinutiae(a),xDiff,yDiff,aDiff,templateMinutiae,k2)==0))
                       %do nothing
                   else
                       up = up + 1;
                   end
               end
           end

           penalizedInput(p,q) = up;

           mq=0;
           uq=0;

           for b = templateMinutiae(q).neighbor        
               matching =0;
               for a = inputMinutiae(p).neighbor        
                   %similar location & direction
                   if ( (neighborDistance( templateMinutiae(b), -xDiff, -yDiff, -aDiff, inputMinutiae(a) ) <= thresholdDistance) && ( neighborAngle( templateMinutiae(b), -aDiff, inputMinutiae(a) ) <= thresholdAngle ) )
                       matching = 1; 
                       break;
                   end
               end

               if (matching==1)
                   mq = mq + 1;
               else
                   if ((templateMinutiae(b).quality <= thresholdQuality))% || (inConvexHull(templateMinutiae(b),-xDiff,-yDiff,-aDiff,inputMinutiae,k1)==0))
                       %do nothing
                   else
                       uq = uq + 1;
                   end
               end
           end

           penalizedTemplate(q,p) = uq;

           S(p,q) = ((mp+1)*(mq+1)) / ((mp+up+3)*(mq+uq+3));

        end 
    end


    %2. global minutiae matching

    for i=1:totalInputMinutiae
        for j=1:totalTemplateMinutiae

            Sn(i,j) =  ( (totalInputMinutiae + totalTemplateMinutiae - 1) * S(i,j) ) / ( sum(S(i,:)) + sum(S(:,j)) - S(i,j) );

        end
    end


    %alignment start

    %find 5 largest value
    A = Sn;
    [sortedValues,sortIndex] = sort(A(:),'descend');  %sort the values in descending order
    maxIndex = sortIndex(1:5); 
    [Maxi,Maxj] = ind2sub(size(A),maxIndex);


    %align
    aa = 1;
    deltaX = inputMinutiae(Maxi(aa)).x -  templateMinutiae(Maxj(aa)).x;
    deltaY = inputMinutiae(Maxi(aa)).y -  templateMinutiae(Maxj(aa)).y;
    theta = inputMinutiae(Maxi(aa)).theta -  templateMinutiae(Maxj(aa)).theta;


    for i=1:totalInputMinutiae
        alignedInputMinutiae(i).x = ((inputMinutiae(i).x-deltaX)*cos(-theta*pi/180)) - ((inputMinutiae(i).y-deltaY)*sin(-theta*pi/180)) ;
        alignedInputMinutiae(i).y = ((inputMinutiae(i).x-deltaX)*sin(-theta*pi/180)) + ((inputMinutiae(i).y-deltaY)*cos(-theta*pi/180)) ;
        alignedInputMinutiae(i).theta = inputMinutiae(i).theta - theta;
        alignedInputMinutiae(i).quality = inputMinutiae(i).quality;
    end    

    %alignment end

    Mm = 0;
    totalSimilarity = 0;

    %figure(1);
    %plot( [inputMinutiae.x],[inputMinutiae.y], 'o','MarkerFaceColor','r','MarkerSize',8);
    %axis([0,512,0,480]);
    %hold on;
    %plot( [templateMinutiae.x],[templateMinutiae.y],'o','MarkerFaceColor','g','MarkerSize',8);
    %title( 'Original minutiae [Red=Input minutiae , Green=Template minutiae]' );

    %figure(2);
    %plot( [alignedInputMinutiae.x],[alignedInputMinutiae.y], 'o','MarkerFaceColor','r','MarkerSize',8);
    %axis([0,512,0,480]);
    %hold on;
    %plot([templateMinutiae.x],[templateMinutiae.y],'o','MarkerFaceColor','g','MarkerSize',6);
    %plot([templateMinutiae(k2).x]',[templateMinutiae(k2).y]');
    %title( 'Aligned minutiae [Red=Input minutiae , Green=Template minutiae]' );

    %figure(3);

    Uml = 0;
    Umr = 0;

    while(1)

        [max_val, position] = max( Sn(:) );

        if (max_val==0) 
            break;
        end

        [i,j] = ind2sub(size(Sn),position);

        %similar location & direction
        if ( (spatialDistance( alignedInputMinutiae(i),templateMinutiae(j) ) <= thresholdDistance) && ( angularDistance( alignedInputMinutiae(i),templateMinutiae(j) ) <= thresholdAngle ) )
            Mm = Mm + 1;
            totalSimilarity = totalSimilarity + S(i,j);

            %disp( sprintf('inputMinutiae# %d == templateMinutiae# %d       Sn(i,j): %f',i,j,Sn(i,j)) );

            Sn(i,:) = 0;
            Sn(:,j) = 0;         

            Uml = Uml + penalizedInput(i,j);
            Umr = Umr + penalizedTemplate(j,i);

            %hold on;
            %plot( alignedInputMinutiae(i).x,alignedInputMinutiae(i).y, 'o','MarkerFaceColor','r','MarkerSize',8);
            %axis([0,512,0,480]);
            %hold on;
            %plot(templateMinutiae(j).x,templateMinutiae(j).y,'o','MarkerFaceColor','g','MarkerSize',6);
        else
            Sn(i,j) = 0;
        end

    end



    %3. matching score computation
    if (Mm<3)
        SM = 0;
    else
        SMN = Mm / (Mm+8);

        Sd = totalSimilarity / Mm;

        SMQ = Sd * ( Mm/(Mm+Uml) ) * ( Mm/(Mm+Umr) );

        SM = SMN * SMQ;
    end

    disp( sprintf('input:%s ; template:%s ; matching_score:%f',char(inputFilename),char(templateFilename),SM ) );

    if (SM>=maxMatchingScore)
        maxMatchingScore = SM;
        maxMatchedTemplate = templateFilename;
    end


end

disp( sprintf('--- --- --- --- --- --- --- --- --- --- --- --- ---') );
disp( sprintf('input:%s ; best matched template:%s ; matching_score:%f',char(inputFilename),char(maxMatchedTemplate),maxMatchingScore ) );

end


