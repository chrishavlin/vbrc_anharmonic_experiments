function [T_K, P_GPa, G, K, rho] = calculate_unrelaxed_moduli_density(T_K_1d, P_GPa_1d, fo_fa_vol_frac_modes)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % modified from ABERSHACKER16/rockvelcalculate.m
    %
    % This function uses the Abers and Hacker 2016 methods for calculating
    % moduli and density.
    %
    % Parameters
    % ----------
    % T_K_1d
    %   1d temperature array in Kelvin
    % P_GPa_1d
    %   1d pressure array in GPa
    % fo_fa_vol_frac_modes
    %   2-element array of (forserite fraction, fayalite fraction). Values are
    %   nominal volume fractions, and are corrected by the calculation by
    %   re-weighting with densities of the endmember modes.
    %
    % Returns
    % -------
    % T_K, P_GPa
    %   2D temperature and pressure arrays, result of meshgrid(T_K_1d, P_GPa_1d)
    % G, K
    %   unrelaxed shear and bulk moduli at temperature and pressure of interest
    % rho
    %   density at temperature and pressure of interest
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    minerals={'fo', 'fa'};
    vol_frac_modes = fo_fa_vol_frac_modes;  % rename for convenience

    % Load mineral database
    [minpropar, compar]=ah16_loaddb('AbersHackerMacroJan2016.txt');
    if isempty(minpropar)
        disp('ERROR on AH16_LOADDB')
        return
    end

    % build the temperature, pressure grid
    nT = numel(T_K_1d);
    nP = numel(P_GPa_1d);
    [T_K, P_GPa] = meshgrid(T_K_1d, P_GPa_1d);

    % initialize output arrays for moduli and density
    G = zeros(size(T_K));
    K = zeros(size(T_K));
    rho = zeros(size(T_K));

    for i_T = 1:nT
        for i_P = 1:nP
            tt = T_K(i_P, i_T)-273.;  %deg C
            pp = P_GPa(i_P, i_T);  % GPa

            %% Calcuate properties for a single P,T and get density at those conditions
            [modu,modhsm,modhsp,modvrm,modvrp,rhos]=ah16_rockvel(tt,pp, minpropar, minerals,vol_frac_modes);

            % first calculate correct molar Fo90 volume fractions: want 90 mol% fo
            %    for high accuracy this requires 2 calls to ah16_rockvel, the first
            %    to get rhos for nominal modes (above), then a second with correct vol% modes.
            k_fo=find(strcmp('fo',{minpropar.name}));
            k_fa=find(strcmp('fa',{minpropar.name}));
            modecor=[minpropar(k_fo).gfw minpropar(k_fa).gfw]./[rhos(k_fo) rhos(k_fa)]; % cm3/mol per phase

            modes_c = vol_frac_modes.*modecor;
            [modu,modhsm,modhsp,modvrm,modvrp,compos]=ah16_rockvel(tt,pp, minpropar, minerals,modes_c,compar);

            # store in our moduli and density arrays with expected units for VBRc
            G(i_P, i_T) = modu.g*1e9;
            K(i_P, i_T) = modu.k*1e9;
            rho(i_P, i_T) = modu.r;
        end
    end

end