%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Example of using Abers and Hackers 2016 with the VBRc:
% - unrelaxed moduli and density calculated with Abers and Hackers
% - moduli
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; close all;

%%%%%%%%%%%%%%%%%%
% Initialization %
%%%%%%%%%%%%%%%%%%

# add relevant paths : change these as needed
addpath(getenv('vbrdir'))  # the VBRC installation directory
addpath("ABERSHACKER16")  # The Aber & Hackers 2016 directory
vbr_init();

% Set conditions for anharmonic calculation
T_K_1d = linspace(1000, 1773, 10); % temperature range
P_GPa_1d = linspace(1, 4, 15); % pressure range
fo_fa_vol_frac_modes=[90 10]; % nominal volume fraction of Fo and Fa

% frequency range for VBRc anelastic calculation
frequency_Hz = logspace(-5, -1, 50);

% additional state variables required for VBRc anelastic calculation, treated as
% constants in this example
constants.phi = 0.0;
constants.sig_MPa = 0.1;
constants.dg_um = 0.01 * 1e6;

% method selection for the VBRc calculation for anelastic properties
VBR.in.elastic.methods_list={'anharmonic';};
VBR.in.anelastic.methods_list={'eburgers_psp';'andrade_psp';};

%%%%%%%%%%%%%%%%%
% Calculations! %
%%%%%%%%%%%%%%%%%

% Step 1: calculate anharmonic moduli and density with Abers & Hacker 2016
[T_K, P_GPa, G, K, rho] = calculate_unrelaxed_moduli_density(T_K_1d, P_GPa_1d, fo_fa_vol_frac_modes);

% Step 2: use the outputs from Abers and Hacker as inputs for VBRc anelastic calculation

% fist set state variables: copy over Abers and Hacker inputs and outputs.
% state variable inputs go in VBR.in.SV:
VBR.in.SV.rho = rho;
VBR.in.SV.P_GPa = P_GPa; % pressure [GPa]
VBR.in.SV.T_K = T_K; % temperature [K]
% the moduli at elevated temperature and pressure are set in VBR.in.elastic:
VBR.in.elastic.Gu_TP = G;
VBR.in.elastic.Ku_TP = K;

% and set the remaining state variables that will not vary
VBR.in.SV.f = frequency_Hz; % frequency [Hz]
VBR.in.SV.sig_MPa = constants.sig_MPa * ones(size(T_K)); % differential stress [MPa]
VBR.in.SV.phi = constants.phi * ones(size(T_K)); % melt fraction
VBR.in.SV.dg_um = constants.dg_um * ones(size(T_K)); % grain size [um]

% now ready for the calculation!
VBR = VBR_spine(VBR);

%%%%%%%%%%%%
% Plotting %
%%%%%%%%%%%%

% plot log10(Q) for a single frequency
figure()
subplot(1,2,1)
contourf(T_K_1d, P_GPa_1d, log10(squeeze(VBR.out.anelastic.eburgers_psp.Q(:,:,end))))

colorbar()
xlabel("Temperature [K]")
ylabel("Pressure [GPa]")
title("log10(Q), extended burgers pseudo-period (JF10)")
cmapname = "cubehelix";
colormap(cmapname)
subplot(1,2,2)
contourf(T_K_1d, P_GPa_1d, log10(squeeze(VBR.out.anelastic.andrade_psp.Q(:,:,end))))

colorbar()
colormap(cmapname)
xlabel("Temperature [K]")
ylabel("Pressure [GPa]")
title("log10(Q), andrade pseudo-period (JF10)")
set(findall(gcf,'-property','FontSize'),'FontSize',18)

figure()
iT = numel(T_K_1d);
iP = numel(P_GPa_1d);
f = VBR.in.SV.f;
semilogx(f, squeeze(VBR.out.anelastic.andrade_psp.M(iP, iT, :)/1e9), 'k','displayname', 'andrade', 'linewidth',1.5)
hold all
semilogx(f, squeeze(VBR.out.anelastic.eburgers_psp.M(iP, iT, :)/1e9),'--r', 'displayname', 'eburgers', 'linewidth',1.5)
legend('location', 'NorthWest')
xlabel('frequency [Hz]')
ylabel('M [GPa]')
title('1500 C, 4 GPa')
set(findall(gcf,'-property','FontSize'),'FontSize',18)

