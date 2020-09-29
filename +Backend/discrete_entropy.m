%A function to calculate the discrete entropy for the resultant image.
function entropy_img = discrete_entropy(image)

[row col] = size(image);

%Calculating the new probabilities.
prob = zeros(256,1);
freq=zeros(256,1);
num_of_pixels = row*col;
for x=1:row
    for y=1:col
    pix_val=image(x,y);
    freq(pix_val+1)=freq(pix_val+1)+1;
    prob(pix_val+1)=freq(pix_val+1)./num_of_pixels;
    end
end
%**********************************

%Applying the discrete entropy formula.
calculated_sum=0;
p=prob(prob>0);
calculated_sum=-sum(p.*log2(p));
entropy_img=calculated_sum;
%**************************************