function savepath=check_mkdir_SPR(rootpath,newfolder)  %��rootpath������newfolder�����û��������������newfolder��·��
narginchk(1,2);
if nargin == 2
    if ~exist(fullfile(rootpath,newfolder) ,'dir')
        mkdir(fullfile(rootpath,newfolder));
    end
    savepath=[rootpath '\' newfolder];
elseif nargin == 1
    if ~exist(rootpath ,'dir')
        mkdir(rootpath);
    end
    savepath=rootpath;
end

end