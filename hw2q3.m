addpath('./code+data_Q3/data/sourceImage')
addpath('code+data_Q3/data/velocity')
addpath('code+data_Q3/readData')
source_filename = './code+data_Q3/data/sourceImage/source.mhd'
[source,origin,spacing] = loadMETA(source_filename, 1);
v_filename = './code+data_Q3/data/velocity/v0Spatial.mhd'
[velocity,v_origin,v_spacing] = loadMETA(v_filename, 1);

v_prev = velocity(1:2,:,:);
phi_old = source;
windowSize = 16;
h = [0.1, 0.05, 0.01, 0.005, 0.001];
j=1;
dvdt = zeros(size(v_prev));
DvtTvt = zeros(size(v_prev));
phi = zeros(size(v_prev));
fot_h = 0:hi(j):5;
t=0;
numIter = length(t_h)-1;
for k=1:numIter
    vx = squeeze(v_prev(1,:,:));

    vy = squeeze(v_prev(2,:,:));

    vxdx = (Dx(vx)+Dxt(vx))/2;

    vydy = (Dx(vy.').' + Dxt(vy.').')/2;
    vydx = (Dx(vy)+Dxt(vy))/2;
    vxdy = (Dx(vx.').' + Dxt(vx.').')/2;

    DvtTvt(1,:,:) = vxdx.*vx + vydx.*vy;
    DvtTvt(2,:,:) = vxdy.*vx + vydy.*vy;

    dvdx2 = (Dx(vxdx)+Dxt(vxdx))/2;
    dvdy2 = (Dx(vydy.').' + Dxt(vydy.').')/2; %is this correct?
    %divVt = dvdx2 + dvdy2;
    %K[(Dv_old)'*v_old + divVt]

    dvdt(1,:,:) = filterF(squeeze(DvtTvt(1,:,:)) + dvdx2,windowSize); %filter out high freq
    dvdt(2,:,:) = filterF(squeeze(DvtTvt(2,:,:)) + dvdy2,windowSize);
    
    v_new = v_prev + h(j)*dvdt;
    
    v_prev = v_new;
    
    
end
