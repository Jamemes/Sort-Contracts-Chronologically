Hooks:Add("LocalizationManagerPostInit", "sort_jobs_chronologically_loc", function(...)
	LocalizationManager:add_localized_strings({
		menu_chronological_order = "In Chronological Order",
		menu_from_the_last = "From the Last",
		menu_from_the_first = "From the begining",
	})

	if Idstring("russian"):key() == SystemInfo:language():key() then
		LocalizationManager:add_localized_strings({
		menu_chronological_order = "В хронологическом порядке",
		menu_from_the_last = "С последнего",
		menu_from_the_first = "C начала",
		})
	end
end)


local chronological_order = {
	"menu_chronological_order",
	"_setup_chronological_order"
}

table.insert(ContractBrokerGui.tabs, 2, chronological_order)

local jobs_index = tweak_data.narrative._jobs_index
local function table_move(id, index)
	table.delete(jobs_index, id)
	table.insert(jobs_index, tweak_data.narrative:get_index_from_job_id(index) + 1, id)
end

table_move("haunted", "family")
table_move("arm_fac", "haunted")
table_move("arm_par", "arm_fac")
table_move("arm_hcm", "arm_par")
table_move("arm_und", "arm_hcm")
table_move("arm_cro", "arm_und")
table_move("roberts", "arm_cro")
table_move("arm_for", "rat")
table_move("cage", "arm_for")
table_move("hox_3", "cage")
table_move("cane", "pbr2")
table_move("dark", "man")
table_move("moon", "help")
table_move("friend", "moon")
table_move("wwh", "glace")
table_move("hvh", "dah")
table_move("sah", "des")
table_move("bph", "sah")

local function get_jobs(job_id)
	for index, entry_name in ipairs(jobs_index) do
		if entry_name == job_id then
			return index
		end
	end
	
	return 0
end

local function sort(x, y)
	local job_x = get_jobs(x.job_id)
	local job_y = get_jobs(y.job_id)

	if job_x ~= job_y then
		if not managers.menu_component:contract_broker_gui() or managers.menu_component:contract_broker_gui()._current_filter == 1 then
			return job_y < job_x
		else
			return job_x < job_y
		end
	end
end

function ContractBrokerGui:_setup_chronological_order()
	local played = {
		{
			"menu_from_the_last"
		},
		{
			"menu_from_the_first"
		}
	}
	local last_y = 0

	for _, filter in ipairs(played) do
		local text = self:_add_filter_button(filter[1], last_y)
		last_y = text:bottom() + 1
	end

	self:set_sorting_function(sort)
end
