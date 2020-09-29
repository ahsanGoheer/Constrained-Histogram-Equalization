%Code for the implementation of Image Edge and Contrast Enhancement Using Unsharp Masking and Constrained Histogram Equalization 
function [output output_sharp]=modified_histeq(image,v,r,sigma,filter,Pl,k)

%Converting image to grayscale before processing.
[rows columns channels]=size(image);
if channels==3
    image=rgb2gray(image);
end

%***********************************************

%Setting the minimum and maximum intensity level for an image.
X0=0;
X1=255;
%***********************************************

%Finding the probability of occurance of each intensity.
prob = zeros(256,1); %Vector for probabilities.
Nk=zeros(256,1); %Vector for frequencies (No of occurance of each intensity).
num_of_pixels = rows*columns;
for x=1:rows
    for y=1:columns
    pix_val=image(x,y);
    Nk(pix_val+1)=Nk(pix_val+1)+1;
    prob(pix_val+1)=Nk(pix_val+1)/num_of_pixels;
    end
end

%***************************************************

%Apply the Weighting and Thresholding Algorithm.
Pu = v*max(prob(:)); %Upper Constraint.
fixed_prob=zeros(size(prob)); % Vector for modified probabilities.
CDF=zeros(size(prob)); %Vector for cummulative distribution funcition.
for i=1:size(prob)
        if prob(i)>Pu
            fixed_prob(i)=Pu;
%         elseif Pl<prob(i)<=Pu
%             fixed_prob(i)=((abs(prob(i)-Pl)/Pu-Pl)^r)*Pu;
        elseif prob(i)<=Pl
            fixed_prob(i)=0;
        else
             fixed_prob(i)=((abs(prob(i)-Pl)/Pu-Pl)^r)*Pu;
        end
end
%***********************************************

%Calculating the Cummulative Distribution Function. 
CDF=cumsum(fixed_prob);
%************************************************

%Applying Modified Histogram Equalization Function in order to obtain the
%Image.
new_image=zeros(size(image));
for Intensity=2:size(fixed_prob)
new_image(image==Intensity-1)=X0+(X1-X0)*(0.5*abs(fixed_prob(Intensity))+abs(CDF(Intensity-1)));
end 
%************************************************************************

%Applying Unsharp Masking in order to Highlight the Edges in the Image.
filter=fspecial('gaussian',filter,sigma);
blurred_image=imfilter(new_image,filter);
mask=new_image-blurred_image;
output_sharp=new_image+k*mask;
output=new_image;
%*********************************************************************