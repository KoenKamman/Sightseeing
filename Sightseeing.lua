local EventFrame = CreateFrame("Frame");
EventFrame:RegisterEvent("PLAYER_LOGIN");
EventFrame:SetScript("OnEvent", 

	function(self,event,...)

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

	end

);
