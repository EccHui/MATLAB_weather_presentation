% Get wheather information with user's ip address.
% Using Baidu API, require JSONlib v1.2.
% Much information of weather is unused.
% Ecc - 05/11/16
% function: class, regexp, strcmp

clear;
flag = 0;
ak = 'MpqsTie8vuSASCcHGGurk1EG4ZkAOkdl';
pm_format = {0,'一级','优','绿色';
             51,'二级','良','黄色';
             101,'三级','轻度污染','橙色';
             151,'四级','中度污染','红色';
             201,'五级','重度污染','紫色';
             301,'六级','严重污染','褐红色'};
url_loc = ['http://api.map.baidu.com/location/ip?ak=' ak '&coor=bd09ll'];
loc = webread(url_loc);
location = loc.content.address(1:end-1);
url_wea = ['http://api.map.baidu.com/telematics/v3/weather?location=' location '&output=json&ak=' ak];
data = loadjson(webread(url_wea));
if strcmp(data.status,'success')
    city = data.results{1,1}.currentCity;
    pm25 = data.results{1,1}.pm25;
    date = data.results{1,1}.weather_data{1,1}.date;
    weather = data.results{1,1}.weather_data{1,1}.weather;
    wind = data.results{1,1}.weather_data{1,1}.wind;
    temperature = data.results{1,1}.weather_data{1,1}.temperature;
    for i = 1:1:5
        low = pm_format{i,1};
        high = pm_format{i+1,1};
        num = str2num(pm25);
        if (num >= low) && (num < high)
            polution = pm_format{i,3};
            flag = 1;
            break;
        end
    end
    if flag == 0
        polution = pm_format{6,3}; 
    end
    fprintf('地点：  %s\n',city);
    fprintf('日期：  %s\n',date);
    fprintf('天气：  %s\n',weather);
    fprintf('风级：  %s\n',wind);
    fprintf('温度：  %s\n',temperature);
    fprintf('pm2.5： %s - %s\n',pm25,polution);
else
    error('Server is not available.');
end
