function [d_coeffs] = coeffs_diffusion_1d(spec_t0,beta,dp,dm,NLEV,v_surf_t, dt_diff, BOX_WALL)

d_coeffs = zeros(NLEV,1);

%special case for the d_coeffs for k=1 
d_coeffs(1) = (1. - beta*dp(1) - beta*v_surf_t*dt_diff/(BOX_WALL(1))  )*spec_t0(1) + beta*dp(1)*spec_t0(2);

%calcuate d_coeffs
for k=2:NLEV-1
    d_coeffs(k) = (1. - beta*(dp(k)+dm(k)))*spec_t0(k) + beta*(dp(k)*spec_t0(k+1)+dm(k)*spec_t0(k-1));
end

%special case for the NLEV d_coeffs
d_coeffs(NLEV) = (1. - beta*dm(NLEV))*spec_t0(NLEV) + beta*dm(NLEV)*spec_t0(NLEV-1);

end

