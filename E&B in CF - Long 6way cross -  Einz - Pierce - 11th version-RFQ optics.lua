--[[
2022-02-20
LAS ion optics

]]


simion.workbench_program()

adjustable target = 1345
adjustable ele2 = 1340
adjustable qb_ele10_UR = 1332.5
adjustable qb_ele20_DR = 1267.5
adjustable qb_ele30_UL = 1267.5
adjustable qb_ele40_DL = 1332.5
adjustable qb_ele30_UL_deflect = 1332.5
adjustable bender_switching_time = 5 
-- this is microsecond
--[[
function segment.flym()
	print("flym")
	print("ele2:", ele2)

 time_scan_step = 1
start_time = 5
iteration = 10

	for i = 1,iteration do
	
	bender_switching_time = (i-1) *time_scan_step + start_time
	print("bender_switching_time ",bender_switching_time )
	
	run()
	
	print("Ion mass:", mass)
		
	
end

end
--]]
-- collisions adjustables
adjustable _p_cooling_mTorr = 100 -- gas pressure until _T_cooling
adjustable _t_cooling = 50 -- cooling time
adjustable _p_gas_mTorr = 1 -- gas pressure after _t_cooling
adjustable _x_vacuum = -343 -- end X-coordinate of gas-filled region
adjustable _mark_collisions = 1 -- mark collisions flag
adjustable _M_gas_amu = 4 -- gas molecule mass if not 'N2' or 'He'
adjustable _alpha_gas_A3 = 0 -- gas polarizability in A^3 if not 'N2' or 'He'
adjustable _T_gas_Kelvin = 300 -- absolute gas temperature
adjustable _sigma_ion_A2 = 0 -- ion cross section in A^2 if not 0
adjustable _wx_gas = 0 -- gas x-velocity
adjustable _wy_gas = 0 -- gas y-velocity
adjustable _wz_gas = 0 -- gas z-velocity

-- RF adjustables
adjustable _F_MHz = 1.3 -- RF frequency
adjustable _V0p_V = 180 -- RF amplitude (0-peak)
adjustable _RF_phase_degr = 0 -- RF initial phase
adjustable _V_DC = 1300

-- RF globals
omega = 1
phase = 0

function segment.initialize_run()

sim_trajectory_image_control = 1

end

function segment.initialize()
	twopi = 2.0*math.pi
	omega = twopi*_F_MHz -- omega for RF
	phase = _RF_phase_degr/180.0*math.pi -- phase for RF
	sgas = 0.09174*sqrt(_T_gas_Kelvin/_M_gas_amu)
    if (_M_gas_amu == 29) then  
		_alpha_gas_A3 = 1.734
    elseif (_M_gas_amu == 4) then   
	    _alpha_gas_A3 = 0.203
    else
    end    
end


function segment.tstep_adjust()

    ion_time_step = 0.001 
 
end



function segment.fast_adjust()


    if ion_instance == 1 then
		adj_elect01 = target
		adj_elect02 = ele2
		adj_elect10 = qb_ele10_UR
		adj_elect20 = qb_ele20_DR
		adj_elect30 = qb_ele30_UL
		adj_elect40 = qb_ele40_DL
	end
	
		

	if ion_time_of_flight < bender_switching_time then
		adj_elect30 = qb_ele30_UL_deflect
	end
	
	local rfv
	if ion_instance == 1 then
		rfv = _V0p_V*sin(omega*ion_time_of_flight+phase)
		adj_elect[301] = _V_DC+rfv
		adj_elect[302] = _V_DC+rfv
		adj_elect[303] = _V_DC-rfv
		adj_elect[304] = _V_DC-rfv
	end			
				
end



function segment.other_actions()
end

function segment.terminate()

end