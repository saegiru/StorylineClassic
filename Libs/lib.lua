--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Resize button
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

--local Storyline_ResizeShadowFrame = getglobal("Storyline_ResizeShadowFrame");

function Storyline_API.lib.initResize(resizeButton)
	assert(resizeButton.resizableFrame, "resizableFrame key is not set.");
	assert(resizeButton.minWidth, "minWidth key is not set.");
	assert(resizeButton.minHeight, "minHeight key is not set.");
	--setTooltipAll(resizeButton, "BOTTOMLEFT", 0, 0, Storyline_API.locale.getText("SL_RESIZE"), Storyline_API.locale.getText("SL_RESIZE_TT"));
	local parent = getglobal(resizeButton.resizableFrame);
	local minWidth = tonumber(resizeButton.minWidth);
	local minHeight = tonumber(resizeButton.minHeight);
	resizeButton:RegisterForDrag("LeftButton");
	resizeButton:SetScript("OnDragStart", function()
		if not this.onResizeStart or not this.onResizeStart() then
			Storyline_ResizeShadowFrame.minWidth = resizeButton.minWidth;
			Storyline_ResizeShadowFrame.minHeight = resizeButton.minHeight;
			Storyline_ResizeShadowFrame:ClearAllPoints();
			Storyline_ResizeShadowFrame:SetPoint("CENTER", parent, "CENTER", 0, 0);
			Storyline_ResizeShadowFrame:SetWidth(parent:GetWidth());
			Storyline_ResizeShadowFrame:SetHeight(parent:GetHeight());
			Storyline_ResizeShadowFrame:Show();
			Storyline_ResizeShadowFrame:StartSizing();
			this.isSizing = true;
		end
	end);
	resizeButton:SetScript("OnDragStop", function()
		if this.isSizing then
			Storyline_ResizeShadowFrame:StopMovingOrSizing();
			this.isSizing = false;
			local height, width = Storyline_ResizeShadowFrame:GetHeight(), Storyline_ResizeShadowFrame:GetWidth()
			Storyline_ResizeShadowFrame:Hide();
			if height < minHeight then
				height = minHeight;
			end
			if width < minWidth then
				width = minWidth;
			end
			parent:SetWidth(width);
			parent:SetHeight(height);
			if this.onResizeStop then
				--C_Timer.After(0.1, function()
					this.onResizeStop(width, height);
				--end);
			end
		end
	end);
end

function Storyline_ResizeShadowFrameUpdateText()
	local height, width = this:GetHeight(), this:GetWidth();
	local minWidth = tonumber(this.minWidth);
	local minHeight = tonumber(this.minHeight);
	local heightColor, widthColor = "|cff00ff00", "|cff00ff00";
	if height < minHeight then
		heightColor = "|cffff0000";
	end
	if width < minWidth then
		widthColor = "|cffff0000";
	end
	Storyline_ResizeShadowFrameText:SetText(widthColor .. math.ceil(width) .. "|r x " .. heightColor .. math.ceil(height));
end