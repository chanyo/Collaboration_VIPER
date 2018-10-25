clear all
clc
close all



%path_name = './8D3/'; % DONE
% path_name = './ab1086/';  % DONE
%path_name = './VIPER live/';  %DONE
%path_name = './VIPER fixed/'; % DONE
% path_name = './TF/'; % DONE
%path_name = './H684/';  %DONE
path_name = './ab216665/'; % DONE

%path_name = './ab82411/'; % DONE



 


% DONE: VIPER


dir_name = dir(sprintf('%s', path_name));

N_stat = []; idx = 0;
for l=3:length(dir_name)
    
   
    %l=3;
 
   % dir_name(l).name
    if length(dir_name(l).name) > 2 
        idx = idx + 1;
      fname = dir(sprintf('%s%s/*.mat', path_name, dir_name(l).name));

      load(sprintf('%s%s/%s', path_name, dir_name(l).name, fname.name));

            %save(sprintf('%s%s/%s-PTmask.mat', path_name, dir_name(l).name, fname.name(1:end-4)), 'GP', 'L');
%             
%               bw = bwconncomp(imdilate(M.mask_refine, strel('disk',1)));
        bw = []; bw = bwconncomp(GP);
        label = [];label = bwlabeln(L);
%     
        mask = zeros(size(GP,1),size(GP,2));
        for j=1:bw.NumObjects
            if length(find(unique(label(bw.PixelIdxList{j}))>0)) == 1
                mask ( bw.PixelIdxList{j}) = 1;
            elseif length(find(unique(label(bw.PixelIdxList{j}))>0)) == 2
                mask ( bw.PixelIdxList{j}) = 2;
            elseif length(find(unique(label(bw.PixelIdxList{j}))>0)) > 2
                mask ( bw.PixelIdxList{j}) = 3;
            end
        end

        b0 = []; b1 = []; b2 = []; b3 = [];
        b0 = bwconncomp(label);
        b1 = bwconncomp(mask==1);
        b2 = bwconncomp(mask==2);
        b3 = bwconncomp(mask==3);
%     
         N_stat = [ N_stat; b0.NumObjects b1.NumObjects  b2.NumObjects  b3.NumObjects ];
         F_name{idx} = dir_name(l).name;
    end
end

N_total = N_stat(:,1);
N_1 = N_stat(:,2);
N_2 = N_stat(:,3);
N_more = N_stat(:,4);

Fname = F_name';

T = table(N_total, N_1, N_2, N_more, Fname);

writetable(T, sprintf('%s.csv', path_name(3:end-1)));
        