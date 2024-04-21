-- This Function return the Endpoint Position off any Object
local function GetLastObjectEntPoint(object)
	local point, relativeTo, relativePoint, xOffset, yOffset = object:GetPoint(1)
	local buttonWidth = object:GetWidth()
	return xOffset + buttonWidth
end

-- Lade 3D Model über die CreatureDisplayID
local function ShowModel(itemId)
    print("1")
    local modelFrame = CreateFrame("PlayerModel", nil, MyFrame2)
    modelFrame:SetPoint("CENTER")
    modelFrame:SetSize(300, 300)
    modelFrame:SetModelScale(1.5)
    modelFrame:SetFacing(0)
    modelFrame:SetPosition(0, 0, 0)
    -- modelFrame:Hide()
    --modelFrame:SetFacing(math.rad(45))

    local isDragging = false
    local lastMouseX = 0 -- letzte Maus Posi

    -- Bei Mausklick
    modelFrame:SetScript("OnMouseDown", function(self, button)
        if button == "LeftButton" then
        isDragging = true
        lastMouseX = GetCursorPosition()
        end
    end)

    -- Bei Maus loslassen
    modelFrame:SetScript("OnMouseUp", function(self, button)
        if button == "LeftButton" then
        isDragging = false
        end
    end)

    -- Bei jeder änderung
    modelFrame:SetScript("OnUpdate", function(self, elapsed)
        if isDragging then
        local mouseX, _ = GetCursorPosition() -- hole Maus x posi
        local delta = mouseX - lastMouseX -- neue posi minus posi vom klick
        local currentFacing = modelFrame:GetFacing() -- Holt sich doe aktuelle Modeldrehung
        local newFacing = currentFacing + math.rad(delta * 0.5) -- hier ist der Drehungsfaktor

        modelFrame:SetFacing(newFacing) -- Neue ansicht nach der Drehung.
        lastMouseX = mouseX
        end
    end)

    
    modelFrame:SetDisplayInfo(itemId)
    local _, _, _, _, _, _, _, _, _, texture, _, _, _, _, _, _, displayID = GetItemInfo(itemId)
    print("Die DisplayID für ItemID " .. itemId .. " ist: " .. displayID)
    modelFrame:Show()
end

-- Default Button Height
local defaultH = 25
-- Default Space between Buttons
local defaultSpace = 10

-- Second Main
MyFrame2 = CreateFrame("Frame", "MyFrame2", UIParent)
MyFrame2:SetSize(500, 500)
MyFrame2:SetMovable(true)
MyFrame2:SetClampedToScreen(true)
MyFrame2:EnableMouse(true)
MyFrame2:RegisterForDrag("LeftButton")
MyFrame2:SetScript("OnDragStart",MyFrame2.StartMoving)
MyFrame2:SetScript("OnDragStop",MyFrame2.StopMovingOrSizing)
MyFrame2:SetPoint("CENTER", UIParent, "CENTER", 0, 0)

-- Rahmen erstellen
local bg = MyFrame2:CreateTexture(nil, "BACKGROUND")
bg:SetAllPoints(true)
bg:SetColorTexture(0, 0, 0, 0.7)

-- Hintergrund erstellen
local border = MyFrame2:CreateTexture(nil, "BORDER")
border:SetPoint("TOPLEFT", -3, 3)
border:SetPoint("BOTTOMRIGHT", 3, -3)
border:SetColorTexture(0.5, 0.5, 0.5, 0.5)

MyFrame2:Hide()

-- Label ID
local idLabel2 = MyFrame2:CreateFontString("$parentText", "ARTWORK", "GameFontNormalSmall")
idLabel2:SetScale(1)
idLabel2:SetSize(15, defaultH)
idLabel2:SetPoint("TOPLEFT", MyFrame2, "TOPLEFT", 10, -30)
idLabel2:SetText("ID")

-- ID Inputfield
local idInputfield2 = CreateFrame("EditBox", "id_editbox", MyFrame2, "InputBoxTemplate")
idInputfield2:SetPoint("TOPLEFT", MyFrame2, "TOPLEFT", GetLastObjectEntPoint(idLabel2) + defaultSpace, -30)
idInputfield2:SetSize(80, defaultH)
idInputfield2:SetAutoFocus(false)
idInputfield2:SetNumeric(true)

-- Button der die ID aus dem Inputfeld nimmt und einer Methode übergibt.
local giveItemButton = CreateFrame("Button", "giveitem_button", MyFrame2, "UIPanelButtonTemplate")
giveItemButton:SetText("Give Item")
giveItemButton:SetHeight(defaultH)
giveItemButton:SetWidth(giveItemButton:GetTextWidth() + 20)
giveItemButton:SetPoint("TOPLEFT", MyFrame2, "TOPLEFT", GetLastObjectEntPoint(idInputfield2) + defaultSpace, -30)
giveItemButton:SetScript("OnClick", function()
    local id = tonumber(idInputfield2:GetText())
    if id then
        ShowModel(id)
    end
end)

