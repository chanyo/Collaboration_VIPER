clear all;
clc;
close all

%path_name = './8D3/'; % DONE

% path_name = './VIPER live/';  %DONE
%path_name = './VIPER fixed/'; % DONE
% path_name = './TF/'; % DONE
% path_name = './H684/';  %DONE
path_name = './ab216665/'; % DONE

%path_name = './ab82411/'; % DONE


%path_name = './ab1086/';  % DONE


 


% DONE: VIPER


dir_name = dir(sprintf('%s', path_name));

for l=3:length(dir_name)
    
   
    %l=3;
 
    dir_name(l).name
    if length(dir_name(l).name) > 2 
      fname = dir(sprintf('%s%s/*.tif', path_name, dir_name(l).name));


        FLAG_en = 0;


        I_raw = imread(sprintf('%s%s/%s', path_name, dir_name(l).name,fname.name));

        if isempty(strfind(dir_name(l).name, 'UN')) == 1
        
          
          
            se = strel('disk', 10);
            %Itop = imtophat(imadjust(I_raw), se);
            Itop = imtophat((I_raw), se);
            
       %     Itop = imgaussfilt(Itop,2);
            
           % Itop = imsharpen(Itop);
            
           % Itop = imadjust(Itop);
            
          %  Itop = imadjust(Itop);

%             mu = 1;
%             opts.beta = [1 1 0];
%             opts.print = true;
%             opts.methd = 'l2';
%             out = deconvtv(double(Itop), 1, mu, opts);
%             
%             I_tv = uint8(out.f);
%   
            
            

            %Itop = imtophat(imadjust(I_raw), se);
            %    Ien = imadjust(Itop);

      %     Ien = imgaussfilt(Itop,2);
           
%              ax(1)=subplot(121); imagesc(I_raw);
%             ax(2)=subplot(122); imagesc(I_tv);
%             linkaxes(ax,'xy')
% %             
            
            
         %   Ien = I_tv;
            
            Ien = Itop;
            
          %  Ien = imadjust(Ien);
            %Ib = imbinarize(Ien, graythresh(Ien)*1.5);
            
            Ib = Itop > 70; Ib = bwareaopen(Ib, 10);
            
            GP = bwmorph(Ib, 'close'); %for CoilE
            
            
            %GP = bwmorph(Ien > 60, 'close'); % for Untag
            GP = bwareaopen(GP, 5);
            GP = imdilate(GP, strel('disk',2));


            %GP = entropyfilt(Ien) > 3.7;

%             entropyI = entropyfilt(Ien);
%             GP = entropyI > 3.25;

            GP = imfill(GP,'holes');
            GP = bwareaopen(GP, 5);

        %     % WATERSHED 1
        %     D = bwdist(~GP, 'chessboard'); %quasi-euclidean');
        %     D = -D;
        %     D(~GP) = Inf;
        %     
        %     L = watershed(D);
        %     L(~GP) = 0;
        %     
        %     L = bwareaopen(L, 5);
        %     

            %fgm = imregionalmax(Ien) & GP; 
            %fgm = imregionalmax(imgaussfilt(Itop,2)) & GP; 
            fgm = imregionalmax(imgaussfilt(Itop,2)) & GP; 



            D = bwdist(fgm); DL = watershed(D);
            bgm = DL == 0;

            L = GP & ~bgm;


          %  L = GP; % IMSI

        %     L = []; s = [];
        %     L = bwlabel(GP);
        %     s = regionprops('table',L, I_raw, 'Area', 'MeanIntensity', 'MaxIntensity');
        %     select = find([s.Area > 10] & [s.Area < 800] );
        % 
        %     bw2 = ismember(L , select);
        %     imagesc(I_raw), hold on, visboundaries(GP,'Color','g'), visboundaries(bw2)
        
        else
            
            GP = zeros(size(I_raw,1),size(I_raw,2));
                
          
            se = strel('disk', 10);
            %Itop = imtophat(imadjust(I_raw), se);
            Itop = imtophat((I_raw), se);
            
     
            
         %   Ien = I_tv;
            
            Ien = Itop;
            
          %  Ien = imadjust(Ien);
            %Ib = imbinarize(Ien, graythresh(Ien)*1.5);
            
            Ib = Itop > 70; Ib = bwareaopen(Ib, 10);
            
            GP = bwmorph(Ib, 'close'); %for CoilE
            
            
            %GP = bwmorph(Ien > 60, 'close'); % for Untag
            GP = bwareaopen(GP, 5);
            GP = imdilate(GP, strel('disk',2));


            %GP = entropyfilt(Ien) > 3.7;

%             entropyI = entropyfilt(Ien);
%             GP = entropyI > 3.25;

            GP = imfill(GP,'holes');
            GP = bwareaopen(GP, 5);

            %L = zeros(size(I_raw,1),size(I_raw,2));
                fgm = imregionalmax(imgaussfilt(Itop,1)) & GP; 



            D = bwdist(fgm); DL = watershed(D);
            bgm = DL == 0;

            L = GP & ~bgm;

            
        end
            Ioverlay = imoverlay(mat2gray(I_raw, [0 max(double(I_raw(:)))]*0.8) , bwperim(imdilate(GP,strel('disk',1))), [1 0 0]);

            Ioverlay = imoverlay(Ioverlay, bwperim(L > 0), [0 1 0]);

            %Ioverlay = imoverlay(Ioverlay, bwperim(GP_dot), [0 1 1]);

            figure
                ax(1)=subplot(121); imagesc(I_raw);
            ax(2)=subplot(122); 
%             
            imagesc(Ioverlay)
            
            linkaxes(ax,'xy')
           % imagesc(Ioverlay)
           imwrite(Ioverlay, sprintf('%s%s/%s-Overlay.png',  path_name, dir_name(l).name, fname.name(1:end-4)),'tif');
            save(sprintf('%s%s/%s-PTmask.mat', path_name, dir_name(l).name, fname.name(1:end-4)), 'GP', 'L');
    end
end

        