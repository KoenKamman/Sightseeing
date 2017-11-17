local EventFrame = CreateFrame("Frame");
EventFrame:RegisterEvent("PLAYER_LOGIN");
EventFrame:SetScript("OnEvent", 

	function(self,event,...)

		-- Add Circle to Worldmap

		local Frame = CreateFrame("Frame", "Overlay", WorldMapDetailFrame);
		Frame:SetAllPoints();
		Frame:SetFrameStrata("FULLSCREEN_DIALOG");

		unitX, unitY = GetPlayerMapPosition("player");
		width, height = Frame:GetSize();

		textureSize = 40;
		Frame.Texture = Frame:CreateTexture(nil,"OVERLAY");
		Frame.Texture:SetSize(textureSize,textureSize);

		Frame.Texture:SetPoint("TOPLEFT", WorldMapDetailFrame, (width*unitX)-textureSize/2, (-height*unitY)+textureSize/2);
		Frame.Texture:SetTexture("Interface\\Minimap\\UI-QuestBlob-MinimapRing");

		
		-- Add Interface Options

		local AddonOptions = {};
		AddonOptions.mainPanel = CreateFrame( "Frame", "Sightseeing", UIParent );
		AddonOptions.mainPanel.name = "Sightseeing";

		InterfaceOptions_AddCategory(AddonOptions.mainPanel);
		
		AddonOptions.viewpointPanel = CreateFrame( "Frame", "SightseeingViewpoint", AddonOptions.mainPanel);
		AddonOptions.viewpointPanel.name = "Viewpoint";
		AddonOptions.viewpointPanel.parent = AddonOptions.mainPanel.name;

		InterfaceOptions_AddCategory(AddonOptions.viewpointPanel);


		-- Register config cmd

		SLASH_CONFIG1 = "/sightseeing"
		SlashCmdList["CONFIG"] = function(self, txt)
			InterfaceOptionsFrame_OpenToCategory(AddonOptions.mainPanel.name);
		end

	end

);
