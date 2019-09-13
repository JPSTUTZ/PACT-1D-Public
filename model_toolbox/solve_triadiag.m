function [ conc_t1 ] = solve_triadiag( a_coeffs, b_coeffs, c_coeffs, d_coeffs, NLEV)
%do the tridiagonal matrix algrothim

%setting up a temp variable
q       = zeros(NLEV,1);
conc_t1 = zeros(NLEV,1);
conc_t1 = d_coeffs;

%for level 1
q(1)       = -c_coeffs(1) / b_coeffs(1);
conc_t1(1) =   conc_t1(1) / b_coeffs(1);

for  k=2:NLEV
  m          =   1. / (b_coeffs(k) + a_coeffs(k)*q(k-1));
  q(k)       =  -c_coeffs(k)*m;
  conc_t1(k) = (conc_t1(k)-a_coeffs(k)*conc_t1(k-1))*m;
end

for  k=NLEV-1:-1:1
  conc_t1(k) = conc_t1(k) + q(k)*conc_t1(k+1);
end

end

