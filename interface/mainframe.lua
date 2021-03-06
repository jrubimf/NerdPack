local n_name, NeP = ...
local logo = '|T'..NeP.Media..'logo.blp:10:10|t'
local L = NeP.Locale

NeP.Interface.MainFrame = NeP.Interface:BuildGUI({
	key = 'NePMFrame',
	width = 100,
	height = 60,
	title = logo..n_name,
	subtitle = 'v:'..NeP.Version..' - '..NeP.Branch
})
NeP.Interface.MainFrame:SetEventListener('OnClose', function(self)
	NeP.Core:Print(L:TA('Any', 'NeP_Show'))
end)

local menuFrame = CreateFrame("Frame", 'NeP_DropDown', NeP.Interface.MainFrame.frame, "UIDropDownMenuTemplate")
menuFrame:SetPoint("BOTTOMLEFT", NeP.Interface.MainFrame.frame, "BOTTOMLEFT", 0, 0)
menuFrame:Hide()

local DropMenu = {
	{text = logo..'['..n_name..' |rv:'..NeP.Version..']', isTitle = 1, notCheckable = 1},
	{text = L:TA('mainframe', 'CRS'), hasArrow = true, menuList = {}},
	{text = L:TA('mainframe', 'CRS_ST'), hasArrow = true, menuList = {}}
}

function NeP.Interface:ResetCRs()
	DropMenu[2].menuList = {}
end

function NeP.Interface:SetCheckedCR(Name)
	for _,v in pairs(DropMenu[2].menuList) do
		v.checked = Name == v.text
	end
	NeP.Core:Print(L:TA('mainframe', 'ChangeCR'), Name)
end

function NeP.Interface:AddCR_ST(Name)
	table.insert(DropMenu[3].menuList, {
		text = Name,
		notCheckable = 1,
		func = function()
			self:BuildGUI(Name)
		end
	})
end

function NeP.Interface:AddCR(Spec, Name, checked)
	table.insert(DropMenu[2].menuList, {
		text = Name,
		checked = checked,
		func = function()
			NeP.CR:Set(Spec, Name)
		end
	})
end

function NeP.Interface:DropMenu()
	EasyMenu(DropMenu, menuFrame, menuFrame, 0, 0, "MENU")
end

function NeP.Interface:Add(name, func)
	table.insert(DropMenu, {
		text = tostring(name),
		func = func,
		notCheckable = 1
	})
end

NeP.Globals.Interface.Add = NeP.Interface.Add