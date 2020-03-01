function [cornerPts, numCornerPts] = HarrisCornerDetector(image, sigma, thres)
    img = imread(image); 
    if length(size(img))>2
        img = rgb2gray(img);
    end 
    fx = [-1 0 1;-1 0 1;-1 0 1];
    fy = fx';
    Ix = filter2(fx,img);
    Iy = filter2(fy,img); 
    Ix2 = Ix.^2;
    Iy2 = Iy.^2;
    Ixy = Ix.*Iy;
    h= fspecial('gaussian',[7 7],sigma); 
    Ix2_g = filter2(h,Ix2);
    Iy2_g = filter2(h,Iy2);
    Ixy_g = filter2(h,Ixy);
    height = size(img,1);
    width = size(img,2);
    result = zeros(height,width); 
    R = zeros(height,width);
    Rmax = 0; 
    for i = 1:height
        for j = 1:width
            H = [Ix2_g(i,j) Ixy_g(i,j);Ixy_g(i,j) Iy2_g(i,j)]; 
            R(i,j) = det(H) - thres * (trace(H))^2;
            if R(i,j) > Rmax
                Rmax = R(i,j);
            end;
        end;
    end;
    numCornerPts = 0;
    for i = 2:height-1
        for j = 2:width-1
            if R(i,j) > 0.1*Rmax && R(i,j) > R(i-1,j-1) && R(i,j) > R(i-1,j) && R(i,j) > R(i-1,j+1) && R(i,j) > R(i,j-1) && R(i,j) > R(i,j+1) && R(i,j) > R(i+1,j-1) && R(i,j) > R(i+1,j) && R(i,j) > R(i+1,j+1)
                result(i,j) = 1;
                numCornerPts = numCornerPts+1;
            end;
        end;
    end;
    [res_y, res_x] = find(result == 1);
    cornerPts = [res_x, res_y];
end