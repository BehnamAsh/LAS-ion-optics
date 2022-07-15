--[[
2022-07-13
LAS ion optics

]]


simion.workbench_program()

adjustable target = 1345
adjustable ele2 = 1340
adjustable einzel = 1262
adjustable qb_ele10_UR = 1332.8
adjustable qb_ele20_DR = 1267.2
adjustable qb_ele30_UL = 1267.2
adjustable qb_ele40_DL = 1332.8
adjustable qb_ele30_UL_deflect = 1332.8
adjustable bender_switching_time = 5 
adjustable py_testplane = 240 -- z position of test plane where ions are killed [mm]
local prefix = "test123"
reached_testplane = {}
-- this is microsecond

function segment.flym()
	print("flym")
	print("ele2:", ele2)

--[[time_scan_step = 1
start_time = 5 
-- V_min
i_max = 10 -- V_max
i_step = 1 -- delta_V

	for i = 1, i_max, i_step do
	
	    bender_switching_time = (i-1) *time_scan_step + start_time
	    print("bender_switching_time ",bender_switching_time )
	
	    run()
	
	    print("Ion mass:", mass)
		
	
    end
]]	


V_min = 1345 
V_max_step = 6 
delta_V = 1 

U_min = 1262 
U_max_step = 4 
delta_U = 1

	for i = 1, V_max_step, delta_V do
        
	    for j = 1, U_max_step, delta_U do
	        target = (i-1) *delta_V + V_min
		    einzel = (j-1) *delta_U + U_min
	        print("target ",target )
			print("einzel ",einzel )
	
	        run()
	
	        print("Ion mass:", mass)
			
		end
		
	
    end

end

function segment.initialize() 
    reached_testplane[ion_number] = 0 -- 0 = no, 1 =yes
end

function segment.tstep_adjust()

    ion_time_step = 0.001 
 
end



function segment.fast_adjust()


    if ion_instance == 1 then
		adj_elect01 = target
		adj_elect02 = ele2
		adj_elect05 = einzel
		adj_elect10 = qb_ele10_UR
		adj_elect20 = qb_ele20_DR
		adj_elect30 = qb_ele30_UL
		adj_elect40 = qb_ele40_DL
	end
	
		

	if ion_time_of_flight < bender_switching_time then
		adj_elect30 = qb_ele30_UL_deflect
	end
	
			
				
end



function segment.other_actions()
  if ion_py_mm >= py_testplane then
    ion_splat = 1
	reached_testplane[ion_number] = 1 
  end 
  
  
end

function segment.terminate() -- loops over all ions
  -- Save data into a CSV file
  local testplane_file = assert(io.open(prefix.. "_target" .. target .. "_einzel" .. einzel .. "_testplane_data.csv", "a"))
  -- TODO: Write header to file
  if reached_testplane[ion_number] == 1 then 
  testplane_file:write(ion_number, "\,", ion_px_mm, "\,", ion_py_mm, "\n")
  end 
  testplane_file:flush() -- save file
  testplane_file:close() -- close file
  
end