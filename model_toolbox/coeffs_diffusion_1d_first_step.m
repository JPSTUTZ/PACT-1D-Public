function [a_coeffs b_coeffs c_coeffs dp dm beta] = coeffs_diffusion_1d_first_step(Kz, rho, BOX_WALL, BOXCH, alpha, dt_diff, NLEV, v_surf_t)

%alpha parameter to decide how much backwards and forwards integration
%there is
beta = 1-alpha;

% a_coeffs = zeros(NLEV,1);
% b_coeffs = zeros(NLEV,1);
% c_coeffs = zeros(NLEV,1);
dp = zeros(NLEV,1);
dm = zeros(NLEV,1);



% set dp and dm
%special case for level 1
density_correction = 1+(rho(2)-rho(1))/rho(1)/(BOXCH(2)-BOXCH(1))*(BOX_WALL(1)-BOXCH(1));
dp(1) = Kz(1)*density_correction/(BOXCH(2)-BOXCH(1))/BOX_WALL(1) * dt_diff;
dm(1) = 0;


for k=2:NLEV-1
    density_correction = 1+(rho(k+1)-rho(k))/rho(k)/(BOXCH(k+1)-BOXCH(k))*(BOX_WALL(k)-BOXCH(k));
    dp(k) = Kz(k)*density_correction/(BOXCH(k+1)-BOXCH(k))/(BOX_WALL(k)-BOX_WALL(k-1)) * dt_diff;
    density_correction = 1+(rho(k)-rho(k-1))/rho(k)/(BOXCH(k)-BOXCH(k-1))*(BOX_WALL(k-1)-BOXCH(k));
    dm(k) =  Kz(k-1)*density_correction/(BOXCH(k)-BOXCH(k-1))/(BOX_WALL(k)-BOX_WALL(k-1)) * dt_diff;
end

    

%special case for last box
dp(NLEV) = 0;
density_correction = 1+(rho(NLEV)-rho(NLEV-1))/rho(NLEV)/(BOXCH(NLEV)-BOXCH(NLEV-1))*(BOX_WALL(NLEV-1)-BOXCH(NLEV));
dm(NLEV) = Kz(NLEV-1)*density_correction/(BOXCH(NLEV)-BOXCH(NLEV-1))/(BOX_WALL(NLEV)-BOX_WALL(NLEV-1)) * dt_diff;

%set a_coeffs, b_coeffs, c_coeffs, d_coeffs
% for k=1:NLEV
%     a_coeffs(k) = -alpha*dm(k);
%     b_coeffs(k) = 1+alpha*(dp(k)+dm(k));
%     c_coeffs(k) = -alpha*dp(k);
% end

% JPS 4-16-19 faster code
a_coeffs = -alpha*dm;
b_coeffs = 1+alpha*(dp+dm);
c_coeffs = -alpha*dp;


% correction for deposition velocity
%b_coeffs(1) = b_coeffs(1) + alpha*v_surf_t*dt_diff/(BOX_WALL(2)-BOX_WALL(1));
b_coeffs(1) = b_coeffs(1) + alpha*v_surf_t*dt_diff/(BOX_WALL(1));


%disp(dp);
%disp(dm);

end

